# Create namespace for the traffic
resource "kubernetes_namespace" "traffic" {
    metadata {
        name = "traffic"
    }
}

# # Helm release for the NGINX Ingress Controller
# resource "helm_release" "nginx_ingress_controller" {
#     name       = "nginx-ingress-controller"
#     repository = var.bitnami_repository
#     chart      = "nginx-ingress-controller"
#     namespace  = kubernetes_namespace.traffic.metadata[0].name

#     values = [
#         templatefile("manifests/nginx-ingress-controller-values.yaml", {
#             node_group_label = split(":", module.provider.node_group_primary_id)[1]
#         })
#     ]
# }