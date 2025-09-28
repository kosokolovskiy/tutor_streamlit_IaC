terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}



data "aws_acm_certificate" "this" {
  provider    = aws.us_east_1
  domain      = var.domain_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}


resource "aws_cloudfront_distribution" "main" {
  enabled              = true
  is_ipv6_enabled      = true
  http_version         = "http2"
  wait_for_deployment  = true
  price_class          = var.price_class
  aliases              = var.domain_name != "" ? [var.domain_name] : []

  origin {
    domain_name = var.origin_domain_name
    origin_id  = var.origin_id

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = var.origin_protocol_policy   # "http-only" или "https-only"
      origin_read_timeout      = 30
      origin_keepalive_timeout = 5
      origin_ssl_protocols     = var.origin_ssl_protocols     # ["TLSv1.2"] и т.п.
    }
  }

  default_cache_behavior {
    target_origin_id       = var.origin_id
    viewer_protocol_policy = var.viewer_protocol_policy       # "redirect-to-https"

    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods

    cache_policy_id          = var.cache_policy_id         
    origin_request_policy_id = var.origin_request_policy_id

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    compress = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.domain_name == ""
    acm_certificate_arn            = var.domain_name != "" ? data.aws_acm_certificate.this.arn : null
    ssl_support_method             = var.domain_name != "" ? "sni-only" : null
    minimum_protocol_version       = var.domain_name != "" ? "TLSv1.2_2021" : null
  }

  tags = var.tags
}
