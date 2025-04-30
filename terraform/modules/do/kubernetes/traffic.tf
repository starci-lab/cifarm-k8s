# Create namespace for the traffic
resource "kubernetes_namespace" "traffic" {
  metadata {
    name = "traffic"
  }
}

locals {
  nginx_ingress_controller_name = "nginx-ingress-controller"
}

# Helm release for the NGINX Ingress Controller
resource "helm_release" "nginx_ingress_controller" {
  name       = local.nginx_ingress_controller_name
  repository = var.bitnami_repository
  chart      = local.nginx_ingress_controller_name
  namespace  = kubernetes_namespace.traffic.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/nginx-ingress-controller-values.yaml", {
      node_pool_label = var.primary_node_pool_name
      request_cpu  = var.pod_resource_config["small"].requests.cpu
      request_memory = var.pod_resource_config["small"].requests.memory
      limit_cpu    = var.pod_resource_config["small"].limits.cpu
      limit_memory = var.pod_resource_config["small"].limits.memory
      default_backend_request_cpu  = var.pod_resource_config["micro"].requests.cpu
      default_backend_request_memory = var.pod_resource_config["micro"].requests.memory
      default_backend_limit_cpu    = var.pod_resource_config["micro"].limits.cpu
      default_backend_limit_memory = var.pod_resource_config["micro"].limits.memory
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

data "kubernetes_service" "nginx_ingress_controller" {
  metadata {
    name = local.nginx_ingress_controller_name
    namespace = kubernetes_namespace.traffic.metadata[0].name
  }
  depends_on = [ helm_release.nginx_ingress_controller ]
}