# Create namespace for the databases
resource "kubernetes_namespace" "databases" {
  metadata {
    name = "databases"
  }
}

# reservedConnections: ${pgpool_reserved_connections}  # Reserved connections for PGPool
# maxPool: ${pgpool_max_pool}  # Maximum number of connections to PGPool
# childMaxConnections: ${pgpool_child_max_connections}  # Maximum number of connections per child process
# numInitChildren: ${pgpool_num_init_children}  # Number of initial child processes
# Helm release for the Gameplay PostgreSQL database
# resource "helm_release" "gameplay_postgresql" {
#   name            = local.gameplay_postgresql.name
#   repository      = var.bitnami_repository
#   cleanup_on_fail = var.cleanup_on_fail
#   chart           = "postgresql-ha"
#   namespace       = kubernetes_namespace.databases.metadata[0].name

#   values = [
#     templatefile("${path.module}/manifests/postgresql-ha-values.yaml", {
#       password         = var.gameplay_postgresql_password,
#       database         = var.gameplay_postgresql_database,
#       node_group_label = var.primary_node_group_name,

#       // Resource configurations
#       pgpool_request_cpu     = var.pod_resource_config["medium"].requests.cpu,
#       pgpool_request_memory  = var.pod_resource_config["medium"].requests.memory,
#       pgpool_limit_cpu       = var.pod_resource_config["medium"].limits.cpu,
#       pgpool_limit_memory    = var.pod_resource_config["medium"].limits.memory,
#       request_cpu            = var.pod_resource_config["medium"].requests.cpu,
#       request_memory         = var.pod_resource_config["medium"].requests.memory,
#       limit_cpu              = var.pod_resource_config["medium"].limits.cpu,
#       limit_memory           = var.pod_resource_config["medium"].limits.memory,
#       witness_request_cpu    = var.pod_resource_config["nano"].requests.cpu,
#       witness_request_memory = var.pod_resource_config["nano"].requests.memory,
#       witness_limit_cpu      = var.pod_resource_config["nano"].limits.cpu,
#       witness_limit_memory   = var.pod_resource_config["nano"].limits.memory

#       // PGPool connections configurations
#       pgpool_reserved_connections = var.pgpool_reserved_connections,
#       pgpool_max_pool = var.pgpool_max_pool,
#       pgpool_child_max_connections = var.pgpool_child_max_connections,
#       pgpool_num_init_children = var.pgpool_num_init_children,

#       // PostgreSQL connections configurations
#       postgresql_max_connections = var.postgresql_max_connections,
#     })
#   ]

#   dynamic "set" {
#     for_each = local.set_pull_secrets
#     content {
#       name  = set.value.name
#       value = set.value.value
#     }
#   }
# }

# Helm release for the Adapter MongoDB database
resource "helm_release" "gameplay_mongodb" {
  name            = local.gameplay_mongodb.name
  repository      = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "mongodb-sharded"
  namespace       = kubernetes_namespace.databases.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/mongodb-sharded-values.yaml", {
      node_group_label = var.primary_node_group_name,

      # Resource configurations
      configsvr_request_cpu    = var.pod_resource_config["medium"].requests.cpu,
      configsvr_request_memory = var.pod_resource_config["medium"].requests.memory,
      configsvr_limit_cpu      = var.pod_resource_config["medium"].limits.cpu,
      configsvr_limit_memory   = var.pod_resource_config["medium"].limits.memory,

      mongos_request_cpu    = var.pod_resource_config["medium"].requests.cpu,
      mongos_request_memory = var.pod_resource_config["medium"].requests.memory,
      mongos_limit_cpu      = var.pod_resource_config["medium"].limits.cpu,
      mongos_limit_memory   = var.pod_resource_config["medium"].limits.memory,

      shardsvr_data_node_request_cpu    = var.pod_resource_config["medium"].requests.cpu,
      shardsvr_data_node_request_memory = var.pod_resource_config["medium"].requests.memory,
      shardsvr_data_node_limit_cpu      = var.pod_resource_config["medium"].limits.cpu,
      shardsvr_data_node_limit_memory   = var.pod_resource_config["medium"].limits.memory,

      username = var.gameplay_mongodb_username,
      password = var.gameplay_mongodb_password,
      replica_set_key = var.gameplay_mongodb_auth_replica_set_key,
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

# Helm release for the Adapter MongoDB database
# resource "helm_release" "adapter_mongodb" {
#   name            = local.adapter_mongodb.name
#   repository      = var.bitnami_repository
#   cleanup_on_fail = var.cleanup_on_fail
#   chart           = "mongodb-sharded"
#   namespace       = kubernetes_namespace.databases.metadata[0].name

#   values = [
#     templatefile("${path.module}/manifests/mongodb-sharded-values.yaml", {
#       node_group_label = var.primary_node_group_name,

#       # Resource configurations
#       configsvr_request_cpu    = var.pod_resource_config["small"].requests.cpu,
#       configsvr_request_memory = var.pod_resource_config["small"].requests.memory,
#       configsvr_limit_cpu      = var.pod_resource_config["small"].limits.cpu,
#       configsvr_limit_memory   = var.pod_resource_config["small"].limits.memory,

#       mongos_request_cpu    = var.pod_resource_config["small"].requests.cpu,
#       mongos_request_memory = var.pod_resource_config["small"].requests.memory,
#       mongos_limit_cpu      = var.pod_resource_config["small"].limits.cpu,
#       mongos_limit_memory   = var.pod_resource_config["small"].limits.memory,

#       shardsvr_data_node_request_cpu    = var.pod_resource_config["small"].requests.cpu,
#       shardsvr_data_node_request_memory = var.pod_resource_config["small"].requests.memory,
#       shardsvr_data_node_limit_cpu      = var.pod_resource_config["small"].limits.cpu,
#       shardsvr_data_node_limit_memory   = var.pod_resource_config["small"].limits.memory,

#       username = var.adapter_mongodb_username,
#       password = var.adapter_mongodb_password,
#     })
#   ]

#   dynamic "set" {
#     for_each = local.set_pull_secrets
#     content {
#       name  = set.value.name
#       value = set.value.value
#     }
#   }
# }

# Helm release for the Job Redis database
resource "helm_release" "job_redis" {
  name            = local.job_redis.name
  repository      = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "redis-cluster"
  namespace       = kubernetes_namespace.databases.metadata[0].name

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

