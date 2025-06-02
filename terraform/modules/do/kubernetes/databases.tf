# Create namespace for the databases
resource "kubernetes_namespace" "databases" {
  metadata {
    name = "databases"
  }
}

# Helm release for the Adapter MongoDB database
resource "helm_release" "gameplay_mongodb" {
  name            = local.gameplay_mongodb.name
  repository      = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "mongodb-sharded"
  namespace       = kubernetes_namespace.databases.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/mongodb-sharded-values.yaml", {
      node_pool_label = var.primary_node_pool_name,

      # Resource configurations
      configsvr_request_cpu    = var.pod_resource_config["small"].requests.cpu,
      configsvr_request_memory = var.pod_resource_config["small"].requests.memory,
      configsvr_limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      configsvr_limit_memory   = var.pod_resource_config["small"].limits.memory,

      mongos_request_cpu    = var.pod_resource_config["small"].requests.cpu,
      mongos_request_memory = var.pod_resource_config["small"].requests.memory,
      mongos_limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      mongos_limit_memory   = var.pod_resource_config["small"].limits.memory,

      shardsvr_data_node_request_cpu    = var.pod_resource_config["medium"].requests.cpu,
      shardsvr_data_node_request_memory = var.pod_resource_config["medium"].requests.memory,
      shardsvr_data_node_limit_cpu      = var.pod_resource_config["medium"].limits.cpu,
      shardsvr_data_node_limit_memory   = var.pod_resource_config["medium"].limits.memory,

      username = var.gameplay_mongodb_username,
      password = var.gameplay_mongodb_password,
      replica_set_key = var.gameplay_mongodb_auth_replica_set_key,

      configsvr_persistence_size = var.gameplay_mongodb_persistence_size,
      shardsvr_persistence_size = var.gameplay_mongodb_persistence_size,
    })
  ]

  dynamic "set" {
    for_each = local.set_pull_secrets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}

# Helm release for the Cache Redis database
resource "helm_release" "cache_redis" {
  name            = local.cache_redis.name
  repository      = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "redis-cluster"
  namespace       = kubernetes_namespace.databases.metadata[0].name
  values = [
    templatefile("${path.module}/manifests/redis-cluster-values.yaml", {
      node_pool_label = var.primary_node_pool_name,

      # Resource configurations
      request_cpu               = var.pod_resource_config["micro"].requests.cpu,
      request_memory            = var.pod_resource_config["micro"].requests.memory,
      limit_cpu                 = var.pod_resource_config["micro"].limits.cpu,
      limit_memory              = var.pod_resource_config["micro"].limits.memory,
      update_job_request_cpu    = var.pod_resource_config["nano"].requests.cpu,
      update_job_request_memory = var.pod_resource_config["nano"].requests.memory,
      update_job_limit_cpu      = var.pod_resource_config["nano"].limits.cpu,
      update_job_limit_memory   = var.pod_resource_config["nano"].limits.memory,

      password = var.cache_redis_password,

      persistence_size = var.cache_redis_persistence_size,
    })
  ]

  dynamic "set" {
    for_each = local.set_pull_secrets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
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
      node_pool_label = var.primary_node_pool_name,

      # Resource configurations
      request_cpu               = var.pod_resource_config["micro"].requests.cpu,
      request_memory            = var.pod_resource_config["micro"].requests.memory,
      limit_cpu                 = var.pod_resource_config["micro"].limits.cpu,
      limit_memory              = var.pod_resource_config["micro"].limits.memory,
      update_job_request_cpu    = var.pod_resource_config["nano"].requests.cpu,
      update_job_request_memory = var.pod_resource_config["nano"].requests.memory,
      update_job_limit_cpu      = var.pod_resource_config["nano"].limits.cpu,
      update_job_limit_memory   = var.pod_resource_config["nano"].limits.memory,

      password = var.adapter_redis_password,

      persistence_size = var.adapter_redis_persistence_size,
    })
  ]
}

# Helm release for the Job Redis database
resource "helm_release" "job_redis" {
  name            = local.job_redis.name
  repository      = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "redis-cluster"
  namespace       = kubernetes_namespace.databases.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/redis-cluster-values.yaml", {
      node_pool_label = var.primary_node_pool_name,

      # Resource configurations
      request_cpu               = var.pod_resource_config["micro"].requests.cpu,
      request_memory            = var.pod_resource_config["micro"].requests.memory,
      limit_cpu                 = var.pod_resource_config["micro"].limits.cpu,
      limit_memory              = var.pod_resource_config["micro"].limits.memory,
      update_job_request_cpu    = var.pod_resource_config["nano"].requests.cpu,
      update_job_request_memory = var.pod_resource_config["nano"].requests.memory,
      update_job_limit_cpu      = var.pod_resource_config["nano"].limits.cpu,
      update_job_limit_memory   = var.pod_resource_config["nano"].limits.memory,

      password = var.job_redis_password,

      persistence_size = var.job_redis_persistence_size,
    })
  ]

  dynamic "set" {
    for_each = local.set_pull_secrets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}

locals {
  # Cache Redis Configuration
  cache_redis = {
    name = "cache-redis"
    host = "cache-redis-redis-cluster.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
    port = 6379
  }

  # Adapter Redis Configuration
  adapter_redis = {
    name = "adapter-redis"
    host = "adapter-redis-redis-cluster.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
    port = 6379
  }

  # Job Redis Configuration
  job_redis = {
    name = "job-redis"
    host = "job-redis-redis-cluster.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
    port = 6379
  }

  # Adapter MongoDB Configuration
  adapter_mongodb = {
    name     = "adapter-mongodb"
    host     = "adapter-mongodb-mongodb-sharded.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
    port     = 27017
    database = "primary"
  }

  # Gameplay Mongoose Configuration, We use mongoose to indicate that this is a MongoDB database that uses Mongoose
  gameplay_mongodb = {
    name     = "gameplay-mongodb"
    host     = "gameplay-mongodb-mongodb-sharded.${kubernetes_namespace.databases.metadata[0].name}.svc.cluster.local"
    port     = 27017
    database = "primary"
  }
}

