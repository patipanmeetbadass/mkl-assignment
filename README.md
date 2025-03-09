# Provisioning infrastructure with terraform
- 2 GKE cluster, apigw cluster and service cluster
- apigw cluster allow private and public access
- service cluster allow private access only
- apigw cluster contains 1 namespace, apigw-poc.
- service cluster contains 2 namespaces, service-poc and database-poc.
- Provisioning 1 GCE VM instance with Prometheus, Grafana, Jenkins, ELK-stack as a system service

# Project bootstrap
- Check variables value in terraform.tfvars
- terrafrom init
- terraform plan
- terrafrom apply -> May takes a few minute

# Deprovisions
- terrafrom destroy