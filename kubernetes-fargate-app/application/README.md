## The name space must be a fargate profile created. We will used the `app` fargate profile that was created already
```sh
kubectl apply -f .
```

PS: THIS WILL TAKE A WHILE TO SHEDULE PODS IN FARGATE

## Coredns job
- certificate will be automatically detected and associated to Application Load Balancer.
- We don't need to get the SSL Certificate ARN and update it in Kubernetes Ingress Manifest
- Discovers via Ingress rule host and attaches a cert for  *.devopseasylearning.net to the ALB

## URL
```
dev.devopseasylearning.net/

https://articles.devopseasylearning.net/

https://covid19.devopseasylearning.net/

https://creative.devopseasylearning.net/

https://halloween.devopseasylearning.net/

https://phone.devopseasylearning.net/

https://static.devopseasylearning.net/

https://website.devopseasylearning.net/
```