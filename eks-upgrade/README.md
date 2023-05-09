## EKS Upgrades (X.XX)

### EKS Upgrade Links
1. [Amazon EKS Kubernetes release calendar](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)
2. [AWS upgrade reference](https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html )
3. [EKS Kubernetes versions](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)
4. [kube-proxy add-on](https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html)
5. [CoreDNS add-on](https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html)
6. [VPC CNI add-on](https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html)

## EKS Upgrade Steps
We have 5 steps:
1. Upgrade the Control Plane
2. Patch kubeproxy
3. Patch CoreDNS
4. Patch AWS CNI
5. Flip the nodes

### Step 01: Upgrade the control plane
- Set EKS control plane to version X.XX in terraform resource for eks control plan, 
- Run terraform plan
- Apply the changes
- You can verify progress in the AWS console , cluster should be marked as updating

### Step 02: Patch kubeproxy
- [Check the image version for each Amazon EKS supported cluster version](https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html)
- Make sure to match version listed in chart on the AWS upgrade doc, example below is from version 1.19 to version 1.20
    - Verify
    ```sh
    kubectl get daemonset kube-proxy \
    --namespace kube-system \
    -o=jsonpath='{$.spec.template.spec.containers[:1].image}'
    ```
    - Output
    ```sh
    602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/kube-proxy:v1.19.6-eksbuild.2
    ```
    - Update , make sure to set the region correctly. This will change the kube-proxy image from 1.19 to 1.20
    ```sh
    kubectl set image daemonset.apps/kube-proxy -n kube-system kube-proxy=602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/kube-proxy:v1.20.4-eksbuild.2
    ```
    - Verify if the kube-proxy pods are running in kube-system ns
    ```
    kubectl get po -n kube-system |grep kube-proxy
    ```

### Step 03: Patch CoreDNS
- [Check the image version for each Amazon EKS supported cluster version](https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html)
- Patch CoreDNS, make sure to match version listed on the AWS upgrade doc, example below is from version 1.19 to version 1.20
    - Verify (Check the CoreDNS version)
    ```
    kubectl describe deployment coredns \
    --namespace kube-system \
    | grep Image \
    | cut -d "/" -f 3
    ```
    - Output:
    ```
    coredns:v1.8.0
    ```
    - Update the CoreDNS (make sure to set the region correctly)
    ```sh
    kubectl set image --namespace kube-system deployment.apps/coredns \
    coredns=602401143452.dkr.ecr.[region_name].amazonaws.com/eks/coredns:v1.8.3-eksbuild.1
    
    kubectl set image --namespace kube-system deployment.apps/coredns \
    coredns=602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/coredns:v1.8.3-eksbuild.1
    ```
    - Edit the cluster role and add the below content at the end if it does not exist
    ```sh
    kubectl edit clusterrole system:coredns -n kube-system
    - apiGroups:
    - discovery.k8s.io
    resources:
    - endpointslices
    verbs:
    - list
    - watch
    ```
    - Verify if the coredns pods are running in kube-system ns
    ```
    kubectl get po -n kube-system |grep coredns
    ```

