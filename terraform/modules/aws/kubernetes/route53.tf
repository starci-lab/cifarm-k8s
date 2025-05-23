locals {
  domain_name = "${var.subdomain_prefix}.${var.base_domain_name}"
}

# A Route 53 zone is a container for DNS records of a domain.
resource "aws_route53_zone" "zone" {
  name = local.domain_name
}

data "aws_lb_hosted_zone_id" "nlb" {
  region = var.region
  load_balancer_type = "network"
}

data "aws_route53_zone" "zone" {
  name = local.domain_name
  depends_on = [ aws_route53_zone.zone ]
}

locals {
  # api_domain_name = "api.${local.domain_name}"
  jenkins_domain_name = "jenkins.${local.domain_name}"
  graphql_domain_name = "graphql.${local.domain_name}"
  ws_domain_name = "ws.${local.domain_name}"
  ws_admin_domain_name = "ws-admin.${local.domain_name}"
  # client_domain_name = "client.${local.domain_name}"
}

# Create A records for the domain api
# resource "aws_route53_record" "api" {
#     zone_id = aws_route53_zone.zone.zone_id
#     name    = local.api_domain_name
#     type    = "A"
#     alias {
#         name                   = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].hostname
#         zone_id                = data.aws_lb_hosted_zone_id.nlb.id
#         evaluate_target_health = true
#     }
#     depends_on = [ cloudflare_record.ns ]
# }

# Create A records for the domain jenkins
resource "aws_route53_record" "jenkins" {
    zone_id = aws_route53_zone.zone.zone_id
    name    = local.jenkins_domain_name
    type    = "A"
    alias {
        name                   = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].hostname
        zone_id                = data.aws_lb_hosted_zone_id.nlb.id
        evaluate_target_health = true
    }
    depends_on = [ cloudflare_record.ns ]
}

# Create A records for the domain graphql
resource "aws_route53_record" "graphql" {
    zone_id = aws_route53_zone.zone.zone_id
    name    = local.graphql_domain_name
    type    = "A"
    alias {
        name                   = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].hostname
        zone_id                = data.aws_lb_hosted_zone_id.nlb.id
        evaluate_target_health = true
    }
    depends_on = [ cloudflare_record.ns ]
}

# Create A records for the domain ws
resource "aws_route53_record" "ws" {
    zone_id = aws_route53_zone.zone.zone_id
    name    = local.ws_domain_name
    type    = "A"
    alias {
        name                   = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].hostname
        zone_id                = data.aws_lb_hosted_zone_id.nlb.id
        evaluate_target_health = true
    }
    depends_on = [ cloudflare_record.ns ]
}

# Create A records for the domain ws-admin
resource "aws_route53_record" "ws_admin" {
    zone_id = aws_route53_zone.zone.zone_id
    name    = local.ws_admin_domain_name
    type    = "A"
    alias {
        name                   = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].hostname
        zone_id                = data.aws_lb_hosted_zone_id.nlb.id
        evaluate_target_health = true
    }
    depends_on = [ cloudflare_record.ns ]
}