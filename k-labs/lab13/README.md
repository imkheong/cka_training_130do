# Lab 13
* Install and Verify HELM Charts


# Step 1

- Add Helm Repo / Search and Install a Chart

```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm search repo bitnami/mariadb

helm install my-mariadb bitnami/mariadb

helm list
```

# Step 2

- Verify the installation of MariaDB 

```sh
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default my-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
echo $MARIADB_ROOT_PASSWORD

kubectl get pod 

kubectl get pvc 

kubectl get pv 

kubectl get statefulsets.apps

kubectl get svc --namespace default -l "app.kubernetes.io/name=mariadb,app.kubernetes.io/instance=my-mariadb"

kubectl run my-mariadb-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/mariadb:10.3.22-debian-10-r26 --command -- bash

mysql -h my-mariadb.default.svc.cluster.local -u root 

*use the password from previous command

SHOW DATABASES;
CREATE DATABASE testdb;

exit ; 
exit ; 
```

# Step 3

- Remove HELM chart and verify all kubernetes resources are deleted

```sh
helm list 

helm uninstall my-mariadb

helm list 

kubectl get pod 

kubectl get pvc 
**if pvc is there, delete it manually 

kubectl get pv 

kubectl get statefulsets.apps

```

END