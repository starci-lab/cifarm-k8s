# Create ingresses namespace
resource "kubernetes_namespace" "ingresses" {
  metadata {
    name = "ingresses"
  }
}

resource "kubernetes_service" "rest_api_gateway_service_external" {
  metadata {
    name      = "rest-api-gateway"
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type = "ExternalName"  # Specifies this is an ExternalName service
    external_name = "${var.rest_api_gateway_name}.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"  # Internal service name in your cluster
  }
}

resource "kubernetes_ingress_v1" "api" {
  metadata {
    name      = "api"
    namespace = kubernetes_namespace.ingresses.metadata[0].name
    annotations = {
      "cert-manager.io/cluster-issuer"                 = var.cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "api.${local.domain_name}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = var.rest_api_gateway_name
              port {
                number = var.rest_api_gateway_port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = ["api.${local.domain_name}"]
      secret_name = "api-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod
  ]
}
