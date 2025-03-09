# service-deployment
Deployment maifest/template for NodeJS service.
Using custom Helm chart named as **simple-nodejs**, create with
```javascript I'm A tab
helm create simple-nodejs
```
- **template** contains Helm generated template, ready for apply.
- **value** contains Helm value file and default value file:
    - **default.yaml** contains Kong's common parameters for all environment (dev, staging, production)
    - **service-poc-value.yaml** contains Kong's parameters for environment poc (as a demonstration)

# Importance Note!
- This demonstration using Helm chart that stored on a local as a sub-chart
- However, with **helm repo add** should give the same result

# Generate Helm template
An example of Helm generate template for deployment name 'service-poc' in namespace 'service-poc'
```javascript I'm A tab
helm template . '--name-template=service-poc' '-n=service-poc' '--values=./value/default.yaml' '--values=./value/service-poc-value.yaml' --dry-run > template/service-poc.yaml
```