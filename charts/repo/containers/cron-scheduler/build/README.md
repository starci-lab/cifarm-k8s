# Cron Scheduler Helm Chart
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
kubectl create namespace cron-scheduler-build
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
helm install cron-scheduler-build cifarm/cron-scheduler-build
    --set namespace cron-scheduler-build
    --set secret.imageCredentials.registry=$DOCKER_SERVER
    --set secret.imageCredentials.username=$DOCKER_USERNAME
    --set secret.imageCredentials.password=$DOCKER_PASSWORD
    --set secret.imageCredentials.email=$DOCKER_EMAIL
# Using local repository
helm install cron-scheduler-build ./charts/repo/containers/cron-scheduler/build/
    --set namespace cron-scheduler-build
    --set secret.imageCredentials.registry=$DOCKER_SERVER
    --set secret.imageCredentials.username=$DOCKER_USERNAME
    --set secret.imageCredentials.password=$DOCKER_PASSWORD
    --set secret.imageCredentials.email=$DOCKER_EMAIL
```
## Outcome
### Cron Scheduler
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `cron-scheduler-cluster-ip.cron-scheduler-deployment.svc.cluster.local`  
- **Port**: 3008
```bash
# Forward port for Cron Scheduler
kubectl port-forward svc/cron-scheduler-cluster-ip --namespace cron-scheduler-deployment 3008:3008
```