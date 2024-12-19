provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Get the zone id
data "cloudflare_zone" "zone" {
  name = var.base_domain_name
}

locals {
  ns_records = [for ns in data.aws_route53_zone.zone.name_servers : {
    name    = var.subdomain_prefix
    content = ns
  }]
}

# Create the NS records in Cloudflare for each name server
resource "cloudflare_record" "ns" {
  for_each = { for idx, ns in local.ns_records : "${var.subdomain_prefix}-${idx}" => ns }

  name    = each.value.name
  type    = "NS"
  content = each.value.content
  zone_id = data.cloudflare_zone.zone.id
}