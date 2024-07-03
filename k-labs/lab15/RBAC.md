
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

     ```yaml
     cat <<EOF | kubectl apply -f -
     apiVersion: rbac.authorization.k8s.io/v1
     kind: Role
     metadata:
       namespace: rbac-demo
       name: read-pods
     rules:
     - apiGroups: [""]
       resources: ["pods"]
       verbs: ["get", "list"]
     EOF
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

3. **Task 3: Create a ClusterRole** 
   - **Command**: Create a ClusterRole named `view-secrets` with permission to get, list, and watch secrets across the cluster.

     ```yaml
     cat <<EOF | kubectl apply -f -
     apiVersion: rbac.authorization.k8s.io/v1
     kind: ClusterRole
     metadata:
       name: view-secrets
     rules:
     - apiGroups: [""]
       resources: ["secrets"]
       verbs: ["get", "list", "watch"]
     EOF
     ```

   - **Verify**: Ensure the ClusterRole is created.

     ```sh
     kubectl get clusterroles
     kubectl describe clusterrole view-secrets
     ```

4. **Task 4: Create a ClusterRoleBinding** 
   - **Command**: Create a ClusterRoleBinding named `view-secrets-binding` that binds the `view-secrets` role to the `pod-reader` service account.

     ```sh
     kubectl create clusterrolebinding view-secrets-binding --clusterrole=view-secrets --serviceaccount=rbac-demo:pod-reader
     ```

   - **Verify**: Ensure the ClusterRoleBinding is created.

     ```sh
     kubectl get clusterrolebindings
     kubectl describe clusterrolebinding view-secrets-binding
     ```

5. **Task 5: Test Access** 
   - **Command**: Switch context to the `pod-reader` service account and test access.

     ```sh
     kubectl auth can-i list pods --namespace=rbac-demo --as=system:serviceaccount:rbac-demo:pod-reader
     kubectl auth can-i get secrets --as=system:serviceaccount:rbac-demo:pod-reader
     ```

   - **Output**: Ensure the service account has the expected permissions.