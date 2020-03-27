# Pods

## Working with Pods
1. Create Pod using the `run` command 

```
 kubectl run --generator=run-pod/v1 nginx-pod --image=nginx
```
2. Create Pod using the Pod definition

```
apiVersion: v1
kind: Pod
metadata:
  name: hn-service-pod
spec:
  containers:
  - image: classpathio/hn-service
    name: hn-service-container
    ports:
    - containerPort: 8011
      protocol: TCP
```

3. List all the Pods

```
kubectl get po

NAME             READY   STATUS    RESTARTS   AGE
hn-service-pod   1/1     Running   0          47s
nginx-pod        1/1     Running   0          5m55s
```
3. Explain command 
```
kubectl explain pods

kubectl explain pods.spec
```
4. Fetch the resource description 

```
kubectl get po hn-service-pod -o yaml

kubectl get po hn-service-pod -o json
```
6. Describe the Pod
```
kubectl describe po hn-service-pod
```

7. Fetch the logs
```
kubectl logs hn-service-pod
```

8. Fetch the `container` logs when multiple containers are running inside a `Pod`
```
kubectl logs hn-service-pod -c hn-service-container
```
9. Port forwarding from the host to the pod 
```
kubectl port-forward hn-service-pod 8111:8111

Forwarding from 127.0.0.1:8111 -> 8111
Forwarding from [::1]:8111 -> 8111
```
10. Verify the Pod response 
```
curl localhost:8111
{ "hostname":"hn-service-pod" }
```

## Working with Labels 
- Manifest file 
```
apiVersion: v1
kind: Pod
metadata:
  name: hn-service-pod-label
  labels: 
    env: dev
    creation_method: manual
spec:
  containers:
  - image: classpathio/hn-service
    name: hn-service-container
    ports:
    - containerPort: 8011
      protocol: TCP
```
-  Create Pod from the Manifest file
```
kubectl create -f hn-service-pod-label.yaml
```
- Display the pods with `Labels`
```
kubectl get po --show-labels
NAME                   READY   STATUS    RESTARTS   AGE   LABELS
hn-service-pod         1/1     Running   0          49m   <none>
hn-service-pod-label   1/1     Running   0          10m   creation_method=manual,env=dev
nginx-pod              1/1     Running   0          54m   run=nginx-pod
```

- Display the pods with Lables using `-L` option

```
kubectl get po -L creation_method
NAME                   READY   STATUS    RESTARTS   AGE   CREATION_METHOD
hn-service-pod         1/1     Running   0          51m
hn-service-pod-label   1/1     Running   0          12m   manual
nginx-pod              1/1     Running   0          56m
```

```
kubectl get po -L creation_method,env
NAME                   READY   STATUS    RESTARTS   AGE   CREATION_METHOD   ENV
hn-service-pod         1/1     Running   0          51m
hn-service-pod-label   1/1     Running   0          12m   manual            dev
nginx-pod              1/1     Running   0          56m
```

- Creating label after the pod is created

```
kubectl label po hn-service-pod env=dev

kubectl label po hn-service-pod creation_method=manual notes=test
pod/hn-service-pod labeled
```

- List the pod with labels 

```
kubectl get po -L notes

NAME                   READY   STATUS    RESTARTS   AGE   NOTES
hn-service-pod         1/1     Running   0          62m   test
hn-service-pod-label   1/1     Running   0          22m
nginx-pod              1/1     Running   0          67m
```
- Overwrite a Label value with `--overwrite` flag
```
kubectl label po hn-service-pod env=prod --overwrite
```
- List the Pods with label 
```
kubectl get po -L env

NAME                   READY   STATUS    RESTARTS   AGE   ENV
hn-service-pod         1/1     Running   0          66m   prod
hn-service-pod-label   1/1     Running   0          27m   dev
nginx-pod              1/1     Running   0          71m
```
## Filtering Pods by applying Label selector
```
kubectl get po -L env
NAME                   READY   STATUS    RESTARTS   AGE   ENV
hn-service-pod         1/1     Running   0          70m   prod
hn-service-pod-label   1/1     Running   0          31m   dev
nginx-pod              1/1     Running   0          75m
```

```
kubectl get po -l env=dev
NAME                   READY   STATUS    RESTARTS   AGE
hn-service-pod-label   1/1     Running   0          31m
[ec2-user@ip-172-31-36-76 pods]$ kubectl get po -l env=prod
```
```
kubectl get po -l env=dev
NAME                   READY   STATUS    RESTARTS   AGE
hn-service-pod-label   1/1     Running   0          32m
```
- Using `!` operator on the `label` name 
```
kubectl get po -l '!env'
NAME        READY   STATUS    RESTARTS   AGE
nginx-pod   1/1     Running   0          80m
```
- Using `in` operator
```
kubectl get po -l 'env in (dev,prod)'
NAME                   READY   STATUS    RESTARTS   AGE
hn-service-pod         1/1     Running   0          80m
hn-service-pod-label   1/1     Running   0          41m
```

- Using `notin` operator
```
kubectl get po -l 'env notin (dev,prod)'
NAME        READY   STATUS    RESTARTS   AGE
nginx-pod   1/1     Running   0          86m
```
- Using multiple selectors
```
kubectl get po --show-labels -l env=prod,env!=dev
NAME             READY   STATUS    RESTARTS   AGE   LABELS
hn-service-pod   1/1     Running   0          85m   creation_method=manual,env=prod,notes=test
```
- Deleting a label
  
```
kubectl label po hn-service-pod env-
pod/hn-service-pod labeled
```

