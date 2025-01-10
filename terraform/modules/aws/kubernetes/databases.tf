# Create namespace for the databases
resource "kubernetes_namespace" "databases" {
  metadata {
    name = "databases"
  }
}

# Helm release for the Gameplay PostgreSQL database
resource "helm_release" "gameplay_postgresql" {
  name       = local.gameplay_postgresql.name
  repository = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart      = "postgresql-ha"
  namespace  = kubernetes_namespace.databases.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/postgresql-ha-values.yaml", {
      password         = var.gameplay_postgresql_password,
      database         = var.gameplay_postgresql_database,
      node_group_label = var.primary_node_group_name,

      // Resource configurations
      pgpool_request_cpu     = var.pod_resource_config["small"].requests.cpu,
      pgpool_request_memory  = var.pod_resource_config["small"].requests.memory,
      pgpool_limit_cpu       = var.pod_resource_config["small"].limits.cpu,
      pgpool_limit_memory    = var.pod_resource_config["small"].limits.memory,
      request_cpu            = var.pod_resource_config["small"].requests.cpu,
      request_memory         = var.pod_resource_config["small"].requests.memory,
      limit_cpu              = var.pod_resource_config["small"].limits.cpu,
      limit_memory           = var.pod_resource_config["small"].limits.memory,
      witness_request_cpu    = var.pod_resource_config["small"].requests.cpu,
      witness_request_memory = var.pod_resource_config["nano"].requests.memory,
      witness_limit_cpu      = var.pod_resource_config["nano"].limits.cpu,
      witness_limit_memory   = var.pod_resource_config["nano"].limits.memory
    })
  ]
}

# Helm release for the Cache Redis database
resource "helm_release" "cache_redis" {
  name       = local.cache_redis.name
  repository = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart      = "redis-cluster"
  namespace  = kubernetes_namespace.databases.metadata[0].name
  values = [
    templatefile("${path.module}/manifests/redis-cluster-values.yaml", {
      node_group_label = var.primary_node_group_name,

      # Resource configurations
      request_cpu               = var.pod_resource_config["small"].requests.cpu,
      request_memory            = var.pod_resource_config["small"].requests.memory,
      limit_cpu                 = var.pod_resource_config["small"].limits.cpu,
      limit_memory              = var.pod_resource_config["small"].limits.memory,
      update_job_request_cpu    = var.pod_resource_config["micro"].requests.cpu,
      update_job_request_memory = var.pod_resource_config["micro"].requests.memory,
      update_job_limit_cpu      = var.pod_resource_config["micro"].limits.cpu,
      update_job_limit_memory   = var.pod_resource_config["micro"].limits.memory,

      password = var.cache_redis_password,
    })
  ]
}

# Helm release for the Adapter Redis database
resource "helm_release" "adapter_redis" {
  name       = local.adapter_redis.name
  repository = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart      = "redis-cluster"
  namespace  = kubernetes_namespace.databases.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/redis-cluster-values.yaml", {
      node_group_label = var.primary_node_group_name,

      # Resource configurations
      request_cpu               = var.pod_resource_config["small"].requests.cpu,
      request_memory            = var.pod_resource_config["small"].requests.memory,
      limit_cpu                 = var.pod_resource_config["small"].limits.cpu,
      limit_memory              = var.pod_resource_config["small"].limits.memory,
      update_job_request_cpu    = var.pod_resource_config["micro"].requests.cpu,
      update_job_request_memory = var.pod_resource_config["micro"].requests.memory,
      update_job_limit_cpu      = var.pod_resource_config["micro"].limits.cpu,
      update_job_limit_memory   = var.pod_resource_config["micro"].limits.memory,

      password = var.adapter_redis_password,
    })
  ]
}

# Helm release for the Job Redis database
resource "helm_release" "job_redis" {
  name       = local.job_redis.name
  repository = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart      = "redis-cluster"
  namespace  = kubernetes_namespace.databases.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/redis-cluster-values.yaml", {
      node_group_label = var.primary_node_group_name,
      
      # Resource configurations
      request_cpu               = var.pod_resource_config["small"].requests.cpu,
      request_memory            = var.pod_resource_config["small"].requests.memory,
      limit_cpu                 = var.pod_resource_config["small"].limits.cpu,
      limit_memory              = var.pod_resource_config["small"].limits.memory,
      update_job_request_cpu    = var.pod_resource_config["micro"].requests.cpu,
      update_job_request_memory = var.pod_resource_config["micro"].requests.memory,
      update_job_limit_cpu      = var.pod_resource_config["micro"].limits.cpu,
      update_job_limit_memory   = var.pod_resource_config["micro"].limits.memory,

      password = var.job_redis_password,
    })
  ]
}

locals {
  # Gameplay PostgreSQL Configuration
  gameplay_postgresql = {
    name     = "gameplay-postgresql"
    host     = "gameplay-postgresql-postgresql-ha-pgpool.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
    port     = 5432
    username = "postgres"
  }

  # Cache Redis Configuration
  cache_redis = {
    name = "cache-redis"
    host = "cache-redis-redis-cluster.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
    port = 6379
  }

  # Adapter Redis Configuration
  adapter_redis = {
    name = "adapter-redis"
    host = "adapter-redis-master.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
    port = 6379
  }

  # Job Redis Configuration

  job_redis = {
    name = "job-redis"
    host = "job-redis-master.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
    port = 6379
  }
}

