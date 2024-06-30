# Lab04A
# Step 
Using an emptyDir volume<br>
The yaml file will create 1 pod with 2 containers<br>
The html-generator container will run a script and generate index.html on /var/htdocs <br>
The web-server container will serve index.html from /usr/share/nginx/html/ <br>
Pod: fortune <br>
Container: html-generator mounts html <br>
Container: web-server mount html<br>
the volume html is a emptyDir type <br> 
see fortune-pod.yaml for settings <br>

```sh
cat fortune-pod.yaml

kubectl create -f fortune-pod.yaml

kubectl get po fortune -o=custom-columns=NAME:.metadata.name,CONTAINERS:.spec.containers[*].name

kubectl describe pod fortune 

kubectl exec -i -t fortune --container html-generator  -- /bin/sh
# cat /var/htdocs/index.html
# mount | grep /var/htdocs
# exit

kubectl exec -i -t fortune --container web-server  -- /bin/sh
# cat  /usr/share/nginx/html/index.html
# mount | grep /usr/share/nginx/html
# exit
```

# Lab04B
# Step 
Using an hostPath volume <br>
The yaml file will create 2 pods (mongo-xxx), which will run on both worker node<br>
hostPath volume will mount local worker node path <br>
Data will persists on both worker node as separate data not shared <br>

```sh
cat mongodb-rc-pod-hostpath.yaml
kubectl create -f mongodb-rc-pod-hostpath.yaml

kubectl get pods -o wide | grep mongo 

kubectl get nodes 

kubectl debug node/<node_name_1> -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11
# chroot /host
# ls /tmp/mongodb
# exit
# exit

kubectl debug node/<node_name_2> -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11
# chroot /host
# ls /tmp/mongodb
# exit
# exit

kubectl get pod | grep mongo

kubectl exec -it mongo-<pod1> -- mongosh
> use mystore
> db.foo.insert({name:'foo Pan Pan'})
> db.foo.find()
> exit

kubectl exec -it mongo-<pod2> -- mongosh
> use mystore
> db.bar.insert({name:'bar Pan Pan'})
> db.bar.find()
> exit

kubectl get pods | grep mongo 
kubectl delete pods mongo-<pod1>
kubectl delete pods mongo-<pod1>

kubectl get pods | grep mongo 
kubectl exec -it mongo-<new_pod1> -- mongosh
> use mystore
> db.foo.find()
> exit

kubectl exec -it mongo-<new_pod2> -- mongosh
> use mystore
> db.bar.find()
> exit

kubectl describe rc mongo
```

Cleanup 
```sh
kubectl get pods
kubectl get rc
kubectl delete rc mongo

kubectl get pods
kubectl get rc
```

# Lab04C
# Step
Using Dynamic provisioning of PersistentVolumes<br>
In order to use Dynamic provisioning, you need to use a provisioner <br>
Cloud based Kubernetes provides this<br>

```sh
 kubectl get storageclass

 kubectl get pv
 kubectl get pvc
 
 kubectl apply -f azure-pvc.yaml 
 kubectl get pv
 kubectl get pvc

 kubectl apply -f azure-pod-pvc.yaml
 kubectl get pv
 kubectl get pvc
 
 kubectl exec -it azure-app -- sh
 # df -h /var/nfs
 # ls -l /var/nfs
 # cat /var/nfs/azure-app.txt
 # exit 

 kubectl delete -f azure-pod-pvc.yaml
 kubectl get pvc
 kubectl get pod | grep azure-app 

 kubectl apply -f azure-pod-pvc-2.yaml
 
 kubectl get pod | grep az

 kubectl apply -f azure-pv2.yaml

 kubectl get pod | grep az

 kubectl exec -it azure-app2 -- sh
  # df -h /var/nfs
  # ls -l /var/nfs
  # exit 
 
 kubectl delete -f azure-pod-pvc-2.yaml
 kubectl get pvc

 kubectl delete  -f azure-pvc.yaml

```
END