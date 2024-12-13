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
        templatefile("manifests/prometheus-values.yaml", {
            node_group_label = split(":", module.provider.node_group_secondary_id)[1]
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
        templatefile("manifests/grafana-values.yaml", {
            user = var.grafana_user,
            password = var.grafana_password,
            prometheus_url = var.grafana_prometheus_url,
            prometheus_alertmanager_url = var.grafana_prometheus_alertmanager_url,
            node_group_label = split(":", module.provider.node_group_secondary_id)[1]
        })
    ]
}

