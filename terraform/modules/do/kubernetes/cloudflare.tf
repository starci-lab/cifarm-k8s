provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Get the zone id
data "cloudflare_zone" "zone" {
  name = var.base_domain_name
}

# Get the domain name
locals {
  domain_name = "${var.subdomain_prefix}.${var.base_domain_name}"
}

locals {
  ws_domain_name = "ws.${local.domain_name}"
  ws_admin_domain_name = "ws-admin.${local.domain_name}"
  graphql_domain_name = "graphql.${local.domain_name}"
  auth_domain_name = "auth.${local.domain_name}"
  kibana_domain_name = "kibana.${local.domain_name}"
  grafana_domain_name= "grafana.${local.domain_name}"
}

# Create the NS records in Cloudflare for each name server
resource "cloudflare_record" "ws" {
  name     = local.ws_domain_name
  type     = "A"
  content  = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id  = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "ws_admin" {
  name     = local.ws_admin_domain_name
  type     = "A"
  content  = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id  = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "graphql" {
  name     = local.graphql_domain_name
  type     = "A"
  content  = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id  = data.cloudflare_zone.zone.id
} 

resource "cloudflare_record" "auth" {
  name     = local.auth_domain_name
  type     = "A"
  content  = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id  = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "kibana" {
  name     = local.kibana_domain_name
  type     = "A"
  content  = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id  = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "grafana" {
  name     = local.grafana_domain_name
  type     = "A"
  content  = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id  = data.cloudflare_zone.zone.id
  proxied = false
}
