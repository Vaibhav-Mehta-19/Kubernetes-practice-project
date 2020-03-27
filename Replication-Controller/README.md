# Liveness Probe

- Docker container with name `hn-service-unhealthy` is pushed to Docker Hub registry for this excercise
- The service will send `500` status code after first `5` requests

- Create a `Liveness Probe`

```
apiVersion: v1
kind: Pod
metadata:
  name: hn-service-unhealthy
spec:
  containers:
  - image: classpathio/hn-service-unhealthy
    name: hn-service-unhealthy
    livenessProbe:
      httpGet:
        path: /
        port: 8111
```

- Create the Pod from the above definition

```
kubectl create -f liveness-probe.yaml
pod/hn-unhealthy-service created
```

- Fetch the Pod definition 

```
kubectl get po
NAME                   READY   STATUS    RESTARTS   AGE
hn-unhealthy-service   1/1     Running   0          57s
```

- After few seconds 

```
kubectl get po
NAME                   READY   STATUS    RESTARTS   AGE
hn-unhealthy-service   1/1     Running   1          2m30s
```
`Check the RESTARTS column`

- Check the logs 

```
kubectl logs hn-unhealthy-service  --previous
```

```
 Inside the getHostname method of Controller
Number of requests  5
 Received request from 100.96.1.1You have hit the Server
Your current IP address : hn-unhealthy-service/100.96.1.6
Your current Hostname : hn-unhealthy-service
 Inside the getHostname method of Controller
Number of requests  6
 Inside the getHostname method of Controller
Number of requests  6
 Inside the getHostname method of Controller
Number of requests  6
2020-03-27 10:22:02.860  INFO 1 --- [extShutdownHook] o.s.s.concurrent.ThreadPoolTaskExecutor  : Shutting down ExecutorService 'applicationTaskExecutor'
```

- Configure the initial delay 

```
apiVersion: v1
kind: Pod
metadata:
  name: hn-service-unhealthy-delay
spec:
  containers:
  - image: classpathio/hn-service-unhealthy
    name: hn-service-unhealthy
    livenessProbe:
      httpGet:
        path: /
        port: 8111
      initialDelaySeconds: 30
```

- Create the Pod from the above definition

```
kubectl create -f liveness-probe-with-delay.yaml
pod/hn-unhealthy-service created
```
- Run the `describe` command 

```
kubectl describe po hn-unhealthy- service-delay
```

- View the events and verify the probe fail 
```
Events:
  Type     Reason     Age                From
         Message
  ----     ------     ----               ----
         -------
  Normal   Scheduled  118s               default-scheduler
         Successfully assigned default/hn-unhealthy-service-delay to ip-172-20-70-31.ap-south-1.compute.internal
  Normal   Pulled     115s               kubelet, ip-172-20-70-31.ap-south-1.compute.internal  Successfully pulled image "classpathio/hn-service-unhealthy"
  Normal   Created    115s               kubelet, ip-172-20-70-31.ap-south-1.compute.internal  Created container hn-service-unhealthy
  Normal   Started    114s               kubelet, ip-172-20-70-31.ap-south-1.compute.internal  Started container hn-service-unhealthy
  Normal   Pulling    1s (x2 over 117s)  kubelet, ip-172-20-70-31.ap-south-1.compute.internal  Pulling image "classpathio/hn-service-unhealthy"
  Warning  Unhealthy  1s (x3 over 21s)   kubelet, ip-172-20-70-31.ap-south-1.compute.internal  Liveness probe failed: HTTP probe failed with statuscode: 500
  Normal   Killing    1s                 kubelet, ip-172-20-70-31.ap-south-1.compute.internal  Container hn-service-unhealthy failed liveness probe, will be restarted
```

- Finally delete all the Pods 

```
kubectl delete po --all
pod "hn-unhealthy-service" deleted
pod "hn-unhealthy-service-delay" deleted
```

## Replication Controller 

- Creating a `ReplicationController`
```
apiVersion: v1 
kind: ReplicationController 
metadata: 
  name: hn-service 
spec: 
  replicas: 3 
  selector: 
    app: hn-service-api 
  template: 
     metadata: 
       labels: 
         app: hn-service-api
     spec: 
       containers: 
       - name:  hn-service-container
         image: classpathio/hn-service 
         ports: 
          - containerPort: 8111
          - protocol: TCP
```

- Create the `ReplicationController`

```
kubectl create -f hn-service-rc.yaml
replicationcontroller/hn-service created
```

- Verify the number of Pods 

```
kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
hn-service-5sz5t   1/1     Running   0          67s
hn-service-755n6   1/1     Running   0          67s
hn-service-svv2l   1/1     Running   0          67s
```

- Delete a pod

```
kubectl delete po hn-service-5sz5t
```

```
 kubectl delete po hn-service-5sz5 t
pod "hn-service-5sz5t" deleted
```
- List the pod

```
kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
hn-service-4nc6d   1/1     Running   0          64s
hn-service-755n6   1/1     Running   0          4m23s
hn-service-g6zgl   1/1     Running   0          8s
```

- Get `ReplicationController` information

