# Create namespace for the databases
resource "kubernetes_namespace" "containers" {
  metadata {
    name = "containers"
  }
}

locals {
  // Gameplay Service
  gameplay_service = {
    name              = "gameplay-service"
    port              = 8080
    health_check_port = 8081
    host              = "gameplay-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  // Rest API Gateway
  rest_api_gateway = {
    name = "rest-api-gateway"
    port = 8080
    health_check_port = 8081
    host = "rest-api-gateway-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  // Gameplay Subgraph
  gameplay_subgraph = {
    name = "gameplay-subgraph"
    port = 8080
    health_check_port = 8081
    host = "gameplay-subgraph-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  // GraphQL Maingraph
  graphql_maingraph = {
    name = "graphql-maingraph"
    port = 8080
    health_check_port = 8081
    host = "graphql-maingraph-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  // Websocket Node
  websocket_node = {
    name = "websocket-node"
    port = 8080
    health_check_port = 8081
    host = "websocket-node-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  cron_scheduler = {
    name = "cron-scheduler"
    health_check_port = 8081
    host = "cron-scheduler-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  cron_worker = {
    name = "cron-worker"
    health_check_port = 8081
    host = "cron-worker-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }
}

resource "helm_release" "gameplay_service" {
  name       = local.gameplay_service.name
  repository = var.container_repository
  chart      = "service"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/gameplay-service-values.yaml", {
      node_group_label = var.primary_node_group_name,

      // Jwt
      jwt_secret                   = var.jwt_secret,
      jwt_access_token_expiration  = var.jwt_access_token_expiration,
      jwt_refresh_token_expiration = var.jwt_refresh_token_expiration,

      // Gameplay Postgres Configuration
      gameplay_postgresql_host     = local.gameplay_postgresql.host,
      gameplay_postgresql_database = var.gameplay_postgresql_database,
      gameplay_postgresql_password = var.gameplay_postgresql_password,
      gameplay_postgresql_username = local.gameplay_postgresql.username,
      gameplay_postgresql_port     = local.gameplay_postgresql.port,

      // Kafka Configuration
      kafka_headless_1_host = local.kafka.headless.headless_1.host,
      kafka_headless_1_port = local.kafka.headless.headless_1.port,
      kafka_headless_2_host = local.kafka.headless.headless_2.host,
      kafka_headless_2_port = local.kafka.headless.headless_2.port,
      kafka_headless_3_host = local.kafka.headless.headless_3.host,
      kafka_headless_3_port = local.kafka.headless.headless_3.port,

      // Gameplay Service Configuration
      port              = local.gameplay_service.port,
      health_check_port = local.gameplay_service.health_check_port,

      // Cache Redis Configuration
      cache_redis_host = local.cache_redis.host,
      cache_redis_port = local.cache_redis.port,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,
    })
  ]

  depends_on = [
    helm_release.keda,
    helm_release.cache_redis,
    helm_release.kafka,
    helm_release.gameplay_postgresql,
  ]
}

resource "helm_release" "rest_api_gateway" {
  name       = local.rest_api_gateway.name
  repository = var.container_repository
  chart      = "service"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/rest-api-gateway-values.yaml", {
      // Gameplay Service Configuration
      node_group_label      = var.primary_node_group_name,
      gameplay_service_host = local.gameplay_service.host,
      gameplay_service_port = local.gameplay_service.port,
      gameplay_service_health_check_port = local.gameplay_service.health_check_port,

      // Jwt
      jwt_secret = var.jwt_secret,

      // Rest API Gateway Configuration Port
      port = local.rest_api_gateway.port,
      health_check_port = local.rest_api_gateway.health_check_port,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,
    })
  ]

  depends_on = [
    helm_release.keda,
    helm_release.gameplay_service,
  ]
}

resource "helm_release" "gameplay_subgraph" {
  name       = local.gameplay_subgraph.name
  repository = var.container_repository
  chart      = "service"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/gameplay-subgraph-values.yaml", {
      node_group_label = var.primary_node_group_name,

      // Gameplay Postgres Configuration
      gameplay_postgresql_host     = local.gameplay_postgresql.host,
      gameplay_postgresql_database = var.gameplay_postgresql_database,
      gameplay_postgresql_password = var.gameplay_postgresql_password,
      gameplay_postgresql_username = local.gameplay_postgresql.username,
      gameplay_postgresql_port     = local.gameplay_postgresql.port,

      // Gameplay Service Configuration
      port = local.gameplay_subgraph.port,
      health_check_port = local.gameplay_subgraph.health_check_port,

      // Cache Redis Configuration
      cache_redis_host = local.cache_redis.host,
      cache_redis_port = local.cache_redis.port,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,
    })
  ]

  depends_on = [
    helm_release.keda,
    helm_release.cache_redis,
    helm_release.gameplay_postgresql,
  ]
}

