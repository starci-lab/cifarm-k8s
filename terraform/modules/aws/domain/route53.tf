# A Route 53 zone is a container for DNS records of a domain.
resource "aws_route53_zone" "zone" {
  name = local.domain_name
  
}

data "aws_route53_zone" "zone" {
  name = local.domain_name
  depends_on = [ aws_route53_zone.zone ]
}