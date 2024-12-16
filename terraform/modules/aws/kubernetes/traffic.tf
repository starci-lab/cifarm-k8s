# Create namespace for the traffic
resource "kubernetes_namespace" "traffic" {
    metadata {
        name = "traffic"
    }
}

# Helm release for the NGINX Ingress Controller
resource "helm_release" "nginx_ingress_controller" {
    name       = "nginx-ingress-controller"
    repository = var.bitnami_repository
    chart      = "nginx-ingress-controller"
    namespace  = kubernetes_namespace.traffic.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/nginx-ingress-controller-values.yaml", {
            node_group_label = var.primary_node_group_name
        })
    ]
}