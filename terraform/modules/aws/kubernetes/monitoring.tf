# Namespace for monitoring resources
resource "kubernetes_namespace" "monitoring" {
    metadata {
        name = "monitoring"
    }
}

# Helm release for the Gameplay PostgreSQL database
resource "helm_release" "prometheus" {
    name       = "prometheus"
    repository = var.bitnami_repository
    chart      = "kube-prometheus"
    namespace  = kubernetes_namespace.monitoring.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/prometheus-values.yaml", {
            node_group_label = var.secondary_node_group_name
        })
    ]
}   

# Helm release for the Grafana 
resource "helm_release" "grafana" {
    name       = "grafana"
    repository = var.bitnami_repository
    chart      = "grafana"
    namespace  = kubernetes_namespace.monitoring.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/grafana-values.yaml", {
            user = var.grafana_user,
            password = var.grafana_password,
            prometheus_url = var.grafana_prometheus_url,
            prometheus_alertmanager_url = var.grafana_prometheus_alertmanager_url,
            node_group_label = var.secondary_node_group_name
        })
    ]
}

# Helm release for the Keda
resource "helm_release" "keda" {
    name       = "keda"
    repository = var.keda_repository
    chart      = "keda"
    namespace  = kubernetes_namespace.monitoring.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/keda-values.yaml", {
            node_group_label = var.secondary_node_group_name
        })
    ]
}

