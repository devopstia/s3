## How to export the cluster .kube/config file?
1- Login in AWS using the CLI first with your secret and access key

2- Run the below command to export the .kube/config file in your home directory
```
aws eks update-kubeconfig --name [cluster_name] --region [region]
aws eks update-kubeconfig --name 2560-adl-dev --region us-east-1 --profile=readonly
```
Example: 
```
aws eks update-kubeconfig --name 2560-adl-dev --region us-east-1
aws eks update-kubeconfig --name 2560-adl-dev --region us-east-1 --alias=alpha-nonprod
aws eks update-kubeconfig --name 2560-adl-dev --region us-east-1 --alias=alpha-nonprod --profile=readonly
aws eks update-kubeconfig --name 2560-adl-dev --region us-east-1 --profile=readonly
```

## Check node with labels
- https://www.devopsschool.com/blog/deep-dive-into-kubernetes-taint-with-node/
```
kubectl get no -l deployment.nodegroup=blue
kubectl get no -l deployment.nodegroup=green

kubectl get no -l deployment.nodegroup=blue |awk -F" " '{print$1}'
kubectl get no -l deployment.nodegroup=green |awk -F" " '{print$1}'

NODE=`kubectl get no -l deployment.nodegroup=blue |awk -F" " '{print$1}'`
for i in $NODE
do 
  kubectl taint $i $i=DoNotSchedulePods:NoExecute
  kubectl drain $i
done


kubectl taint nodes node2 node2=DoNotSchedulePods:NoExecute
```


## Check you current context 
```
kubectl config get-contexts
```

## Login with assume role readonly
https://aws.amazon.com/premiumsupport/knowledge-center/amazon-eks-cluster-access/
https://aws.amazon.com/premiumsupport/knowledge-center/eks-iam-permissions-namespaces/
```sh
# Export AWS Account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
echo $ACCOUNT_ID

# Assume IAM Role
aws sts assume-role --role-arn "arn:aws:iam::<REPLACE-YOUR-ACCOUNT-ID>:role/eks-admin-role" --role-session-name eksadminsession

aws sts assume-role --role-arn "arn:aws:iam::$ACCOUNT_ID:role/EKS-Readonly-Role" --role-session-name eksadminsession

# GET Values and replace here
export AWS_ACCESS_KEY_ID=RoleAccessKeyID
export AWS_SECRET_ACCESS_KEY=RoleSecretAccessKey
export AWS_SESSION_TOKEN=RoleSessionToken

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=

## Sample Output
aws sts get-caller-identity
{
    "UserId": "AROASUF7HC7SRFLFPNG7F:eksadminsession",
    "Account": "180789647333",
    "Arn": "arn:aws:sts::180789647333:assumed-role/hr-dev-eks-readonly-role/eksadminsession"
}

# Configure kubeconfig for kubectl
aws eks --region <region-code> update-kubeconfig --name <cluster_name>
aws eks --region us-east-1 update-kubeconfig --name 2560-adl-dev 


unset AWS_ACCESS_KEY_ID
unset AWS_SESSION_TOKEN
unset AWS_SECRET_ACCESS_KEY
```




## Cluster public end point or API server end point
- This is the end point that we use to access EKS API through  `kubectl` CLI. It should in the public subnet so that the end users can access it. 
- nslookup will display the public IP that end point is using
- "https://66F9A55FD4E767E8D30374F8E2089C06.gr7.us-east-1.eks.amazonaws.com"
```
nslookup 66F9A55FD4E767E8D30374F8E2089C06.gr7.us-east-1.eks.amazonaws.com
Server:         127.0.0.53
Address:        127.0.0.53#53

Non-authoritative answer:
Name:   66F9A55FD4E767E8D30374F8E2089C06.gr7.us-east-1.eks.amazonaws.com
Address: 3.228.196.13
Name:   66F9A55FD4E767E8D30374F8E2089C06.gr7.us-east-1.eks.amazonaws.com
Address: 35.171.69.38
```

## Connect to ubuntu instance in the private subnet
```
cd /temp
ssh -i "jenkins-key.pem" ubuntu@10.0.18.195
```

## Connect to EKS node from the bastion host
```
cd /temp
ssh -i "jenkins-key.pem" ec2-user@10.0.18.195
```

## kubelet information
```
systemctl status kubelet
ps -aux |grep kubelet
```
- it has the control plane API end point to communicate with the API server
- it has the control plane API server information
- It is using the public IP to connect to the control plan
```
cat /var/lib/kubelet/kubeconfig
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/pki/ca.crt
    server: https://66F9A55FD4E767E8D30374F8E2089C06.gr7.us-east-1.eks.amazonaws.com
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubelet
  name: kubelet
current-context: kubelet
users:
- name: kubelet
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: /usr/bin/aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "2560-adl-dev"
        - --region
```

## kube-proxy information
It does not have a daemon
```
ps -aux |grep kube-proxy
```

## Docker information
```
ps -aux |grep docker
systemctl status docker
docker --version
```

## Verify Pod Infra Container for Kubelete
Example: --pod-infra-container-image=602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/pause:3.1-eksbuild.1
Observation:
1. This Pod Infra container will be downloaded from AWS Elastic Container Registry ECR
2. All the EKS related system pods also will be downloaded from AWS ECR only


## Terraform EKS Nodegroups with custom Launch Templates
https://wangpp.medium.com/terraform-eks-nodegroups-with-custom-launch-templates-5b6a199947f


## AWS EKS AMI type
https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html





## EKS OpenID Connect Well Known Configuration URL
- We can also call it as `OpenID Connect Discovery URL`
- **Discovery:** Defines how Clients dynamically discover information about OpenID Providers
```t
# Get OpenID Connect provider URL for EKS Cluster
Go to Services -> EKS -> hr-dev-eksdemo1 -> Configuration -> Details -> OpenID Connect provider URL

# EKS OpenID Connect Well Known Configuration URL
<EKS OpenID Connect provider URL>/.well-known/openid-configuration

# Sample
https://oidc.eks.us-east-1.amazonaws.com/id/EC973221A6C1BC248C79CFD5455EEECC/.well-known/openid-configuration
```
- **Sample Output from EKS OpenID Connect Well Known Configuration URL**
```json
// 20220106104407
// https://oidc.eks.us-east-1.amazonaws.com/id/EC973221A6C1BC248C79CFD5455EEECC/.well-known/openid-configuration

{
  "issuer": "https://oidc.eks.us-east-1.amazonaws.com/id/EC973221A6C1BC248C79CFD5455EEECC",
  "jwks_uri": "https://oidc.eks.us-east-1.amazonaws.com/id/EC973221A6C1BC248C79CFD5455EEECC/keys",
  "authorization_endpoint": "urn:kubernetes:programmatic_authorization",
  "response_types_supported": [
    "id_token"
  ],
  "subject_types_supported": [
    "public"
  ],
  "claims_supported": [
    "sub",
    "iss"
  ],
  "id_token_signing_alg_values_supported": [
    "RS256"
  ]
}
```

```
kubectl drain ip-10-0-2-130.ec2.internal --ignore-daemonsets=false --force  --delete-local-data
kubectl taint nodes ip-10-0-1-210.ec2.internal gpu=true:NoSchedule
kubectl taint nodes ip-10-0-2-130.ec2.internal gpu=true:NoSchedule
```