# Create namespace for the brokers
resource "kubernetes_namespace" "brokers" {
  metadata {
    name = "brokers"
  }
}

# Helm release for the Gameplay PostgreSQL database
resource "helm_release" "kafka" {
  name       = local.kafka.name
  repository = var.bitnami_repository
  chart      = "kafka"
  namespace  = kubernetes_namespace.brokers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/kafka-values.yaml", {
      node_group_label          = var.primary_node_group_name,
      controller_request_cpu    = var.pod_resource_config["small"].requests.cpu,
      controller_request_memory = var.pod_resource_config["small"].requests.memory,
      controller_limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      controller_limit_memory   = var.pod_resource_config["small"].limits.memory,
    })
  ]
}

locals {
  kafka = {
    name = "kafka"
    host = "kafka.${kubernetes_namespace.brokers.metadata[0].name}.svc.cluster.local"
    port = 9092
    headless = {
      headless_1 = {
        host = "kafka-controller-0.kafka-controller-headless.${kubernetes_namespace.brokers.metadata[0].name}.svc.cluster.local"
        port = 9092
      }
      headless_2 = {
        host = "kafka-controller-1.kafka-controller-headless.${kubernetes_namespace.brokers.metadata[0].name}.svc.cluster.local"
        port = 9092
      }
      headless_3 = {
        host = "kafka-controller-2.kafka-controller-headless.${kubernetes_namespace.brokers.metadata[0].name}.svc.cluster.local"
        port = 9092
      }
    }
  }
}
