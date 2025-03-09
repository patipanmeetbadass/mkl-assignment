# apigw-deployment
Deployment maifest/template for Kong API gateway in DB-less mode.
Generate deployment template with Helm, using Helm chart from **konghq**.
- **template** contains Helm generated template, ready for apply.
- **value** contains Helm value file and default value file:
    - **default.yaml** contains Kong's common parameters for all environment (dev, staging, production)
    - **apigw-poc-value.yaml** contains Kong's parameters for environment poc (as a demonstration)

# Importance Note!
- This demonstration using Helm chart that stored on a local as a sub-chart
- However, with **helm repo add** should give the same result
```javascript I'm A tab
helm repo add kong https://charts.konghq.com
helm repo update
```

# Generate Helm template
An example of Helm generate template for deployment name 'apigw-poc' in namespace 'apigw-poc'
```javascript I'm A tab
helm template . '--name-template=apigw-poc' '-n=apigw-poc' '--values=./value/default.yaml' '--values=./value/apigw-poc-value.yaml' --dry-run > /template/apigw-poc.yaml
```