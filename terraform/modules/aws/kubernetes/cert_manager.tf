# Create namespace for the cert-manager
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

# Create cert-manager
# Helm release for the Cert-Manager
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = var.bitnami_repository
  chart      = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/cert-manager-values.yaml", {
      node_group_label = var.primary_node_group_name
    })
  ]
}

resource "kubectl_manifest" "cluster_issuer_letsencrypt_prod" {
  depends_on = [helm_release.cert_manager]
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
