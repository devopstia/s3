## EKS Upgrades (X.XX)

### EKS Upgrade Links
1. [Amazon EKS Kubernetes release calendar](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)
2. [AWS upgrade reference](https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html )
3. [EKS Kubernetes versions](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)
4. [kube-proxy add-on](https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html)
5. [CoreDNS add-on][https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html ]
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
    602401143452.dkr.ecr.us-east-2.amazonaws.com/eks/kube-proxy:v1.19.6-eksbuild.2
    ```
    - Update , make sure to set the region correctly. This will change the kube-proxy image from 1.19 to 1.20
    ```sh
    kubectl set image daemonset.apps/kube-proxy -n kube-system kube-proxy=602401143452.dkr.ecr.us-east-2.amazonaws.com/eks/kube-proxy:v1.20.4-eksbuild.2
    ```
    - Verify if the kube-proxy pods are running in kube-system ns
    ```
    k get po -n kube-system |grep kube-proxy
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
    k get po -n kube-system |grep coredns
    ```