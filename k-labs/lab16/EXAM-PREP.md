## CKA EXAM MOCK Practice

### Question 1: Cluster Architecture, Installation & Configuration

**Objective: Install and configure a Kubernetes cluster**

**Scenario:**
You are tasked with setting up a Kubernetes cluster using `kubeadm`. Ensure that:
- The control plane node is named `master-node` with the hostname `master`.
- The worker node is named `worker-node` with the hostname `worker`.
- The Pod network CIDR is `10.244.0.0/16`.

**Steps:**
1. Initialize the control plane node.
2. Join the worker node to the cluster.
3. Verify the cluster status.

**Solution:**
1. Initialize the control plane node:
   ```sh
   kubeadm init --apiserver-advertise-address=<master-node-ip> --pod-network-cidr=10.244.0.0/16
   ```
   Follow the output instructions to set up `kubectl` for the master node.
   
2. Install a Pod network add-on (e.g., Flannel):
   ```sh
   kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
   ```

3. Join the worker node:
   ```sh
   kubeadm join <master-node-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
   ```

4. Verify the cluster status:
   ```sh
   kubectl get nodes
   ```

### Question 2: Workloads & Scheduling

**Objective: Create and manage a deployment**

**Scenario:**
Create a deployment named `web-deploy` with the following requirements:
- The deployment runs 3 replicas of the `nginx` container.
- The container image should be `nginx:1.14.2`.
- Expose the deployment on port 80.

**Steps:**
1. Create the deployment.
2. Verify that the deployment is running with 3 replicas.

**Solution:**
1. Create the deployment:
   ```sh
   kubectl create deployment web-deploy --image=nginx:1.14.2 --replicas=3
   ```

2. Expose the deployment:
   ```sh
   kubectl expose deployment web-deploy --port=80 --target-port=80
   ```

3. Verify the deployment:
   ```sh
   kubectl get deployments
   kubectl get pods
   ```

### Question 3: Services & Networking

**Objective: Create and manage Kubernetes services**

**Scenario:**
You need to create a service that exposes the `web-deploy` deployment created in Question 2. Ensure that:
- The service is of type `NodePort`.
- The service maps port 80 on the container to port 30080 on the nodes.

**Steps:**
1. Create the service.
2. Verify the service.

**Solution:**
1. Create the service:
   ```sh
   kubectl expose deployment web-deploy --type=NodePort --port=80 --target-port=80 --name=web-service
   kubectl patch service web-service -p '{"spec":{"ports":[{"port":80,"nodePort":30080}]}}'
   ```

2. Verify the service:
   ```sh
   kubectl get svc web-service
   ```

### Question 4: Storage

**Objective: Manage Kubernetes storage objects**

**Scenario:**
You need to create a PersistentVolume (PV) and a PersistentVolumeClaim (PVC) to be used by a pod. Ensure that:
- The PV is named `mypv` with a capacity of `1Gi`.
- The PVC is named `mypvc` and requests `1Gi` of storage.
- The access mode for both the PV and PVC is `ReadWriteOnce`.

**Steps:**
1. Create the PV.
2. Create the PVC.
3. Verify that the PVC is bound to the PV.

**Solution:**
1. Create the PV:
   ```yaml
   apiVersion: v1
   kind: PersistentVolume
   metadata:
     name: mypv
   spec:
     capacity:
       storage: 1Gi
     accessModes:
       - ReadWriteOnce
     hostPath:
       path: /mnt/data
   ```
   ```sh
   kubectl apply -f mypv.yaml
   ```

2. Create the PVC:
   ```yaml
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: mypvc
   spec:
     accessModes:
       - ReadWriteOnce
     resources:
       requests:
         storage: 1Gi
   ```
   ```sh
   kubectl apply -f mypvc.yaml
   ```

3. Verify the PVC:
   ```sh
   kubectl get pvc
   ```

### Question 5: Troubleshooting

**Objective: Troubleshoot Kubernetes clusters**

