#!/bin/bash

# Variables
USERNAME=jedi
NAMESPACE=jedi
CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')
CLUSTER_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CLUSTER_CA=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')

# Ensure the namespace exists
if ! kubectl get namespace ${NAMESPACE} > /dev/null 2>&1; then
  kubectl create namespace ${NAMESPACE}
else
  echo "Namespace ${NAMESPACE} already exists"
fi

# Create private key and CSR
openssl genrsa -out ${USERNAME}.key 2048
openssl req -new -key ${USERNAME}.key -out ${USERNAME}.csr -subj "/CN=${USERNAME}"

# Create CertificateSigningRequest
CSR_BASE64=$(cat ${USERNAME}.csr | base64 | tr -d "\n")
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${USERNAME}
spec:
  request: ${CSR_BASE64}
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF

# Approve the CSR
kubectl certificate approve ${USERNAME}

# Wait for the certificate to be issued
for i in {1..10}; do
  CERT=$(kubectl get csr ${USERNAME} -o jsonpath='{.status.certificate}' 2>/dev/null)
  if [[ ! -z "$CERT" ]]; then
    break
  fi
  sleep 2
done

if [[ -z "$CERT" ]]; then
  echo "Error: Failed to retrieve the certificate for CSR ${USERNAME}."
  exit 1
fi

# Decode and save the certificate
echo "${CERT}" | base64 --decode > ${USERNAME}.crt

# Create Role with permissions
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: ${NAMESPACE}
  name: ${USERNAME}-role
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log", "services", "endpoints", "persistentvolumeclaims"]
  verbs: ["get", "watch", "list", "create", "update", "delete"]
EOF

# Create RoleBinding
kubectl create rolebinding ${USERNAME}-rolebinding --role=${USERNAME}-role --user=${USERNAME} --namespace=${NAMESPACE}

# Create kubeconfig for the new user
kubectl config set-credentials ${USERNAME} --client-key=${USERNAME}.key --client-certificate=${USERNAME}.crt --embed-certs=true
kubectl config set-context ${USERNAME}-context --cluster=${CLUSTER_NAME} --namespace=${NAMESPACE} --user=${USERNAME}

cat <<EOF > ${USERNAME}-kubeconfig
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${CLUSTER_CA}
    server: ${CLUSTER_SERVER}
  name: ${CLUSTER_NAME}
contexts:
- context:
    cluster: ${CLUSTER_NAME}
    namespace: ${NAMESPACE}
    user: ${USERNAME}
  name: ${USERNAME}-context
current-context: ${USERNAME}-context
preferences: {}
users:
- name: ${USERNAME}
  user:
    client-certificate-data: $(cat ${USERNAME}.crt | base64 | tr -d "\n")
    client-key-data: $(cat ${USERNAME}.key | base64 | tr -d "\n")
EOF

echo "Kubeconfig file for user ${USERNAME} has been created: ${USERNAME}-kubeconfig"
