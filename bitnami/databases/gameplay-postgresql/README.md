# Gameplay PostgreSQL Database using Bitnami Helm Chart
## Introduction
This guide outlines the steps to deploy a Gameplay PostgreSQL Database using the Bitnami PostgreSQL High Availability (HA) Helm Chart in a Kubernetes environment. PostgreSQL is a powerful, open-source relational database system, and with Bitnami's Helm chart, you can easily deploy a highly available, fault-tolerant PostgreSQL setup with replication and automatic failover.

The purpose of this deployment is to provide a robust database solution for storing gameplay data, such as player profiles, game states, scores, and more, in a Kubernetes-based infrastructure. By leveraging Kubernetes and Helm, you can automate the installation, scaling, and management of your PostgreSQL database with minimal manual intervention.

In the following sections, we will walk through the necessary steps to configure and deploy the database, customize key settings, and ensure that the database is accessible from other applications within the same Kubernetes cluster.
## Deployment Steps
### Add the Bitnami Helm Repository
helm repo add bitnami https://charts.bitnami.com/bitnami
```
### Create namespace
```bash
kubectl create namespace gameplay-postgresql
```
### Set environments
```bash
export GAMEPLAY_POSTGRES_DBNAME="gameplay"
export GAMEPLAY_POSTGRES_PORT="5432"
export GAMEPLAY_POSTGRES_PASS="Cuong123_A"
```
### Install via Bitnami Helm Chart
```bash
# Using a remote `values.yaml` file (GitHub)
helm install gameplay-postgresql bitnami/postgresql-ha \
    -f https://starci-lab.github.io/cifarm-k8s/bitnami/databases/gameplay-postgresql/values.yaml \
    --namespace gameplay-postgresql \
    --set global.postgresql.password=$GAMEPLAY_POSTGRES_PASS \
    --set global.postgresql.repmgrPassword=$GAMEPLAY_POSTGRES_PASS \
    --set global.postgresql.database=$GAMEPLAY_POSTGRES_DBNAME \
    --set global.postgresql.repmgrDatabase=$GAMEPLAY_POSTGRES_DBNAME \
    --set postgresql.containerPorts.postgresql=$GAMEPLAY_POSTGRES_PORT

# Using a local `values.yaml` file
helm install gameplay-postgresql bitnami/postgresql-ha \
    -f ./bitnami/databases/gameplay-postgresql/values.yaml \
    --namespace gameplay-postgresql \
    --set global.postgresql.password=$GAMEPLAY_POSTGRES_PASS \
    --set global.postgresql.repmgrPassword=$GAMEPLAY_POSTGRES_PASS \
    --set global.postgresql.database=$GAMEPLAY_POSTGRES_DBNAME \
    --set global.postgresql.repmgrDatabase=$GAMEPLAY_POSTGRES_DBNAME \
    --set postgresql.containerPorts.postgresql=$GAMEPLAY_POSTGRES_PORT
```
## Outcome
### PgPool
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `gameplay-postgresql-postgresql-ha-pgpool.gameplay-postgresql.svc.cluster.local`  
- **Port**: 5432
```bash
# Forward port for Gameplay PostgreSQL
kubectl port-forward svc/gameplay-postgresql-postgresql-ha-pgpool --namespace monitoring 5432:5432
# Connect to PostgreSQL Database
PGPASSWORD=Cuong123_A psql -h 127.0.0.1 -p 5432 -d gameplay
```