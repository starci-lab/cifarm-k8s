provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Get the zone id
data "cloudflare_zone" "zone" {
  name = var.base_domain_name
}

locals {
  # expect 4 name servers
  ns_records = [
    { name = var.subdomain_prefix, content = data.aws_route53_zone.zone.name_servers[0] },
    { name = var.subdomain_prefix, content = data.aws_route53_zone.zone.name_servers[1] },
    { name = var.subdomain_prefix, content = data.aws_route53_zone.zone.name_servers[2] },
    { name = var.subdomain_prefix, content = data.aws_route53_zone.zone.name_servers[3] }
  ]
}

# Create the NS records in Cloudflare for each name server
resource "cloudflare_record" "ns" {
  count    = length(local.ns_records)  # Using count based on the length of the ns_records list (which is 4)
  name     = local.ns_records[count.index].name  # Accessing the name via count.index
  type     = "NS"
  content  = local.ns_records[count.index].content  # Accessing the content via count.index
  zone_id  = data.cloudflare_zone.zone.id
}