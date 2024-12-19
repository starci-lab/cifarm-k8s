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
      node_group_label = var.primary_node_group_name
    })
  ]
}

data "kubernetes_service" "nginx_ingress_controller" {
  metadata {
    name = local.nginx_ingress_controller_name
    namespace = kubernetes_namespace.traffic.metadata[0].name
  }
  depends_on = [ helm_release.nginx_ingress_controller ]
}