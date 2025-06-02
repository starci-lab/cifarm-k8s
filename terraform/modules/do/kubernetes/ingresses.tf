# Create ingresses namespace
resource "kubernetes_namespace" "ingresses" {
  metadata {
    name = "ingresses"
  }
}

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
      "acme.cert-manager.io/http01-edit-in-place"     = "true"
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
    cloudflare_record.graphql,
    helm_release.graphql_gateway
  ]
}

resource "kubernetes_service" "ws_external" {
  metadata {
    name      = local.ws.name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type          = "ExternalName" # Specifies this is an ExternalName service
    external_name = local.ws.host
  }
}

resource "kubernetes_ingress_v1" "ws" {
  metadata {
    name      = "ws"
    namespace = kubernetes_namespace.ingresses.metadata[0].name
    annotations = {
      "cert-manager.io/cluster-issuer"                    = var.cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect"    = "true"
      "acme.cert-manager.io/http01-edit-in-place"         = "true"
      # "nginx.ingress.kubernetes.io/configuration-snippet" = file("${path.module}/configs/resolve_client_ip.conf")
      # "nginx.ingress.kubernetes.io/upstream-hash-by"      = "$client_ip"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = local.ws_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              name = local.ws.name
              port {
                number = local.ws.port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [local.ws_domain_name]
      secret_name = "ws-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.ws,
    helm_release.ws
  ]
}

resource "kubernetes_ingress_v1" "ws_admin" {
  metadata {
    name      = "ws-admin"
    namespace = kubernetes_namespace.ingresses.metadata[0].name
    annotations = {
      "cert-manager.io/cluster-issuer"                    = var.cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect"    = "true"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = local.ws_admin_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              name = local.ws.name
              port {
                number = local.ws.admin_ui_port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [local.ws_admin_domain_name]
      secret_name = "ws-admin-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.ws_admin,
    helm_release.ws
  ]
}

resource "kubernetes_service" "auth_external" {
  metadata {
    name      = local.social_auth.name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type          = "ExternalName" # Specifies this is an ExternalName service
    external_name = local.social_auth.host
  }
}

resource "kubernetes_ingress_v1" "auth" {
  metadata {
    name      = "auth"
    namespace = kubernetes_namespace.ingresses.metadata[0].name
    annotations = {
      "cert-manager.io/cluster-issuer"                 = var.cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "acme.cert-manager.io/http01-edit-in-place"     = "true"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = local.auth_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              name = local.social_auth.name
              port {
                number = local.social_auth.port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [local.auth_domain_name]
      secret_name = "auth-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.auth,
    helm_release.social_auth
  ]
}

resource "kubernetes_service" "kibana_external" {
  metadata {
    name      = local.kibana.name
    namespace = kubernetes_namespace.ingresses.metadata[0].name
  }

  spec {
    type          = "ExternalName" # Specifies this is an ExternalName service
    external_name = local.kibana.host
  }
}

resource "kubernetes_ingress_v1" "kibana" {
  metadata {
    name      = "kibana"
    namespace = kubernetes_namespace.ingresses.metadata[0].name
    annotations = {
      "cert-manager.io/cluster-issuer"                 = var.cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "acme.cert-manager.io/http01-edit-in-place"     = "true"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = local.kibana_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              name = local.kibana.name
              port {
                number = local.kibana.port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [local.kibana_domain_name]
      secret_name = "kibana-tls"
    }
  }
}

