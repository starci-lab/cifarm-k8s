# Rest Api Gateway Helm Chart
## Introduction
## Build Steps
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
kubectl create namespace rest-api-gateway-build
```
### Create environments
```bash
export DOCKER_SERVER="https://index.docker.io/v1/"
export DOCKER_USERNAME="cifarm"
export DOCKER_PASSWORD="*****"
export DOCKER_EMAIL="cifarm.starcilab@gmail.com"
```
### Install
```bash
# Using remote helm (GitHub)
helm install rest-api-gateway-build cifarm/rest-api-gateway-build
    --set namespace rest-api-gateway-build
    --set secret.imageCredentials.registry=$DOCKER_SERVER
    --set secret.imageCredentials.username=$DOCKER_USERNAME
    --set secret.imageCredentials.password=$DOCKER_PASSWORD
    --set secret.imageCredentials.email=$DOCKER_EMAIL
# Using local repository
helm install rest-api-gateway-build ./charts/repo/containers/rest-api-gateway/build/
    --set namespace rest-api-gateway-build
    --set secret.imageCredentials.registry=$DOCKER_SERVER
    --set secret.imageCredentials.username=$DOCKER_USERNAME
    --set secret.imageCredentials.password=$DOCKER_PASSWORD
    --set secret.imageCredentials.email=$DOCKER_EMAIL
```
## Outcome
### Rest Api Gateway
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `rest-api-gateway-cluster-ip.rest-api-gateway-deployment.svc.cluster.local`  
- **Port**: 3008
```bash
# Forward port for Rest Api Gateway
kubectl port-forward svc/rest-api-gateway-cluster-ip --namespace rest-api-gateway-deployment 3008:3008
```