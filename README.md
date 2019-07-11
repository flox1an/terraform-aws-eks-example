# Deploy VPC and EKS with terraform 
```bash
terraform apply
```
# Deploy nginx ingress
```bash
kubectl --kubeconfig kubeconfig_my-cluster apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
```
# Expose ingress with ELB loadbalancer
```bash
kubectl --kubeconfig kubeconfig_my-cluster  expose -n ingress-nginx deployment nginx-ingress-controller --type=LoadBalancer

```


