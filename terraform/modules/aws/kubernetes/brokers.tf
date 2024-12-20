# Create namespace for the brokers
resource "kubernetes_namespace" "brokers" {
    metadata {
        name = "brokers"
    }
}

locals {
    kafka_name = "kafka"
}

# Helm release for the Gameplay PostgreSQL database
resource "helm_release" "kafka" {
    name       = local.kafka_name
    repository = var.bitnami_repository
    chart      = "kafka"
    namespace  = kubernetes_namespace.brokers.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/kafka-values.yaml", {
            node_group_label = var.primary_node_group_name
        })
    ]
}   

locals {
  kafka_host = "kafka.${kubernetes_namespace.brokers.metadata[0].name}.svc.cluster.local"
  kafka_controller_headless_host_1 = "kafka-controller-0.kafka-controller-headless.${kubernetes_namespace.brokers.metadata[0].name}.svc.cluster.local"
  kafka_controller_headless_host_2 = "kafka-controller-1.kafka-controller-headless.${kubernetes_namespace.brokers.metadata[0].name}.svc.cluster.local"
  kafka_controller_headless_host_3 = "kafka-controller-2.kafka-controller-headless.${kubernetes_namespace.brokers.metadata[0].name}.svc.cluster.local"
}
