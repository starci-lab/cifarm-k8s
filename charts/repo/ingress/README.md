# Ingress Helm Chart
## Introduction
## Install Steps
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
kubectl create namespace ingress
```
### Install
```bash
# Using remote helm (GitHub)
helm install ingress cifarm/ingress
    --set namespace ingress
# Using local repository
helm install cifarm/ingress ./charts/repo/ingress
    --set namespace ingress
```
## Outcome