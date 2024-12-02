# Rest Api Gateway Helm Chart
## Introduction
## Deployment Steps
### Add/Update the Helm Repository (Remote)
```bash
# Check if the 'cifarm' repository is already added
if helm repo list | grep -q "^cifarm" 
then
    # If the 'cifarm' repository is already in the list, print a message and update the repository
    echo "Repository 'cifarm' is already added. Updating..."
    helm repo update cifarm
else
    # If the 'cifarm' repository is not in the list, add it and update the repository
    echo "Repository 'cifarm' is not added. Adding now..."
    helm repo add cifarm https://starci-lab.github.io/cifarm-k8s/charts
    helm repo update cifarm
fi
```
### Create namespace
```bash
kubectl create namespace rest-api-gateway-deployment
```
### Create environments
```bash
export GAMEPLAY_POSTGRES_DBNAME=cifarm
export GAMEPLAY_POSTGRES_HOST=gameplay-postgresql-postgresql-ha-pgpool.gameplay-postgresql.svc.cluster.local
export GAMEPLAY_POSTGRES_PORT=5432
export GAMEPLAY_POSTGRES_USER=postgres
export GAMEPLAY_POSTGRES_PASS=Cuong123_A
```
### Install
```bash
# Using remote helm (GitHub)
helm install rest-api-gateway-deployment cifarm/rest-api-gateway-deployment
    --set namespace rest-api-gateway-deployment
    --set secret.env.gameplayPostgres.dbName=$GAMEPLAY_POSTGRES_DBNAME
    --set secret.env.gameplayPostgres.host=$GAMEPLAY_POSTGRES_HOST
    --set secret.env.gameplayPostgres.port=$GAMEPLAY_POSTGRES_PORT
    --set secret.env.gameplayPostgres.user=$GAMEPLAY_POSTGRES_USER
    --set secret.env.gameplayPostgres.pass=$GAMEPLAY_POSTGRES_PASS
# Using local repository
helm install rest-api-gateway-deployment ./charts/repo/containers/rest-api-gateway/build/
    --set namespace rest-api-gateway-deployment
    --set secret.env.gameplayPostgres.dbName=$GAMEPLAY_POSTGRES_DBNAME
    --set secret.env.gameplayPostgres.host=$GAMEPLAY_POSTGRES_HOST
    --set secret.env.gameplayPostgres.port=$GAMEPLAY_POSTGRES_PORT
    --set secret.env.gameplayPostgres.user=$GAMEPLAY_POSTGRES_USER
    --set secret.env.gameplayPostgres.pass=$GAMEPLAY_POSTGRES_PASS
```
## Outcome
### Rest Api Gateway
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `rest-api-gateway-cluster-ip.rest-api-gateway-deployment.svc.cluster.local`  
- **Port**: 3008
```bash
# Forward port for Gameplay PostgreSQL
kubectl port-forward svc/rest-api-gateway-cluster-ip --namespace rest-api-gateway-deployment 3008:3008
```