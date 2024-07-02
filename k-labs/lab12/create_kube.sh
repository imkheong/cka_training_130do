#!/bin/bash

namespace=$1

if [[ -z "$namespace" ]]; then
  echo "Usage: $(basename "$0") NAMESPACE"
  exit 1
fi

# Create ServiceAccount, Role, and RoleBinding
echo -e "
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${namespace}-user
  namespace: $namespace
automountServiceAccountToken: true
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ${namespace}-user-full-access
  namespace: $namespace
rules:
- apiGroups: ['', 'extensions', 'apps']
  resources: ['*']
  verbs: ['*']
- apiGroups: ['batch']
  resources:
  - jobs
  - cronjobs
  verbs: ['*']
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ${namespace}-user-view
  namespace: $namespace
subjects:
- kind: ServiceAccount
  name: ${namespace}-user
  namespace: $namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ${namespace}-user-full-access" | kubectl apply -f -

# Wait for the ServiceAccount secret to be created
sleep 15

# Get the secret name
tokenName=$(kubectl get sa ${namespace}-user -n $namespace -o 'jsonpath={.secrets[0].name}')
if [[ -z "$tokenName" ]]; then
  echo "Error: Could not find secret for ServiceAccount ${namespace}-user"
  exit 1
fi

echo "Token Name: $tokenName"

# Get the token
token=$(kubectl get secret $tokenName -n $namespace -o "jsonpath={.data.token}" | base64 --decode)

if [[ -z "$token" ]]; then
  echo "Error: Could not retrieve token"
  exit 1
fi

echo "Token: $token"

# Get current context, cluster name, and server name
context_name=$(kubectl config current-context)
cluster_name=$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"${context_name}\")].context.cluster}")
server_name=$(kubectl config view -o "jsonpath={.clusters[?(@.name==\"${cluster_name}\")].cluster.server}")
certificate_authority_data=$(kubectl config view --raw -o "jsonpath={.clusters[?(@.name==\"${cluster_name}\")].cluster.certificate-authority-data}")

if [[ -z "$context_name" || -z "$cluster_name" || -z "$server_name" || -z "$certificate_authority_data" ]]; then
  echo "Error: Could not retrieve cluster information"
  exit 1
fi

echo "Context Name: $context_name"
echo "Cluster Name: $cluster_name"
echo "Server Name: $server_name"
echo "Certificate Authority Data: $certificate_authority_data"

# Create the kubeconfig file
echo -e "apiVersion: v1
kind: Config
preferences: {}
clusters:
- cluster:
    certificate-authority-data: $certificate_authority_data
    server: $server_name
  name: ${cluster_name}
users:
- name: ${namespace}-user
  user:
    token: $token
contexts:
- context:
    cluster: ${cluster_name}
    namespace: ${namespace}
    user: ${namespace}-user
  name: $namespace
current-context: $namespace" > ${namespace}_kubeconfig

echo "${namespace}-user's kubeconfig was created at $(pwd)/${namespace}_kubeconfig"