## Step 04: Patch AWS CNI
- [Check the image version for each Amazon EKS supported cluster version](https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html). [VPC CNI Github release version](https://github.com/aws/amazon-vpc-cni-k8s/tags)
- Patch AWS CNI, make sure to match version listed in chart on the AWS upgrade doc , example below is from version 1.19 to version 1.20
    - Verify (Check the AWS CNI version)
    ```
    kubectl describe daemonset aws-node --namespace kube-system | grep Image | cut -d "/" -f 2
    ```
    - Example output:
    ```
    amazon-k8s-cni-init:v1.11.0-eksbuild.1
    amazon-k8s-cni:v1.11.0-eksbuild.1
    ```
    - Download the image with the your version
    ```sh
    curl -O https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/[YOU_VERSION]/config/master/aws-k8s-cni.yaml
    curl -O curl -O https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/v1.12.6/config/master/aws-k8s-cni.yaml
    ```
    - check the region 
    ```
    cat aws-k8s-cni.yaml |grep us-
    ```
    - Set Region
    ```sh
    sed -i.bak -e 's/us-west-2/[region-code]/' aws-k8s-cni.yaml
    sed -i.bak -e 's/us-west-2/us-east-1/' aws-k8s-cni.yaml
    ```
    - Apply the yaml
    ```sh
    kubectl apply -f aws-k8s-cni.yaml
    ```
    - Check the version again
    ```
    kubectl describe daemonset aws-node --namespace kube-system | grep Image | cut -d "/" -f 2
    ```
    - Check pods
    ```
    kubectl get daemonset aws-node -n kube-system
    ```

## install jq
1. Mac installation
```
brew install jq
```

2. Ubunt installation
```sh
sudo apt update
sudo apt install -y jq
```

## Flip the nodes

1. Check node with labels
```sh
kubectl get no -l deployment.nodegroup=blue
kubectl get no -l deployment.nodegroup=green
```
3. Check if node are tainted
```SH
kubectl get nodes -o json | jq '.items[] | .metadata.name, .spec.taints'

## OR
for kube_node in $(kubectl get nodes | awk '{ print $1 }' | tail -n +2); do
    echo ${kube_node} $(kubectl describe node ${kube_node} | grep Taint);
done
```

2. Taint the current nodes in the cluster ====> [HERE](https://pet2cattle.com/2021/09/k8s-node-untaint)
```sh
## Taint (gpu can be anything)
kubectl taint nodes [NODE_NAME]  gpu=true:NoSchedule
kubectl taint nodes ip-192-168-62-62.ec2.internal gpu=true:NoSchedule

## Untaint (gpu can be anything)
kubectl taint nodes [NODE_NAME]  gpu=true:NoSchedule-
kubectl taint nodes ip-192-168-92-254.ec2.internal gpu=true:NoSchedule-
```

3. Launch a new node group in cluster
- In the node group, change the eks version to match the controle plane version
- Apply the changes to create a new node group
- Wait still the nodes join the cluster

4. Drain the all nodes
```sh
kubectl drain [NODE_NAME] --ignore-daemonsets=false --force  --delete-local-data

kubectl drain ip-192-168-92-254.ec2.internal --ignore-daemonsets=false --force  --delete-local-data
kubectl drain ip-192-168-62-62.ec2.internal --ignore-daemonsets=false --force  --delete-local-data
```

5. Shutdown the old node group through terraform


## notes
```sh
v1.22.6-eksbuild.1
v1.23.16-eksbuild.2

kubectl set image daemonset.apps/kube-proxy -n kube-system kube-proxy=602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/kube-proxy:v1.23.16-eksbuild.2

v1.8.7-eksbuild.4
kubectl set image --namespace kube-system deployment.apps/coredns \
coredns=602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/coredns:v1.8.7-eksbuild.4

v1.10.1-eksbuild.1
v1.12.6-eksbuild.1


kubectl taint nodes [NODE_NAME]  gpu=true:NoSchedule
kubectl taint nodes ip-192-168-62-62.ec2.internal gpu=true:NoSchedule

kubectl taint nodes ip-10-0-1-139.ec2.internal gpu=true:NoSchedule
kubectl taint nodes ip-10-0-1-64.ec2.internal gpu=true:NoSchedule
kubectl taint nodes ip-10-0-2-41.ec2.internal gpu=true:NoSchedule
kubectl taint nodes ip-10-0-2-55.ec2.internal gpu=true:NoSchedule


kubectl drain ip-10-0-1-139.ec2.internal --ignore-daemonsets=true --force  --delete-local-data
kubectl drain ip-10-0-1-64.ec2.internal  --ignore-daemonsets=true --force  --delete-local-data
kubectl drain ip-10-0-2-41.ec2.internal  --ignore-daemonsets=true --force  --delete-local-data
kubectl drain ip-10-0-2-55.ec2.internal  --ignore-daemonsets=true --force  --delete-local-data
```