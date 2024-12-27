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
    host = "gameplay-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  // Rest API Gateway
  rest_api_gateway = {
    name = "rest-api-gateway"
    port = 8080
    host = "rest-api-gateway-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  // Gameplay Subgraph
  gameplay_subgraph = {
    name = "gameplay-subgraph"
    port = 8080
    host = "gameplay-subgraph-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  // GraphQL Maingraph
  graphql_maingraph = {
    name = "graphql-maingraph"
    port = 8080
    host = "graphql-maingraph-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
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
      kafka_headless_1_host = local.kafka.controller.headless.host_1,
      kafka_headless_1_port = local.kafka.controller.headless.port_1,
      kafka_headless_2_host = local.kafka.controller.headless.host_2,
      kafka_headless_2_port = local.kafka.controller.headless.port_2,
      kafka_headless_3_host = local.kafka.controller.headless.host_3,
      kafka_headless_3_port = local.kafka.controller.headless.port_3,

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

      // Jwt
      jwt_secret                   = var.jwt_secret,

      // Rest API Gateway Configuration Port
      port = local.rest_api_gateway.port,

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
      port              = local.gameplay_subgraph.port,

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

      // Jwt
      jwt_secret                   = var.jwt_secret,
      port              = local.graphql_maingraph.port,

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