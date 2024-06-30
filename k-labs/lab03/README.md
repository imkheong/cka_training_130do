# Lab03A
# Step
Create Service and Test the Service

```sh
kubectl create -f kubia-svc.yaml
kubectl create -f kubia.yaml
kubectl create -f jump_tool_pod.yaml 

kubectl get svc
kubectl get pods -o wide
*note the IP address of each pod

kubectl exec -it jump1 -- sh 

# curl <ip_kubia-xxxx_pod>:8080
# curl <ip_kubia_service>
# curl kubia 
# exit 

kubectl create -f kubia-api-svc.yaml

kubectl get svc  -o wide
*note the IP address of kubia-api ClusterIP  IP

kubectl exec -it jump1 -- sh 

# curl kubia-api
# curl <ip_kubia_api_service>

# exit 

```

# Lab03B
# Step
Create NodePort Service and Test the Service

```sh
kubectl create -f kubia-svc-nodeport.yaml

kubectl get svc
*Note the NodePort and the port assigned

kubectl get nodes -o wide
*Note the INTERNAL-IP of the nodes

kubectl exec -it jump1 -- sh

# curl <node_1_internal_ip>:30123
# curl <node_2_internal_ip>:30123
# curl <NodePort_IP>
# exit 

```

# Lab03C
# Step
Create LoadBalancer Service and Test the Service
```sh
kubectl create -f kubia-svc-loadbalancer.yaml

kubectl get svc
*The external IP of LoadBalancer type may show pending, rerun kubectl get svc after few minutes

curl http://<External_IP>
```

## Create frontend/backend service based App
* Explore the application source code in ./frontend-vote directory 

```sh 

kubectl apply -f backend-vote.yaml 
kubectl get pod

kubectl apply -f backend-service.yaml
kubectl get svc

kubectl apply -f frontend-vote.yaml
kubectl get pod

kubectl apply -f frontend-service.yaml
kubectl get svc
**Browse the External Ip of frontend-vote
```

>> for next lab(ingress) to work, you might need to delete the LoadBalancer Service to release PIP


# Lab03D
# Step 1

* Install Helm (if not installed): 
```sh
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```
>> we will learn HELM in one of the topic, for now, just follow along

* Add the Ingress NGINX Helm repository:
```sh
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

* Deploy the Ingress Controller:
```sh
helm install nginx-ingress ingress-nginx/ingress-nginx
```

* Verify the Installation:
```sh
kubectl get pods -n default -l app.kubernetes.io/name=ingress-nginx
```

* Get the Load Balancer IP (wait until you get PIP) : 
```sh
kubectl get svc -n default -l app.kubernetes.io/name=ingress-nginx
```

* Pass the Public IP to Steven, so Steven will create  DNS entry as per table below
* DO NOT PROCEED until Public DNS entry is created!!! 

|   PIP    | HostDNS1   | HostDNS2   |   HostDNS3 | 
|-----------|------------|------------|------------|
| XX.XX.XX.XX | app1stu1.cognitoz.my | app2stu1.cognitoz.my | rbstu1.cognitoz.my |
| XX.XX.XX.XX | app1stu2.cognitoz.my | app2stu2.cognitoz.my | rbstu2.cognitoz.my |
| XX.XX.XX.XX | app1stu3.cognitoz.my | app2stu3.cognitoz.my | rbstu3.cognitoz.my |
| XX.XX.XX.XX | app1stu4.cognitoz.my | app2stu4.cognitoz.my | rbstu4.cognitoz.my |
| XX.XX.XX.XX | app1stu5.cognitoz.my | app2stu5.cognitoz.my | rbstu5.cognitoz.my |
| XX.XX.XX.XX | app1stu6.cognitoz.my | app2stu6.cognitoz.my | rbstu6.cognitoz.my |

* run the following to verify the dns entry created 
* replace X with your student number

```sh 
dig app1stuX.cognitoz.my 
```
```sh 
dig app2stuX.cognitoz.my 
```
```sh 
dig rbstuX.cognitoz.my 
```

>> Only Proceed when dig status is NOERROR


# Step 2
Deploy Ingress based Service ( dns based )
* You will deploy two app named app1 and app2 

```sh
cd ./ingress/app1/

kubectl apply -f app1-namespace.yaml 

kubectl get ns

kubectl apply -f app1-backend-service.yaml

kubectl apply -f app1-backend-vote.yaml

kubectl apply -f app1-frontend-service.yaml

kubectl apply -f app1-frontend-vote.yaml 

kubectl get pod -n app1

kubectl get svc -n app1

```
# Step 3 
* Edit the app1-ingress.yaml and add your dns entry 
* Change this entry : - host: app1stux.cognitoz.my  ( x represent your student number )

# Step 4 
```sh 
kubectl apply -f app1-ingress.yaml
kubectl get ingress -n app1 
```
# Step 5 
```sh 
cd ./ingress/app2/
*change directory to app2 

kubectl apply -f app2-namespace.yaml 

kubectl get ns

kubectl apply -f app2-backend-service.yaml

kubectl apply -f app2-backend-vote.yaml

kubectl apply -f app2-frontend-service.yaml

kubectl apply -f app2-frontend-vote.yaml 

kubectl get pod -n app2

kubectl get svc -n app2
```
# Step 6 
* Edit the app1-ingress.yaml and add your dns entry 
* Change this entry : - host: app2stux.cognitoz.my  ( x represent your student number )

# Step 7 
```sh 
kubectl apply -f app2-ingress.yaml
kubectl get ingress -n app2
```

# Step 8 
```sh 
kubectl get ingress -n app1
kubectl get ingress -n app2

* Note the IP Address of the ingress 
* Both app1 and app2 should have same IP address 
* Browse to app1 and app2 using the dns entry 
```

# Lab03F
# Step 1
* Deploy Ingress based Service ( Path )

* In this step you will Deploy Red and Blue App and single ingress to route to both services
* Make sure you are in path-based-ingress directory  ( cd ../../path-based-ingress)

```sh
kubectl apply -f  redblue-namespace.yaml

kubectl apply -f  kubia-red-svc.yaml

kubectl apply -f  kubia-red-rc.yaml

kubectl apply -f  kubia-blue-svc.yaml

kubectl apply -f  kubia-blue-rc.yaml
```
# Step 1A
* Edit the kubia-rb-ingress-updated.yaml and add your dns entry 
* Change this entry : - host: rbstux.cognitoz.my  ( x represent your student number )

```sh
kubectl apply -f  kubia-rb-ingress-updated.yaml
```

# Step 2
```sh 
kubectl get all -n redblue 

kubectl get ingress -n redblue

kubectl describe  ingress kubiaredblue -n redblue
```
* Browse to host address with /blue and /red to view the page


END