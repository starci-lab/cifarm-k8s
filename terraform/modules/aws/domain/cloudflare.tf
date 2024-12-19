# Get the zone id
data "cloudflare_zone" "zone" {
  name = var.base_domain_name
}

# Create a record
resource "cloudflare_record" "ns" { 
  count = "${length(data.aws_route53_zone.zone.name_servers)}"
  name    = var.subdomain_prefix
  type    = "NS"
  content = "${element(data.aws_route53_zone.zone.name_servers, count.index)}"
  zone_id = data.cloudflare_zone.zone.id
}