# Lab 16 - Troubleshooting and Logging

# Step 1

```sh
kubectl create deployment kubia --image=stv707/kubia:v14

kubectl get deployments

kubectl get pods

kubectl get nodes

kubectl describe deployment kubia

kubectl describe pod <kubia-pod-name>

kubectl logs <kubia-pod-name>

kubectl logs <kubia-pod-name> --previous

kubectl exec -it <kubia-pod-name> -- /bin/bash

kubectl port-forward <kubia-pod-name> 8080:8080

kubectl get events --field-selector involvedObject.kind=Deployment,involvedObject.name=kubia

kubectl top nodes

kubectl top pods

** If you don't get metric, install it by using the below command:
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl set image deployment/kubia kubia=stv707/kubia:v15

kubectl get events --field-selector involvedObject.kind=Deployment,involvedObject.name=kubia
```
END