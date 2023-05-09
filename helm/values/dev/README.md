## Set up IAM permissions and deploy ExternalDNS
https://aws.amazon.com/premiumsupport/knowledge-center/eks-set-up-externaldns/

## Amazon container image registries
https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
```
AWS Region	Registry
sa-east-1	    602401143452.dkr.ecr.sa-east-1.amazonaws.com
us-east-1	    602401143452.dkr.ecr.us-east-1.amazonaws.com
us-east-2	    602401143452.dkr.ecr.us-east-2.amazonaws.com
us-gov-east-1	151742754352.dkr.ecr.us-gov-east-1.amazonaws.com
us-gov-west-1	013241004608.dkr.ecr.us-gov-west-1.amazonaws.com
us-west-1	    602401143452.dkr.ecr.us-west-1.amazonaws.com
us-west-2	    602401143452.dkr.ecr.us-west-2.amazonaws.com
```


## cluster-autoscaler
```
kubectl create ns cluster-autoscaler
helm upgrade cluster-autoscaler --install ../../charts/cluster-autoscaler --values cluster-autoscaler.yaml --namespace cluster-autoscaler
```

## external-dns
```
kubectl create ns external-dns
helm upgrade external-dns --install ../../../charts/external-dns --values external-dns.yaml --namespace external-dns
```

## metrics-server
```
helm upgrade metrics-server --install ../../charts/metrics-server --values metrics-server.yaml --namespace kube-system

helm uninstall metrics-server 
```

## covid19
```
kubectl create ns covid19
helm upgrade covid19 --install ../../charts/applications --values covid19.yaml --namespace covid19

kubectl label namespace covid19 istio-injection=enabled
```

## articles
```
kubectl create ns articles
helm upgrade articles --install ../../charts/applications --values articles.yaml --namespace articles

kubectl label namespace articles istio-injection=enabled
```

## articles
```
kubectl create ns microservices
helm upgrade microservices --install ../../charts/applications --values microservices.yaml --namespace microservices
```
