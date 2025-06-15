resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
  }
}


locals {
  # Grafana Configuration
  grafana = {
    name = "grafana"
    host = "grafana.${kubernetes_namespace.grafana.metadata[0].name}.svc.cluster.local"
    port = 3000
  }
}


resource "helm_release" "grafana" {
  name       = "grafana"
  repository = var.bitnami_repository
  chart      = "grafana"
  namespace        = kubernetes_namespace.grafana.metadata[0].name
  create_namespace = false

  values = [
    templatefile("${path.module}/manifests/grafana-values.yaml", {
        user = var.grafana_user
        password = var.grafana_password
        node_group_label = var.primary_node_pool_name
        request_cpu =  var.pod_resource_config["nano"].requests.cpu
        request_memory =  var.pod_resource_config["nano"].requests.memory
        limit_cpu = var.pod_resource_config["nano"].limits.cpu
        limit_memory = var.pod_resource_config["nano"].limits.memory
        prometheus_url = "http://prometheus-kube-prometheus-prometheus.prometheus.svc.cluster.local:9090"
        prometheus_alertmanager_url = "http://prometheus-kube-prometheus-alertmanager.prometheus.svc.cluster.local:9090"

    })
  ]

  depends_on = [ kubernetes_namespace.grafana ]

  timeout = 6000
}

