# Create ingresses namespace
resource "kubernetes_namespace" "ingresses" {
  metadata {
    name = "ingresses"
  }
}

resource "kubernetes_service" "rest_api_gateway_external" {
  metadata {
    name      = local.rest_api_gateway_name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type = "ExternalName"  # Specifies this is an ExternalName service
    external_name = local.rest_api_gateway_host
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
      host = local.api_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              name = local.rest_api_gateway_name
              port {
                number = local.rest_api_gateway_port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [local.api_domain_name]
      secret_name = "api-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    aws_route53_record.api
  ]
}


resource "kubernetes_service" "jenkins_external" {
  metadata {
    name      = local.jenkins_name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type = "ExternalName"  # Specifies this is an ExternalName service
    external_name = local.jenkins_host
  }
}


resource "kubernetes_ingress_v1" "jenkins" {
  metadata {
    name      = "jenkins"
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
      host = local.jenkins_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              name = local.jenkins_name
              port {
                number = local.jenkins_port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [local.jenkins_domain_name]
      secret_name = "jenkins-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    aws_route53_record.jenkins
  ]
}
