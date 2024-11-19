# Kube Prometheus & Grafana using Bitnami Helm Chart
## Introduction
This guide explains how to deploy Kube Prometheus and Grafana using the Bitnami Helm Chart in a Kubernetes environment. Prometheus is a popular open-source monitoring and alerting toolkit, designed to provide insights into the performance and health of applications and infrastructure. Grafana is a powerful open-source analytics and visualization platform that integrates seamlessly with Prometheus to provide rich, customizable dashboards for monitoring data.

Kube Prometheus is a set of Kubernetes manifests that enables the deployment of Prometheus, along with pre-configured monitoring for Kubernetes clusters, including metrics collection, alerting, and visualization. By deploying Prometheus and Grafana together, you get a complete solution for monitoring, visualizing, and alerting on your Kubernetes workloads and services.

With the Bitnami Helm chart, you can easily deploy and manage these tools in a Kubernetes cluster with minimal configuration. This deployment will enable you to:

Collect and store metrics from your Kubernetes cluster.
Set up custom dashboards in Grafana to visualize the collected data.
Configure alerts based on Prometheus queries to notify you about important events or anomalies.
In the following sections, we will walk through the steps to deploy Prometheus and Grafana, customize your configuration, and access the monitoring dashboards.
## Deployment Steps
### Add the Bitnami Helm Repository
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```
### Create namespace
```bash
kubectl create namespace monitoring
```
### Install Prometheus via Bitnami Helm Chart
```bash
# Using a remote `values.yaml` file (GitHub)
helm install prometheus bitnami/kube-prometheus \
    --namespace monitoring \
    -f https://starci-lab.github.io/cifarm-k8s/bitnami/monitoring/prometheus/values.yaml

# Using a local `values.yaml` file
helm install prometheus bitnami/kube-prometheus \
    --namespace monitoring \
    -f ./bitnami/monitoring/prometheus/values.yaml
```
### Set Grafana environments
```bash
# Set the new Grafana admin credentials
export GRAFANA_ADMIN_USER='admin'
export GRAFANA_ADMIN_PASSWORD='secret_password'
```
### Install Grafana via Bitnami Helm Chart
```bash
# Using a remote `values.yaml` file (GitHub)
helm install grafana bitnami/grafana \
    --namespace monitoring \
    -f https://starci-lab.github.io/cifarm-k8s/bitnami/monitoring/grafana/values.yaml

# Using a local `values.yaml` file
helm install grafana bitnami/grafana \
    --namespace monitoring \
    -f ./bitnami/monitoring/grafana/values.yaml
```
## Outcome
### Prometheus Server
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local`  
- **Port**: 9090
```bash
# Forward port for Prometheus
kubectl port-forward svc/prometheus-kube-prometheus-prometheus --namespace monitoring 9090:9090
curl 127.0.0.1:9090

# Visit the Prometheus Dashboard
http://127.0.0.1:9090
```

### Prometheus Alertmanager Server
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `prometheus-kube-prometheus-alertmanager.monitoring.svc.cluster.local`  
- **Port**: 9093
```bash
# Forward port for Alertmanager
kubectl port-forward svc/prometheus-kube-prometheus-alertmanager --namespace monitoring 9093:9093
curl 127.0.0.1:9093

# Visit the Alertmanager Dashboard
http://127.0.0.1:9093
```
### Grafana
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `grafana.monitoring.svc.cluster.local`  
- **Port**: 3000
```bash
# Forward port for Grafana
kubectl port-forward svc/grafana --namespace monitoring 3000:3000
curl 127.0.0.1:3000

# Visit the Grafana Dashboard
http://127.0.0.1:3000
```