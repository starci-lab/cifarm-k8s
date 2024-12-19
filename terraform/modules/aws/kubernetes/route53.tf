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

# Create A records for the domain api
resource "aws_route53_record" "api" {
    zone_id = aws_route53_zone.zone.zone_id
    name    = "api.${local.domain_name}"
    type    = "A"
    alias {
        name                   = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].hostname
        zone_id                = data.aws_lb_hosted_zone_id.nlb.id
        evaluate_target_health = true
    }
    depends_on = [ cloudflare_record.ns ]
}