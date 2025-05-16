# Create namespace for the brokers
resource "kubernetes_namespace" "brokers" {
  metadata {
    name = "brokers"
  }
}

# Helm release for the Gameplay PostgreSQL database
resource "helm_release" "kafka" {
  name            = local.kafka.name
  repository      = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "kafka"
  namespace       = kubernetes_namespace.brokers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/kafka-values.yaml", {
      node_pool_label           = var.primary_node_pool_name,
      controller_request_cpu    = var.pod_resource_config["large"].requests.cpu,
      controller_request_memory = var.pod_resource_config["large"].requests.memory,
      controller_limit_cpu      = var.pod_resource_config["large"].limits.cpu,
      controller_limit_memory   = var.pod_resource_config["large"].limits.memory,
      sasl_user                 = var.kafka_sasl_username,
      sasl_password             = var.kafka_sasl_password,

      persistence_size          = var.kafka_persistence_size,
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
  kafka = {
    name = "kafka"
    host = "kafka.${kubernetes_namespace.brokers.metadata[0].name}.svc.cluster.local"
    port = 9092
  }
}
