# Keda using Kedacore Helm Chart
## Introduction
## Deployment Steps
### Add the Kedacore Helm Repository
```bash
helm repo add kedacore https://kedacore.github.io/charts
```
### Create namespace
```bash
kubectl create namespace keda
```
### Install Keda via Kedacore Helm Chart
```bash
# Using a remote `values.yaml` file (GitHub)
helm install keda kedacore/keda \
    --namespace keda \
    -f https://starci-lab.github.io/cifarm-k8s/keda/values.yaml

# Using a local `values.yaml` file
helm install keda kedacore/keda \
    --namespace keda \
    -f ./keda/values.yaml
```
## Outcome