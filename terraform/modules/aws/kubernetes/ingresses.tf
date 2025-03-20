# Create ingresses namespace
resource "kubernetes_namespace" "ingresses" {
  metadata {
    name = "ingresses"
  }
}

# resource "kubernetes_service" "rest_api_gateway_external" {
#   metadata {
#     name      = local.rest_api_gateway.name
#     namespace = kubernetes_namespace.ingresses.metadata[0].name
#   }

#   spec {
#     type          = "ExternalName" # Specifies this is an ExternalName service
#     external_name = local.rest_api_gateway.host
#   }
# }

# resource "kubernetes_ingress_v1" "api" {
#   metadata {
#     name      = "api"
#     namespace = kubernetes_namespace.ingresses.metadata[0].name
#     annotations = {
#       "cert-manager.io/cluster-issuer"                 = var.cluster_issuer_name
#       "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
#       "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
#     }
#   }
#   spec {
#     ingress_class_name = "nginx"
#     rule {
#       host = local.api_domain_name
#       http {
#         path {
#           path = "/"
#           backend {
#             service {
#               name = local.rest_api_gateway.name
#               port {
#                 number = local.rest_api_gateway.port
#               }
#             }
#           }
#         }
#       }
#     }
#     tls {
#       hosts       = [local.api_domain_name]
#       secret_name = "api-tls"
#     }
#   }

#   depends_on = [
#     kubectl_manifest.cluster_issuer_letsencrypt_prod,
#     aws_route53_record.api,
#     helm_release.rest_api_gateway
#   ]
# }

resource "kubernetes_service" "graphql_gateway_external" {
  metadata {
    name      = local.graphql_gateway.name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type          = "ExternalName" # Specifies this is an ExternalName service
    external_name = local.graphql_gateway.host
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
      host = local.graphql_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              name = local.graphql_gateway.name
              port {
                number = local.graphql_gateway.port
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
    aws_route53_record.graphql,
    helm_release.graphql_gateway
  ]
}

resource "kubernetes_service" "io_gameplay_external" {
  metadata {
    name      = local.io_gameplay.name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type          = "ExternalName" # Specifies this is an ExternalName service
    external_name = local.io_gameplay.host
  }
}

resource "kubernetes_ingress_v1" "io" {
  metadata {
    name      = "io"
    namespace = kubernetes_namespace.ingresses.metadata[0].name
    annotations = {
      "cert-manager.io/cluster-issuer"                    = var.cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect"    = "true"
      # "nginx.ingress.kubernetes.io/configuration-snippet" = file("${path.module}/configs/resolve_client_ip.conf")
      # "nginx.ingress.kubernetes.io/upstream-hash-by"      = "$client_ip"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = local.io_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              name = local.io_gameplay.name
              port {
                number = local.io_gameplay.port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [local.io_domain_name]
      secret_name = "io-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    aws_route53_record.io,
    helm_release.io_gameplay
  ]
}

resource "kubernetes_ingress_v1" "io_admin" {
  metadata {
    name      = "io-admin"
    namespace = kubernetes_namespace.ingresses.metadata[0].name
    annotations = {
      "cert-manager.io/cluster-issuer"                    = var.cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = local.io_admin_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              name = local.io_gameplay.name
              port {
                number = local.io_gameplay.admin_ui_port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [local.io_admin_domain_name]
      secret_name = "io-admin-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    aws_route53_record.io_admin,
    helm_release.io_gameplay
  ]
}

resource "kubernetes_service" "jenkins_external" {
  metadata {
    name      = local.jenkins.name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type          = "ExternalName" # Specifies this is an ExternalName service
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
    aws_route53_record.jenkins,
    helm_release.jenkins
  ]
}

resource "kubernetes_service" "client_external" {
  metadata {
    name      = local.client.name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type          = "ExternalName" # Specifies this is an ExternalName service
    external_name = local.client.host
  }
}

# resource "kubernetes_ingress_v1" "client" {
#   metadata {
#     name      = "client"
#     namespace = kubernetes_namespace.ingresses.metadata[0].name
#     annotations = {
#       "cert-manager.io/cluster-issuer"                 = var.cluster_issuer_name
#       "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
#       "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
#     }
#   }
#   spec {
#     ingress_class_name = "nginx"
#     rule {
#       host = local.client_domain_name
#       http {
#         path {
#           path = "/"
#           backend {
#             service {
#               name = local.client.name
#               port {
#                 number = local.client.port
#               }
#             }
#           }
#         }
#       }
#     }
#     tls {
#       hosts       = [local.client_domain_name]
#       secret_name = "client-tls"
#     }
#   }

#   depends_on = [
#     kubectl_manifest.cluster_issuer_letsencrypt_prod,
#     aws_route53_record.client,
#     helm_release.client
#   ]
# }


