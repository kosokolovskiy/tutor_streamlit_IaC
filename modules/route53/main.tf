# Route53 module - DNS records management for existing infrastructure

terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.us_east_1]
    }
  }
}

# Data source to find existing hosted zone
data "aws_route53_zone" "main" {
  count        = var.zone_id != "" ? 0 : 1
  name         = var.zone_name
  private_zone = false
}

# Local values
locals {
  zone_id     = var.zone_id != "" ? var.zone_id : data.aws_route53_zone.main[0].zone_id
  record_fqdn = "${var.subdomain_label}.${var.zone_name}"
}

# A record pointing to CloudFront distribution
resource "aws_route53_record" "main" {
  count   = var.use_cloudfront ? 1 : 0
  zone_id = local.zone_id
  name    = local.record_fqdn
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# AAAA record for IPv6 support
resource "aws_route53_record" "ipv6" {
  count   = var.use_cloudfront && var.enable_ipv6 ? 1 : 0
  zone_id = local.zone_id
  name    = local.record_fqdn
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# MX records for the zone apex (optional)
resource "aws_route53_record" "mx" {
  count   = length(var.mx_records) > 0 ? 1 : 0
  zone_id = local.zone_id
  name    = var.zone_name
  type    = "MX"
  ttl     = 300
  records = var.mx_records
}

# TXT records for the zone apex (optional)
resource "aws_route53_record" "txt" {
  count   = length(var.txt_records) > 0 ? 1 : 0
  zone_id = local.zone_id
  name    = var.zone_name
  type    = "TXT"
  ttl     = 300
  records = var.txt_records
}
