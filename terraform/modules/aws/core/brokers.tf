# Create namespace for the brokers
resource "kubernetes_namespace" "brokers" {
    metadata {
        name = "brokers"
    }
}

# Helm release for the Gameplay PostgreSQL database
resource "helm_release" "kafka" {
    name       = "kafka"
    repository = var.bitnami_repository
    chart      = "kafka"
    namespace  = kubernetes_namespace.brokers.metadata[0].name

    values = [
        templatefile("manifests/kafka-values.yaml", {
            node_group_label = split(":", module.provider.node_group_primary_id)[1]
        })
    ]
}   