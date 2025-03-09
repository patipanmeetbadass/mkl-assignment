# MongoDB
In this demonstration, MongoDB is selected as a database service.
MongoDB implement as Replica Set Deployment Architectures. Using Helm to create a deployment template and Helm chart from **bitnami**.
- **./value/database-poc-value.yaml** MongoDB's Helm value file for this implementation.

Add bitnami Helm chart repository then update to gets the latest information about charts
```javascript I'm A tab
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Generate deployment template for MongoDB instance in namespace 'database-poc' with a specific value file.
```javascript I'm A tab
helm template bitnami/mongodb '--name-template=database-poc' '-n=database-poc' '--values=./value/database-poc-value.yaml' --dry-run > template/database-poc.yaml
```