# Lab 14
* Demonstrating Taints, Tolerations, and Node Affinity

# Step 1

* Taint NODE1
* Taint NODE1 to prevent pods from being scheduled unless they tolerate the taint.
>> WARNING: remove any pods, deployments from any previous exercise before performing this exercise

```sh
kubectl taint nodes NODE1 key=value:NoSchedule

kubectl apply -f kubia-toleration.yaml

kubectl get pods -o wide

```

# Step 2
* Remove the Taint
* Remove the taint from NODE1 for the next part of the exercise.

```sh
kubectl taint nodes NODE1 key:NoSchedule-
```

# Step 3
* Create a Deployment with Node Affinity
>> Modify kubia-node-affinity.yaml and update the nodename with your actual nodename

```sh
kubectl apply -f kubia-node-affinity.yaml

kubectl get pods -o wide

```

# Step
* Clean up any pods/deployments


END