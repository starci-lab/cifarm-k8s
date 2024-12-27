# Create namespace for the databases
resource "kubernetes_namespace" "containers" {
  metadata {
    name = "containers"
  }
}

locals {
  # gameplay service
  gameplay_service_name = "gameplay-service"
  gameplay_service_port = 8080

  # rest api gateway
  rest_api_gateway_name = "rest-api-gateway"
  rest_api_gateway_port = 8080

  graphql_maingraph_name = "graphql-maingraph"
  graphql_maingraph_port = 8080

  gameplay_subgraph_name = "gameplay-subgraph"
  gameplay_subgraph_port = 8080
}

resource "helm_release" "gameplay_service" {
  name       = local.gameplay_service_name
  repository = var.container_repository
  chart      = "deployment"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/gameplay-service-values.yaml", {
      node_group_label           = var.primary_node_group_name,
      jwt_secret                 = var.jwt_secret,
      gameplay_postgresql_host   = local.gameplay_postgresql_host,
      gameplay_postgres_database = var.gameplay_postgres_database,
      gameplay_postgres_password = var.gameplay_postgres_password,
      kafka_headless_1           = local.kafka_controller_headless_host_1,
      kafka_headless_2           = local.kafka_controller_headless_host_2,
      kafka_headless_3           = local.kafka_controller_headless_host_3,
      port                       = local.gameplay_service_port,
      cache_redis_host           = local.cache_redis_host,
      request_cpu                = var.pod_resource_config["small"].requests.cpu,
      request_memory             = var.pod_resource_config["small"].requests.memory,
      limit_cpu                  = var.pod_resource_config["small"].limits.cpu,
      limit_memory               = var.pod_resource_config["small"].limits.memory,
    })
  ]

  depends_on = [
    helm_release.keda
  ]
}

resource "helm_release" "rest_api_gateway" {
  name       = local.rest_api_gateway_name
  repository = var.container_repository
  chart      = "service"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/rest-api-gateway-values.yaml", {
      node_group_label      = var.primary_node_group_name,
      gameplay_service_host = local.gameplay_service_host,
      gameplay_service_port = local.gameplay_service_port,
      port                  = local.rest_api_gateway_port,
      namespace             = kubernetes_namespace.containers.metadata[0].name,
      request_cpu                = var.pod_resource_config["small"].requests.cpu,
      request_memory             = var.pod_resource_config["small"].requests.memory,
      limit_cpu                  = var.pod_resource_config["small"].limits.cpu,
      limit_memory               = var.pod_resource_config["small"].limits.memory,
    })
  ]

  depends_on = [
    helm_release.keda
  ]
}

resource "helm_release" "gameplay_subgraph" {
  name       = local.gameplay_subgraph_name
  repository = var.container_repository
  chart      = "service"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/gameplay-subgraph-values.yaml", {
      node_group_label           = var.primary_node_group_name,
      port                       = local.gameplay_subgraph_port,
      gameplay_postgresql_host   = local.gameplay_postgresql_host,
      gameplay_postgres_database = var.gameplay_postgres_database,
      gameplay_postgres_password = var.gameplay_postgres_password,
      cache_redis_host           = local.cache_redis_host,
      namespace                  = kubernetes_namespace.containers.metadata[0].name,
      request_cpu                = var.pod_resource_config["small"].requests.cpu,
      request_memory             = var.pod_resource_config["small"].requests.memory,
      limit_cpu                  = var.pod_resource_config["small"].limits.cpu,
      limit_memory               = var.pod_resource_config["small"].limits.memory,
    })
  ]

  depends_on = [
    helm_release.keda
  ]
}

resource "helm_release" "graphql_maingraph" {
  name       = local.graphql_maingraph_name
  repository = var.container_repository
  chart      = "deployment"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/rest-api-gateway-values.yaml", {
      node_group_label      = var.primary_node_group_name,
      gameplay_service_host = local.gameplay_service_host,
      gameplay_service_port = local.gameplay_service_port,
      port                  = local.rest_api_gateway_port,
      namespace             = kubernetes_namespace.containers.metadata[0].name,
      request_cpu                = var.pod_resource_config["small"].requests.cpu,
      request_memory             = var.pod_resource_config["small"].requests.memory,
      limit_cpu                  = var.pod_resource_config["small"].limits.cpu,
      limit_memory               = var.pod_resource_config["small"].limits.memory,
    })
  ]

  depends_on = [
    helm_release.keda
  ]
}

locals {
  gameplay_service_host = "${local.gameplay_service_name}.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  rest_api_gateway_host = "${local.rest_api_gateway_name}.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
}

