# Lab12A
# Step 1
Limiting resources available to a pods/containers
```sh

**Request Resource 

cat requests-pod.yaml

kubectl apply -f requests-pod.yaml 

kubectl exec -it requests-pod -- sh 
> top 
> exit

kubectl get pod -o wide requests-pod
 * identify the node the pod is running on

kubectl describe nodes <request_pod_running_node>

kubectl apply -f requests-pod-2.yaml 

kubectl apply -f requests-pod-3.yaml 

kubectl apply -f requests-pod-4.yaml 

kubectl apply -f requests-pod-5.yaml 

kubectl get pod -o wide
* identify the node the request-pod(2-5) is running on

kubectl describe nodes <request_pod_running_node>

kubectl describe po requests-pod-5

kubectl get pods -o wide
* identify the node the request-pod-4 is running on

kubectl describe nodes <request_pod_running_node>
* where request-pod-4 is running 

kubectl delete po requests-pod-4 --force

kubectl describe nodes <request_pod_running_node>
* where request-pod-4 was running 

kubectl get pods 

kubectl delete pod requests-pod-2 requests-pod-3 requests-pod-5 requests-pod  --force 

**Explore limits
kubectl create -f limited-pod.yaml

kubectl get pods -o wide

kubectl describe nodes (node where the pod is running)

kubectl delete  -f  limited-pod.yaml --force

**Some memory test 

kubectl apply -f memoryhog.yaml
kubectl get pods --watch 

**Check the detail on what happen? 
kubectl describe pod memoryhog 

kubectl delete -f memoryhog.yaml --force 

**Explore limitsranges

kubectl create ns dev

kubectl apply -f limits.yaml

kubectl get limitranges -n dev 

kubectl describe limitranges devlimit -n dev 

kubectl apply -f kubia-manual.yaml
kubectl get pod

kubectl describe pod kubia-manual

```

# Step 2A

* In the exercise, open 2 terminal. 

* Create User Called jedi in your Linux system and Namespace called jedins

```sh 

sudo adduser jedi
* use any password and leave all other fields blank 

kubectl create namespace jedins
* our namespace will be jedins
```

```sh 

stuX@vm001:~$ sudo bash -c 'mkdir /home/jedi/.kube/'

stuX@vm001:~$ sudo bash -c 'cat /home/stux/.kube/config > /home/jedi/.kube/config'

stuX@vm001:~$ sudo chown jedi:jedi /home/jedi/.kube/

stuX@vm001:~$ sudo chown jedi:jedi /home/jedi/.kube/config

stuX@vm001:~$ sudo cp kcsr.yaml /home/jedi/

stuX@vm001:~$ sudo chown jedi:jedi /home/jedi/kcsr.yaml 

stuX@vm001:~$ sudo su - jedi 

jedi@vm000:~$ kubectl cluster-info

jedi@vm000:~$ openssl genrsa -out jedi.key 2048

jedi@vm000:~$ openssl req -new -key jedi.key -out jedi.csr -subj "/CN=jedi"

jedi@vm000:~$ cat jedi.csr | base64 | tr -d "\n"
* copy the base64 into "REPLACE ME" in kcsr.yaml

* you will able to perform cluster admin task such as creating roles & rolebinding, as user jedi, because user jedi have admin kubeconfig
* in real environment, everything is done by admin and admin will configure and pass kubeconfig to regular user

jedi@vm000:~$ kubectl apply -f kcsr.yaml 

jedi@vm000:~$ kubectl get csr

jedi@vm000:~$ kubectl certificate approve jedi

jedi@vm000:~$ kubectl get csr jedi -o jsonpath='{.status.certificate}'| base64 -d > jedi.crt

jedi@vm000:~$ kubectl create role jedidev --namespace=jedins --verb=create --verb=get --verb=list --verb=update --verb=delete --resource=pods,deployments,replicasets

jedi@vm000:~$ kubectl create rolebinding jedidev-binding-jedi --role=jedidev --user=jedi --namespace jedins

jedi@vm000:~$ kubectl config set-credentials jedi --client-key=jedi.key --client-certificate=jedi.crt --embed-certs=true

jedi@vm000:~$ kubectl config set-context jedi --cluster=(REPLACE WITH CLUSTER NAME) --user=jedi
* you can use kubectl config view to retrieve CLuster Name

jedi@vm000:~$ kubectl config use-context jedi

jedi@vm000:~$ kubectl get pods 
* you will be forbidden

jedi@vm000:~$ kubectl get pods -n jedi 

```

# Step 2B ( UPDATE )
 * Apply jedi Resource Quota 

```sh

* create hard limit quota
stuX@vm001:~$ kubectl apply -f quota-pod_jedi.yaml --namespace=jedins 


* copy quota_test_jedi.yaml to jedi user $HOME
stuX@vm001:~$ sudo cp quota_test_jedi.yaml  ~jedi



* update Access

stuX@vm001:~$ sudo bash -c 'chown -R jedi:jedi /home/jedi/quota_test_jedi.yaml'

stuX@vm001:~$ sudo su - jedi

jedi@vm001:~$ kubectl apply -f quota_test_jedi.yaml

*check the pods / deployments 

jedi@vm001:~$ kubectl describe resourcequotas jedi-quota

jedi@vm001:~$ kubectl get pods 

jedi@vm001:~$ exit



stuX@vm001:~$ kubectl  apply -f limits2.yaml

stuX@vm001:~$ sudo su - jedi

jedi@vm001:~$ kubectl get pods

jedi@vm001:~$ kubectl  get deployments

jedi@vm001:~$ kubectl describe limitranges

jedi@vm001:~$ kubectl  apply -f quota_test_jedi.yaml

jedi@vm001:~$ kubectl describe resourcequotas jedi-quota

jedi@vm001:~$ kubectl  get deployments 

jedi@vm001:~$ kubectl get pods

jedi@vm001:~$ exit 

stuX@vm001:~$ kubectl get events -n jedins 

exit

```

# FINAL STEP 

>> WARNING: Delete user jedi from linux host, linux host are exposed to internet!! 

```sh

sudo userdel -r jedi

```

END