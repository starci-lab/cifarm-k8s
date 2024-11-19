# Ingress Controller using Bitnami Helm Chart
## Introduction
## Deployment Steps
### Add the Bitnami Helm Repository
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```
### Create namespace
```bash
kubectl create namespace ingress-controller
```
### Install via Bitnami Helm Chart
```bash
# Using a remote `values.yaml` file (GitHub)
helm install ingress-controller bitnami/nginx-ingress-controller \
    -f https://starci-lab.github.io/cifarm-k8s/bitnami/ingress-controller/values.yaml \
    --namespace ingress-controller

# Using a local `values.yaml` file
helm install gameplay-postgresql bitnami/postgresql-ha \
    -f ./bitnami/ingress-controller/values.yaml \
    --namespace ingress-controller
```
## Outcome