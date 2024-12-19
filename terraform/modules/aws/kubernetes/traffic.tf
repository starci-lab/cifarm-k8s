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

# Helm release for the Cert-Manager
resource "helm_release" "cert_manager" {
    name       = "cert-manager"
    repository = var.bitnami_repository
    chart      = "cert-manager"
    namespace  = kubernetes_namespace.traffic.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/cert-manager-values.yaml", {
            node_group_label = var.primary_node_group_name
        })
    ]
}

resource "kubectl_manifest" "cluster_issuer_letsencrypt_prod" {
  depends_on = [ helm_release.cert_manager ]
  
  yaml_body = <<YAML
apiVersion: "cert-manager.io/v1"
kind: ClusterIssuer
metadata:
  name: ${var.cluster_issuer_name}
spec:
  acme:
    server: "https://acme-v02.api.letsencrypt.org/directory"
    email: ${var.email}
    privateKeySecretRef:
      name: ${var.cluster_issuer_name}
    solvers:
      - http01:
          ingress:
            ingressClassName: "nginx"
YAML
}