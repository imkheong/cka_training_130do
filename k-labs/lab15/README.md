## LAB 15A

### Exercise Step 1: Understanding Basic RBAC Concepts

#### Objective:
- Explore existing Roles, RoleBindings, ClusterRoles, ClusterRoleBindings, and ServiceAccounts using `kubectl` commands.

#### Steps:

1. **Setup**
   - Verify admin access and basic cluster status.

2. **Task 1: Explore Existing Roles**
   - **Command**: List all roles in the `default` namespace.

     ```sh
     kubectl get roles -n default
     ```

   - **Output**: Examine the output to understand the existing roles.

     ```sh
     kubectl describe role <role-name> -n default
     ```

3. **Task 2: Explore Existing RoleBindings**
   - **Command**: List all role bindings in the `default` namespace.

     ```sh
     kubectl get rolebindings -n default
     ```

   - **Output**: Examine the output to understand the existing role bindings.

     ```sh
     kubectl describe rolebinding <rolebinding-name> -n default
     ```

4. **Task 3: Explore Existing ClusterRoles**
   - **Command**: List all cluster roles.

     ```sh
     kubectl get clusterroles
     ```

   - **Output**: Examine the output to understand the existing cluster roles.

     ```sh
     kubectl describe clusterrole <clusterrole-name>
     ```

5. **Task 4: Explore Existing ClusterRoleBindings**
   - **Command**: List all cluster role bindings.

     ```sh
     kubectl get clusterrolebindings
     ```

   - **Output**: Examine the output to understand the existing cluster role bindings.

     ```sh
     kubectl describe clusterrolebinding <clusterrolebinding-name>
     ```

6. **Task 5: Explore ServiceAccounts**
   - **Command**: List all service accounts in the `default` namespace.

     ```sh
     kubectl get serviceaccounts -n default
     ```

   - **Output**: Examine the output to understand the existing service accounts.

     ```sh
     kubectl describe serviceaccount <serviceaccount-name> -n default
     ```


### Exercise Step 2: Creating and Managing RBAC Components

#### Objective:
- Practice creating and managing Roles, RoleBindings, ClusterRoles, ClusterRoleBindings, and ServiceAccounts.

#### Steps:

1. **Task 1: Create a Role** 
   - **Command**: Create a Role named `read-pods` in the `rbac-demo` namespace with permission to list pods.

     ```sh 
    kubectl apply -f read-pods-role-yaml
     ```

   - **Verify**: Ensure the Role is created.

     ```sh
     kubectl get roles -n rbac-demo
     kubectl describe role read-pods -n rbac-demo
     ```

2. **Task 2: Create a RoleBinding** 
   - **Command**: Create a RoleBinding named `read-pods-binding` that binds the `read-pods` role to a new service account `pod-reader`.

     ```sh
     kubectl create serviceaccount pod-reader -n rbac-demo
     kubectl create rolebinding read-pods-binding --role=read-pods --serviceaccount=rbac-demo:pod-reader -n rbac-demo
     ```

   - **Verify**: Ensure the RoleBinding is created.

     ```sh
     kubectl get rolebindings -n rbac-demo
     kubectl describe rolebinding read-pods-binding -n rbac-demo
     ```


3. **Task 3: Test Access** 
   - **Command**: Switch context to the `pod-reader` service account and test access.

     ```sh
     kubectl auth can-i list pods --namespace=rbac-demo --as=system:serviceaccount:rbac-demo:pod-reader
     kubectl auth can-i get secrets --as=system:serviceaccount:rbac-demo:pod-reader
     ```

   - **Output**: Ensure the service account has the expected permissions.



# Lab 15B

# Step 1
Create pod with security context (runasuser/group) and verify the pod user/group context 

```sh

cat seccon1.yaml

kubectl apply -f seccon1.yaml 

kubectl get pod

kubectl exec -it seccon1 -- bash

seccon1:/$ id

seccon1:/$ ps aux

seccon1:/$ ls -ld /data/test

seccon1:/$ cd /data/test/

seccon1:/data/test$ echo "This file has the same GID as the parent directory" > demofile

seccon1:/data/test$ ls -l

seccon1:/data/test$ exit

kubectl delete -f seccon1.yaml 
```

# Step 2
Create pod with security context for pod level and container level and verify the pod user/group context 

```sh
cat seccon2.yaml

kubectl apply -f seccon2.yaml

kubectl get pods
** verify 2/2 is in READY state for pod seccon2 

kubectl exec -it seccon2 -c one -- sh

/ $ ps aux

/ $ id

/ $ cd /data/sec

/data/sec $ echo "data from con one pod seccon2" > one.data

/data/sec $ ls -l

/data/sec $ exit

kubectl exec -it seccon2 -c two -- sh

/ $ ps aux

/ $ id

/ $ cd /data/sec

/data/sec $ ls -l 

/data/sec $ cat one.data

/data/sec $ echo "overwrite" > one.data

/data/sec $ echo "data from con two pod seccon2" > two.data

/data/sec $ ls -l

/data/sec $ exit

kubectl delete -f seccon2.yaml

```

# Step 3
Verify securityContext Linux Kernel capabilities ( drop all )

```sh
kubectl get pod
** Make sure kubia-pod still running 

cat seccon3.yaml

kubectl apply -f seccon3.yaml

kubectl get pod -o wide
** note the kubia-pod IP address 

kubectl exec -it seccon3 -- sh

/ # capsh --print
** note: there is no capability granted for this container 

/ # id
** note: the container is running as root

/ # ps aux
** process running under root 

/ # ping <kubia-pod IP>
** ping another container, it should failed, because container do not have network capability 

/ # apk add bash
** install software inside container, it should fail, because filesystem/permission capability not granted

/ # curl <kubia-pod-ip>:8080
** software connection works, API, external access will work, underlying kernel capability is disabled ( secure run )

/ # exit

```


# Step 4
Verify securityContext Linux Kernel capabilities ( allow limited )

```sh
kubectl apply -f seccon4.yaml

kubectl get pod -o wide 

kubectl exec -it seccon4 -- sh

/ # id
** note: the container is running as root

/ # ps aux
** process running under root 

/ # capsh --print
** note: there is capability granted for this container 

/ # ping <kubia-pod IP>
** ping another container, it should work

/ # apk add bash
** install software inside container, it should install

/ # curl <kubia-pod-ip>:8080
** software connection works, API, external access will work

/ # exit

```

# Step 5
Delete/Remove pods

```sh

** Delete all pod to prepare for next lab

```
END