**Scenario:**
A pod named `app-pod` is not starting correctly. You need to identify and fix the issue. The pod should use the `nginx:1.14.2` image and be exposed on port 80. Investigate why the pod is not running and resolve the issue.

**Steps:**
1. Check the status of the pod.
2. Inspect the events and logs for the pod.
3. Resolve any issues found.

0. Apply app-pod to kubernetes
```sh 
kubectl apply app-pod-error.yaml
```

**Solution:**
1. Check the status of the pod:
   ```sh
   kubectl get pods app-pod
   ```

2. Describe the pod to inspect events:
   ```sh
   kubectl describe pod app-pod
   ```

3. View logs for the pod:
   ```sh
   kubectl logs app-pod
   ```

4. Resolve issues based on findings (e.g., fixing incorrect image name, insufficient resources, etc.):
   ```sh
   kubectl edit pod app-pod
   ```
   Make necessary changes, such as correcting the image name or increasing resource limits.

   Certainly, Steve! Here are five additional mock CKA exam simulation questions with solutions.

### Question 6: Application Lifecycle Management

**Objective: Scale applications**

**Scenario:**
You need to scale the `web-deploy` deployment created earlier to 5 replicas.

**Steps:**
1. Scale the deployment.
2. Verify the scaling operation.

**Solution:**
1. Scale the deployment:
   ```sh
   kubectl scale deployment web-deploy --replicas=5
   ```

2. Verify the scaling operation:
   ```sh
   kubectl get deployments
   kubectl get pods
   ```



### Question 7: Troubleshooting

**Objective: Troubleshoot application failures**

**Scenario:**
A pod named `backend-pod` is experiencing a crash loop. Investigate and resolve the issue. The pod should use the `busybox` image and run a command that sleeps for 3600 seconds.

**Steps:**
1. Check the status of the pod.
2. Inspect the events and logs for the pod.
3. Resolve any issues found.

**Solution:**
1. Check the status of the pod:
   ```sh
   kubectl get pods backend-pod
   ```

2. Describe the pod to inspect events:
   ```sh
   kubectl describe pod backend-pod
   ```

3. View logs for the pod:
   ```sh
   kubectl logs backend-pod
   ```

4. Resolve issues based on findings (e.g., fixing incorrect command):
   Edit the pod configuration to use the correct command:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: backend-pod
   spec:
     containers:
     - name: busybox-container
       image: busybox
       command: ["sh", "-c", "sleep 3600"]
   ```
   Apply the new configuration:
   ```sh
   kubectl apply -f backend-pod.yaml
   ```

### Question 8: Logging and Monitoring

**Objective: Set up cluster-level logging**

**Scenario:**
You need to set up Fluentd to collect logs from all nodes in the cluster and send them to a central logging system.

**Steps:**
1. Deploy Fluentd as a DaemonSet.
2. Verify Fluentd is running on all nodes.

**Solution:**
1. Create the Fluentd DaemonSet:
   ```yaml
   apiVersion: apps/v1
   kind: DaemonSet
   metadata:
     name: fluentd
   spec:
     selector:
       matchLabels:
         name: fluentd
     template:
       metadata:
         labels:
           name: fluentd
       spec:
         containers:
         - name: fluentd
           image: fluent/fluentd:latest
           env:
           - name: FLUENTD_ARGS
             value: "--no-supervisor -q"
           volumeMounts:
           - name: varlog
             mountPath: /var/log
           - name: varlibdockercontainers
             mountPath: /var/lib/docker/containers
             readOnly: true
         volumes:
         - name: varlog
           hostPath:
             path: /var/log
         - name: varlibdockercontainers
           hostPath:
             path: /var/lib/docker/containers
   ```
   Apply the DaemonSet:
   ```sh
   kubectl apply -f fluentd-daemonset.yaml
   ```

2. Verify Fluentd is running on all nodes:
   ```sh
   kubectl get daemonset fluentd
   ```