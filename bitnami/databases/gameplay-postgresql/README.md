# Gameplay PostgreSQL Database using Bitnami Helm Chart
## Introduction
This guide outlines the steps to deploy a Gameplay PostgreSQL Database using the Bitnami PostgreSQL High Availability (HA) Helm Chart in a Kubernetes environment. PostgreSQL is a powerful, open-source relational database system, and with Bitnami's Helm chart, you can easily deploy a highly available, fault-tolerant PostgreSQL setup with replication and automatic failover.

The purpose of this deployment is to provide a robust database solution for storing gameplay data, such as player profiles, game states, scores, and more, in a Kubernetes-based infrastructure. By leveraging Kubernetes and Helm, you can automate the installation, scaling, and management of your PostgreSQL database with minimal manual intervention.

In the following sections, we will walk through the necessary steps to configure and deploy the database, customize key settings, and ensure that the database is accessible from other applications within the same Kubernetes cluster.
## Deployment Steps
### Create namespace
First, you need to create a namespace in your Kubernetes cluster to organize your PostgreSQL deployment. This ensures that the resources related to the database are logically isolated from other applications or services.
```shell
kubectl create namespace gameplay-postgresql
```
### Set environments
Set environment variables that will configure your PostgreSQL deployment. These values will include the database name, password, and port for the PostgreSQL instance.
```shell
export GAMEPLAY_POSTGRES_DBNAME="gameplay"
export GAMEPLAY_POSTGRES_PORT="5432"
export GAMEPLAY_POSTGRES_PASS="Cuong123_A"
```
### Install via Bitnami Helm Chart
After setting the environment variables, use the Helm package manager to install the PostgreSQL database. The Bitnami Helm chart provides a pre-configured deployment for PostgreSQL with options for high availability, replication, and more.

The command below installs the PostgreSQL instance in the gameplay-postgresql namespace, customizing several values according to the environment variables set earlier.
```shell
helm install gameplay-postgresql bitnami/postgresql-ha \
 -f https://starci-lab.github.io/cifarm-k8s/bitnami/databases/gameplay-postgresql/values.yaml \
 --namespace gameplay-postgresql \
 --set global.postgresql.password=$GAMEPLAY_POSTGRES_PASS \
 --set global.postgresql.repmgrPassword=$GAMEPLAY_POSTGRES_PASS \
 --set global.postgresql.database=$GAMEPLAY_POSTGRES_DBNAME \
 --set global.postgresql.repmgrDatabase=$GAMEPLAY_POSTGRES_DBNAME \
 --set postgresql.containerPorts.postgresql=$GAMEPLAY_POSTGRES_PORT
```
## Outcome
### PgPool
The PgPool service has been successfully configured as a ClusterIP service, which means it is accessible within the Kubernetes cluster. The service is exposed through the host gameplay-postgresql-postgresql-ha-pgpool.gameplay-postgresql.svc.cluster.local and listens on the default PostgreSQL port, 5432. This setup allows other pods within the same cluster to connect to PgPool for load balancing, connection pooling, and managing PostgreSQL database connections effectively.
- **Kind**: Service  
- **Type**: ClusterIP  
- **Host**: `gameplay-postgresql-postgresql-ha-pgpool.gameplay-postgresql.svc.cluster.local`  
- **Port**: 5432
