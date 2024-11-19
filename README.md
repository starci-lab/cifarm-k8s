# **CiFarm Kubernetes Configuration**

This repository contains a Helm chart that deploys CiFarm along with Bitnami and Kuda Helm chart dependencies, such as databases, caching systems, and message brokers.

This README explains how to deploy your CiFarm application alongside dependencies (e.g., MySQL from Bitnami, Redis from Kuda) using Helm on a Kubernetes cluster.

---

## **Charts**
### **Bitnami**
#### **Databases**
- [Gameplay PostgreSQL](./bitnami/databases/gameplay-postgresql/README.md)

#### **Monitoring**
##### [Grafana](./bitnami/monitoring/README.md)
##### [Promethethus](./bitnami/monitoring/README.md)
##### [IngressController](./bitnami/ingress-controller/README.md)

---
### Keda
- [Keda](./keda/README.md)

---

#### **CiFarm Helm Chart**
##### Wallet Service

###### Build
- [Build Instructions](./charts/repo/containers/wallet-service/build/README.md)

###### Deployment
- [Deployment Instructions](./charts/repo/containers/wallet-service/deployment/README.md)


---
##### **Ingress**
- Main configuration and routing rules can be found in [Ingress README](./charts/repo/ingress/README.md).