## Applying Labels to Node Resource 
- Fetch all the Nodes in the cluster
```
kubectl get nodes
NAME                                           STATUS   ROLES    AGE    VERSION
ip-172-20-43-227.ap-south-1.compute.internal   Ready    master   115m   v1.16.7
ip-172-20-49-73.ap-south-1.compute.internal    Ready    node     114m   v1.16.7
ip-172-20-70-31.ap-south-1.compute.internal    Ready    node     114m   v1.16.7
ip-172-20-73-76.ap-south-1.compute.internal    Ready    node     114m   v1.16.7
```
- Applying the label to a Node
```
kubectl label node ip-172-20-49-73.ap-south-1.comput e.internal gpu=true
node/ip-172-20-49-73.ap-south-1.compute.internal labeled
```

- List the Nodes with the Label `gpu`

```
kubectl get nodes -L gpu
NAME                                           STATUS   ROLES    AGE    VERSION   GPU 
ip-172-20-43-227.ap-south-1.compute.internal   Ready    master   120m   v1.16.7
ip-172-20-49-73.ap-south-1.compute.internal    Ready    node     118m   v1.16.7   true
ip-172-20-70-31.ap-south-1.compute.internal    Ready    node     118m   v1.16.7
ip-172-20-73-76.ap-south-1.compute.internal    Ready    node     118m   v1.16.7
```

- Scheduling the Pod to the specific Node
```
kubectl create -f hn-service-pod-label-node-selector .yaml
pod/hn-service-pod-label-gpu created
```
- The Node with the label `gpu` is selected for scheduling
```
kubectl describe po hn-service-pod-label-gpu
Name:         hn-service-pod-label-gpu
Namespace:    default
Priority:     0
Node:         ip-172-20-49-73.ap-south-1.compute.internal/172.20.49.73
Start Time:   Fri, 27 Mar 2020 08:11:47 +0000
Labels:       creation_method=manual
              env=dev
```

## Annotating Pods 

- List the Pods
```
kubectl get po
NAME                       READY   STATUS    RESTARTS   AGE
hn-service-pod             1/1     Running   0          106m
hn-service-pod-label       1/1     Running   0          67m
hn-service-pod-label-gpu   1/1     Running   0          9m15s
nginx-pod                  1/1     Running   0          111m
```

- Add annotation 
```
kubectl annotate po hn-service-pod classpathio/type= "backend API"
pod/hn-service-pod annotated
```

- Run the `describe` command 

```
kubectl describe po hn-service-pod
Name:         hn-service-pod
Namespace:    default
Priority:     0
Node:         ip-172-20-70-31.ap-south-1.compute.internal/172.20.70.31
Start Time:   Fri, 27 Mar 2020 06:34:34 +0000
Labels:       creation_method=manual
              env=prod
              notes=test
Annotations:  classpathio/type: backend API
              kubernetes.io/limit-ranger: LimitRanger plugin set: cpu request for container hn-service-container
Status:       Running
IP:           100.96.1.3
IPs:
  IP:  100.96.1.3
```

## Namespace
- List the namespace
```
kubectl get ns
NAME              STATUS   AGE
default           Active   166m
kube-node-lease   Active   166m
kube-public       Active   166m
kube-system       Active   166m
```
- List resources under the namespace
```
kubectl get po --namespace kube-system
NAME                                                                   READY   STATUS
   RESTARTS   AGE
dns-controller-5769c5f8b6-nhznh                                        1/1     Running
   0          172m
etcd-manager-events-ip-172-20-43-227.ap-south-1.compute.internal       1/1     Running
   0          172m
etcd-manager-main-ip-172-20-43-227.ap-south-1.compute.internal         1/1     Running
   0          172m
kops-controller-p4b8n                                                  1/1     Running
   0          172m
[ec2-user@ip-172-31-36-76 pods]$ kubectl get po -n  kube-system
NAME                                                                   READY   STATUS
   RESTARTS   AGE
dns-controller-5769c5f8b6-nhznh                                        1/1     Running
   0          173m
...
```

## Namespace
- Create a `Namespace`

```
apiVersion: v1
kind: Namespace

metadata:
  name: classpath-dev-namespace
```

```
kubectl create -f classpath-dev-namespace.yaml 
namespace/classpath-dev-namespace created
```

- Alternate way of creating a `Namespace`

```
kubectl create namespace classpath-qa-namespace 
namespace/classpath-qa-namespace created
```

- Creating resource inside the `namespace`

```
kubectl create -f hn-service-pod-label.yaml -n "classpath-dev-namespace"
pod/hn-service-pod-label created
```

- List the resources by namespace 
```
kubectl get po -n classpath-dev-namespace
NAME                   READY   STATUS    RESTARTS   AGE
hn-service-pod-label   1/1     Running   0          113s
```

## Stopping Pods 
- Deleting a Pod
  
```
kubectl delete po nginx-pod
pod "nginx-pod" deleted
```

- Deleting multiple Pods 

```
kubectl delete po nginx-pod, hn-service-pod-label
pod "hn-service-pod-label" deleted
pod "nginx-pod" deleted
```

- Deleting Pod by Label
  
```
kubectl delete po -l env=dev
pod "hn-service-pod" deleted
```

- Deleting Pods by deleting the namespace

```
kubectl delete ns classpath-dev-namespace
namespace "classpath-dev-namespace" deleted
```
- Verify that the pods and the namespace is deleted

```
kubectl get pod -n classpath-dev-namespace
No resources found in classpath-dev-namespace namespace.
```

- Deleting all the Pods and retaining the namespace 
```
kubectl delete po --all
pod "hn-service-pod-label-gpu" deleted
```
