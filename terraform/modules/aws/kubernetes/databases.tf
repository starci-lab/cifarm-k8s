# Create namespace for the databases
resource "kubernetes_namespace" "databases" {
  metadata {
    name = "databases"
  }
}


locals {
  gameplay_postgresql_name = "gameplay-postgresql"
  cache_redis_name         = "cache-redis"
  adapter_redis_name       = "adapter-redis"
  job_redis_name           = "job-redis"
}


# Helm release for the Gameplay PostgreSQL database
resource "helm_release" "gameplay_postgresql" {
  name       = local.gameplay_postgresql_name
  repository = var.bitnami_repository
  chart      = "postgresql-ha"
  namespace  = kubernetes_namespace.databases.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/postgresql-ha-values.yaml", {
      password         = var.gameplay_postgres_password,
      database         = var.gameplay_postgres_database,
      node_group_label = var.primary_node_group_name
    })
  ]
}

# Helm release for the Cache Redis database
resource "helm_release" "cache_redis" {
  name       = local.cache_redis_name
  repository = var.bitnami_repository
  chart      = "redis"
  namespace  = kubernetes_namespace.databases.metadata[0].name
  values = [
    templatefile("${path.module}/manifests/redis-values.yaml", {
      node_group_label = var.primary_node_group_name
    })
  ]
}

# Helm release for the Adapter Redis database
resource "helm_release" "adapter_redis" {
  name       = local.adapter_redis_name
  repository = var.bitnami_repository
  chart      = "redis"
  namespace  = kubernetes_namespace.databases.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/redis-values.yaml", {
      node_group_label = var.primary_node_group_name
    })
  ]
}

# Helm release for the Job Redis database
resource "helm_release" "job_redis" {
  name       = local.job_redis_name
  repository = var.bitnami_repository
  chart      = "redis"
  namespace  = kubernetes_namespace.databases.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/redis-values.yaml", {
      node_group_label = var.primary_node_group_name
    })
  ]
}

locals {
  gameplay_postgresql_host = "gameplay-postgresql-postgresql-ha-pgpool.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
  cache_redis_host         = "cache-redis-master.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
  adapter_redis_host       = "adapter-redis-master.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
  job_redis_host           = "job-redis-master.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
}