```
kubectl get rc
NAME         DESIRED   CURRENT   READY   AGE
hn-service   3         3         3       5m52s
```
- Details of the `ReplicationController` created

```
kubectl describe rc hn-service

Name:         hn-service
Namespace:    default
Selector:     app=hn-service-api
Labels:       app=hn-service-api
Annotations:  <none>
Replicas:     3 current / 3 desired
Pods Status:  3 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=hn-service-api
  Containers:
   hn-service-container:
    Image:        classpathio/hn-service
    Port:         8111/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age    From                    Message
  ----    ------            ----   ----                    -------
  Normal  SuccessfulCreate  7m27s  replication-controller  Created pod: hn-service-755n6
  Normal  SuccessfulCreate  7m27s  replication-controller  Created pod: hn-service-5sz5t
  Normal  SuccessfulCreate  7m27s  replication-controller  Created pod: hn-service-svv2l
  Normal  SuccessfulCreate  4m8s   replication-controller  Created pod: hn-service-4nc6d
  Normal  SuccessfulCreate  3m12s  replication-controller  Created pod: hn-service-g6z
```

## Responding to Node failure 

- Choose a node by listing the pods with `-o wide` option

```
kubectl get pods -o wide
```
### Changing the labels to drift from the RC spec

- List the labels of the pods 

```
kubectl get pods --show-labels
NAME               READY   STATUS    RESTARTS   AGE   LABELS
hn-service-4nc6d   1/1     Running   0          34m   app=hn-service-api
hn-service-755n6   1/1     Running   0          37m   app=hn-service-api
hn-service-g6zgl   1/1     Running   0          33m   app=hn-service-api
```
- Overwrite the `app` label

```
kubectl label pod hn-service-4nc6d app=non-existent --overwrite 
pod/hn-service-4nc6d labeled
```

```
kubectl get pods -L app
NAME               READY   STATUS    RESTARTS   AGE   APP
hn-service-4nc6d   1/1     Running   0          36m   non-existent
hn-service-755n6   1/1     Running   0          39m   hn-service-api
hn-service-g6zgl   1/1     Running   0          35m   hn-service-api
hn-service-sl7s9   1/1     Running   0          23s   hn-service-api
```

- Delete a Pod managed by `ReplicationController`

```
kubectl delete po hn-service-755n6
pod "hn-service-755n6" deleted
```

- List the Pods to see the number of managed Pods

```
kubectl get pods -L app
NAME               READY   STATUS    RESTARTS   AGE     APP
hn-service-4nc6d   1/1     Running   0          40m     non-existent
hn-service-g6zgl   1/1     Running   0          39m     hn-service-api
hn-service-h2g5t   1/1     Running   0          13s     hn-service-api
hn-service-sl7s9   1/1     Running   0          4m25s   hn-service-api
```

- Delete the out of sync Pod

```
kubectl delete po hn-service-4nc6d
pod "hn-service-4nc6d" deleted
```

- List the Pods to see the number of managed Pods

```
kubectl get pods -L app
NAME               READY   STATUS    RESTARTS   AGE     APP
hn-service-g6zgl   1/1     Running   0          39m     hn-service-api
hn-service-h2g5t   1/1     Running   0          13s     hn-service-api
hn-service-sl7s9   1/1     Running   0          4m25s   hn-service-api
```

- The above approach can be used to delete unhealty pod

### Scaling the Pods 
- Edit the ReplicationController
```
kubectl edit rc hn-service
```

- List the pods

```
kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
hn-service-6r8td   1/1     Running   0          15s
hn-service-g6zgl   1/1     Running   0          43m
hn-service-h2g5t   1/1     Running   0          4m30s
hn-service-hbpvv   1/1     Running   0          15s
hn-service-kbt88   1/1     Running   0          15s
hn-service-kqjrc   1/1     Running   0          15s
hn-service-l67nc   1/1     Running   0          15s
hn-service-nj4hk   1/1     Running   0          15s
hn-service-qhsq5   1/1     Running   0          15s
hn-service-sl7s9   1/1     Running   0          8m42s
```

- Can be done through command 

```
kubectl scale rc hn-service --replicas=5
replicationcontroller/hn-service scaled
```

- List the pods 

```
kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
hn-service-g6zgl   1/1     Running   0          46m
hn-service-h2g5t   1/1     Running   0          6m59s
hn-service-hbpvv   1/1     Running   0          2m44s
hn-service-nj4hk   1/1     Running   0          2m44s
hn-service-sl7s9   1/1     Running   0          11m
```

- List the RC 

```
kubectl get rc
NAME         DESIRED   CURRENT   READY   AGE
hn-service   5         5         5       51m
```

- Delete the `ReplicationController`

```
kubectl delete rc hn-service --cascade=false 
replicationcontroller "hn-service" deleted
```

- Can again associate another RC with matching Pod selector

```
kubectl create -f hn-service-rc.yaml
replicationcontroller/hn-service created
```

- Now delete the `ReplicationController` along with its associated pods 

```
kubectl delete rc hn-service --cascade=true 
replicationcontroller "hn-service" deleted
```

