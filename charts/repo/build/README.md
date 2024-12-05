# Gameplay Service Helm Chart
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
kubectl create namespace gameplay-service-build
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
helm install gameplay-service-build cifarm/gameplay-service-build
    --set namespace gameplay-service-build
    --set secret.imageCredentials.registry=$DOCKER_SERVER
    --set secret.imageCredentials.username=$DOCKER_USERNAME
    --set secret.imageCredentials.password=$DOCKER_PASSWORD
    --set secret.imageCredentials.email=$DOCKER_EMAIL
# Using local repository
helm install gameplay-service-build ./charts/repo/containers/gameplay-service/build/
    --set namespace gameplay-service-build
    --set secret.imageCredentials.registry=$DOCKER_SERVER
    --set secret.imageCredentials.username=$DOCKER_USERNAME
    --set secret.imageCredentials.password=$DOCKER_PASSWORD
    --set secret.imageCredentials.email=$DOCKER_EMAIL
```
## Outcome
### Gameplay Service
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `gameplay-service-cluster-ip.gameplay-service-deployment.svc.cluster.local`  
- **Port**: 3008
```bash
# Forward port for Gameplay Service
kubectl port-forward svc/gameplay-service-cluster-ip --namespace gameplay-service-deployment 3008:3008
```