# Route53 module outputs

output "zone_id" {
  description = "ID of the Route53 hosted zone used"
  value       = local.zone_id
}

output "record_fqdn" {
  description = "FQDN of the created record"
  value       = local.record_fqdn
}

output "a_record_name" {
  description = "Name of the A record"
  value       = var.use_cloudfront && length(aws_route53_record.main) > 0 ? aws_route53_record.main[0].name : ""
}

output "a_record_type" {
  description = "Type of the A record"
  value       = var.use_cloudfront && length(aws_route53_record.main) > 0 ? aws_route53_record.main[0].type : ""
}

output "aaaa_record_created" {
  description = "Whether AAAA record was created"
  value       = var.use_cloudfront && var.enable_ipv6 && length(aws_route53_record.ipv6) > 0
}
