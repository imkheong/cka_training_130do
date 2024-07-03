


### Exercise Step 1: Understanding Basic RBAC Concepts

#### Objective:
- Explore existing Roles, RoleBindings, ClusterRoles, ClusterRoleBindings, and ServiceAccounts using `kubectl` commands.

#### Steps:

1. **Setup**
   - Ensure all students can access their Digital Ocean Kubernetes cluster.
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

