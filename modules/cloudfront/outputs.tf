#############################
# CloudFront module outputs #
#############################

output "id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.main.id
}

output "arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.main.arn
}

output "domain_name" {
  description = "CloudFront domain (dXXXXXXXXXXXX.cloudfront.net)"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "hosted_zone_id" {
  description = "Hosted zone ID for CloudFront aliases (constant)"
  value       = "Z2FDTNDATAQYW2"
}

output "aliases" {
  description = "Configured CNAME aliases"
  value       = aws_cloudfront_distribution.main.aliases
}

output "origin_id" {
  description = "Origin identifier set in the distribution"
  value       = var.origin_id
}

output "origin_domain_name" {
  description = "Origin DNS name (EC2/ALB)"
  value       = var.origin_domain_name
}

output "cache_policy_id" {
  description = "Cache policy used by default cache behavior"
  value       = var.cache_policy_id
}

output "origin_request_policy_id" {
  description = "Origin request policy used by default cache behavior"
  value       = var.origin_request_policy_id
}

output "price_class" {
  description = "Distribution price class"
  value       = var.price_class
}

output "tags_all" {
  description = "All tags applied to the distribution"
  value       = aws_cloudfront_distribution.main.tags_all
}

output "ssl_certificate_arn" {
  description = "ACM certificate ARN used (must be us-east-1 when domain_name is set)"
  value       = var.ssl_certificate_arn
}

output "route53_alias_target" {
  description = "Convenience object for Route53 alias (A/AAAA) to this CloudFront"
  value = {
    name                   = aws_cloudfront_distribution.main.domain_name
    hosted_zone_id         = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
