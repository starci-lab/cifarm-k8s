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
      node_pool_label     = var.primary_node_pool_name
      cainjector_request_cpu  = var.pod_resource_config["nano"].requests.cpu
      cainjector_request_memory = var.pod_resource_config["nano"].requests.memory
      cainjector_limit_cpu    = var.pod_resource_config["nano"].limits.cpu
      cainjector_limit_memory = var.pod_resource_config["nano"].limits.memory

      controller_request_cpu  = var.pod_resource_config["nano"].requests.cpu
      controller_request_memory = var.pod_resource_config["nano"].requests.memory
      controller_limit_cpu    = var.pod_resource_config["nano"].limits.cpu
      controller_limit_memory = var.pod_resource_config["nano"].limits.memory

      webhook_request_cpu  = var.pod_resource_config["nano"].requests.cpu
      webhook_request_memory = var.pod_resource_config["nano"].requests.memory
      webhook_limit_cpu    = var.pod_resource_config["nano"].limits.cpu
      webhook_limit_memory = var.pod_resource_config["nano"].limits.memory
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
          class: nginx
YAML
}
