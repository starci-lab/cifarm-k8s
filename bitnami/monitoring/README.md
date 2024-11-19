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
Before you can install any Bitnami charts, you need to add the Bitnami Helm repository to your Helm configuration. This repository contains a wide range of pre-packaged Helm charts for popular applications, including Prometheus, PostgreSQL, and many others.
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```
### Create namespace
The first step in deploying Kube Prometheus and Grafana is to create a dedicated namespace in your Kubernetes cluster. Namespaces in Kubernetes help organize and isolate resources within the cluster, making it easier to manage and scale different applications.

By creating a specific namespace for monitoring, you ensure that all the monitoring tools (Prometheus, Grafana, Alertmanager, etc.) are grouped together and separated from other workloads in the cluster.

```bash
kubectl create namespace monitoring
```
### Install Protmetheus via Bitnami Helm Chart
After creating the monitoring namespace, the next step is to deploy Prometheus using the Bitnami Helm Chart. The Bitnami Prometheus chart provides a pre-configured deployment that can easily be customized for your needs, including setting up monitoring for your Kubernetes cluster, services, and other components.

After setting the environment variables, use the Helm package manager to install the PostgreSQL database. The Bitnami Helm chart provides a pre-configured deployment for PostgreSQL with options for high availability, replication, and more.

The command below installs the PostgreSQL instance in the gameplay-postgresql namespace, customizing several values according to the environment variables set earlier.
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
Before deploying Grafana, it's important to configure any environment variables that may be needed for the deployment. In this case, you'll set the Grafana admin credentials (username and password) as environment variables.
```bash
# Set the new Grafana admin credentials
export GRAFANA_ADMIN_USER='admin'
export GRAFANA_ADMIN_PASSWORD='secret_password'
```
### Install Grafana via Bitnami Helm Chart
Once the environment variables are set, you can install Grafana using the Bitnami Grafana Helm Chart. There are two primary ways to install Grafana
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
The Prometheus Server is a critical component in the monitoring stack, providing metrics collection and querying capabilities for the Kubernetes cluster. It is exposed via a ClusterIP service, making it accessible only within the cluster. Prometheus scrapes and stores metrics from various services and nodes, and allows users to query this data using PromQL (Prometheus Query Language).
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local`  
- **Port**: 9090

The following commands enable you to access the Prometheus Server interfaces locally through port forwarding.
```bash
# Forward port for Prometheus
kubectl port-forward svc/prometheus-kube-prometheus-prometheus --namespace monitoring 9090:9090
curl 127.0.0.1:9090

# Visit the Prometheus Dashboard
http://127.0.0.1:9090
```

### Prometheus Alertmanager Server
The Prometheus Alertmanager handles alerts generated by the Prometheus server based on pre-defined alerting rules. It is responsible for grouping, silencing, and routing alerts to the appropriate notification channels such as email, Slack, or PagerDuty. Like Prometheus, Alertmanager is exposed via a ClusterIP service for internal access only within the Kubernetes cluster.
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `prometheus-kube-prometheus-alertmanager.monitoring.svc.cluster.local`  
- **Port**: 9093

The following commands enable you to access the Prometheus Alertmanager Server interfaces locally through port forwarding.
```bash
# Forward port for Alertmanager
kubectl port-forward svc/prometheus-kube-prometheus-alertmanager --namespace monitoring 9093:9093
curl 127.0.0.1:9093

# Visit the Alertmanager Dashboard
http://127.0.0.1:9093
```
### Grafana
Grafana is a powerful open-source platform used for data visualization and monitoring. In this context, it is integrated with Prometheus to create dashboards and visual representations of the metrics collected by Prometheus. Grafana allows users to easily explore and analyze their metrics through customizable, interactive dashboards.
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `grafana.monitoring.svc.cluster.local`  
- **Port**: 3000

The following commands enable you to access the Grafana web interface locally through port forwarding.
```bash
# Forward port for Grafana
kubectl port-forward svc/grafana --namespace monitoring 3000:3000
curl 127.0.0.1:3000

# Visit the Grafana Dashboard
http://127.0.0.1:3000
```