resource "helm_release" "graphql_maingraph" {
  name       = local.graphql_maingraph.name
  repository = var.container_repository
  chart      = "service"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/graphql-maingraph-values.yaml", {
      node_group_label = var.primary_node_group_name,

      // Gameplay Service Configuration
      gameplay_subgraph_host = local.gameplay_subgraph.host,
      gameplay_subgraph_port = local.gameplay_subgraph.port,
      gameplay_subgraph_health_check_port = local.gameplay_subgraph.health_check_port,

      // Jwt
      jwt_secret = var.jwt_secret,
      port       = local.graphql_maingraph.port,
      health_check_port = local.graphql_maingraph.health_check_port,

      // Cache Redis Configuration
      cache_redis_host = local.cache_redis.host,
      cache_redis_port = local.cache_redis.port,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,
    })
  ]

  depends_on = [
    helm_release.keda,
    helm_release.gameplay_subgraph,
  ]
}

resource "helm_release" "websocket_node" {
  name       = local.websocket_node.name
  repository = var.container_repository
  chart      = "service"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/websocket-node-values.yaml", {
      node_group_label = var.primary_node_group_name,

      // Gameplay Postgres Configuration
      gameplay_postgresql_host     = local.gameplay_postgresql.host,
      gameplay_postgresql_database = var.gameplay_postgresql_database,
      gameplay_postgresql_password = var.gameplay_postgresql_password,
      gameplay_postgresql_username = local.gameplay_postgresql.username,
      gameplay_postgresql_port     = local.gameplay_postgresql.port,

      // Gameplay Service Configuration
      port = local.websocket_node.port,
      health_check_port = local.websocket_node.health_check_port,
      production_url = "https://${local.ws_domain_name}"

      admin_username = var.socket_io_admin_username,
      admin_password = var.socket_io_admin_password,

      // Cache Redis Configuration
      cache_redis_host = local.cache_redis.host,
      cache_redis_port = local.cache_redis.port,

      // Adapter Redis Configuration
      adapter_redis_host = local.adapter_redis.host,
      adapter_redis_port = local.adapter_redis.port,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,

      // Kafka Configuration
      kafka_1_host = local.kafka.host,
      kafka_1_port = local.kafka.port,
    })
  ]

  depends_on = [
    helm_release.keda,
    helm_release.cache_redis,
    helm_release.gameplay_postgresql,
    helm_release.kafka,
  ]
}

resource "helm_release" "cron_scheduler" {
  name       = local.cron_scheduler.name
  repository = var.container_repository
  chart      = "service"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/cron-scheduler-values.yaml", {
      node_group_label = var.primary_node_group_name,

      // Gameplay Postgres Configuration
      gameplay_postgresql_host     = local.gameplay_postgresql.host,
      gameplay_postgresql_database = var.gameplay_postgresql_database,
      gameplay_postgresql_password = var.gameplay_postgresql_password,
      gameplay_postgresql_username = local.gameplay_postgresql.username,
      gameplay_postgresql_port     = local.gameplay_postgresql.port,

      // Cache Redis Configuration
      cache_redis_host = local.cache_redis.host,
      cache_redis_port = local.cache_redis.port,

      // Job Redis Configuration
      job_redis_host = local.job_redis.host,
      job_redis_port = local.job_redis.port,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,

      health_check_port = local.cron_scheduler.health_check_port,
    })
  ]

  depends_on = [
    helm_release.keda,
    helm_release.cache_redis,
    helm_release.gameplay_postgresql,
    helm_release.job_redis,
  ]
}

resource "helm_release" "cron_worker" {
  name       = local.cron_worker.name
  repository = var.container_repository
  chart      = "service"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/cron-worker-values.yaml", {
      node_group_label = var.primary_node_group_name,

      // Gameplay Postgres Configuration
      gameplay_postgresql_host     = local.gameplay_postgresql.host,
      gameplay_postgresql_database = var.gameplay_postgresql_database,
      gameplay_postgresql_password = var.gameplay_postgresql_password,
      gameplay_postgresql_username = local.gameplay_postgresql.username,
      gameplay_postgresql_port     = local.gameplay_postgresql.port,

      // Cache Redis Configuration
      cache_redis_host = local.cache_redis.host,
      cache_redis_port = local.cache_redis.port,

      // Job Redis Configuration
      job_redis_host = local.job_redis.host,
      job_redis_port = local.job_redis.port,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,

      health_check_port = local.cron_scheduler.health_check_port,
    })
  ]

  depends_on = [
    helm_release.keda,
    helm_release.cache_redis,
    helm_release.gameplay_postgresql,
    helm_release.job_redis,
  ]
}