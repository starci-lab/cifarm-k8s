# Create ingresses namespace
resource "kubernetes_namespace" "ingresses" {
  metadata {
    name = "ingresses"
  }
}

resource "kubernetes_service" "rest_api_gateway_external" {
  metadata {
    name      = local.rest_api_gateway.name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type = "ExternalName"  # Specifies this is an ExternalName service
    external_name = local.rest_api_gateway.host
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
              name = local.rest_api_gateway.name
              port {
                number = local.rest_api_gateway.port
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

resource "kubernetes_service" "graphql_maingraph_external" {
  metadata {
    name      = local.graphql_maingraph.name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type = "ExternalName"  # Specifies this is an ExternalName service
    external_name = local.graphql_maingraph.host
  }
}

resource "kubernetes_ingress_v1" "graphql" {
  metadata {
    name      = "graphql"
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
              name = local.graphql_maingraph.name
              port {
                number = local.graphql_maingraph.port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [local.graphql_domain_name]
      secret_name = "graphql-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    aws_route53_record.api
  ]
}

resource "kubernetes_service" "jenkins_external" {
  metadata {
    name      = local.jenkins.name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type = "ExternalName"  # Specifies this is an ExternalName service
    external_name = local.jenkins.host
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
              name = local.jenkins.name
              port {
                number = local.jenkins.port
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
