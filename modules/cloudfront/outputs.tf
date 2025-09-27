# CloudFront module outputs

output "distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.id
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.arn
}

output "domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "hosted_zone_id" {
  description = "Hosted zone ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.hosted_zone_id
}

output "status" {
  description = "Current status of the distribution"
  value       = aws_cloudfront_distribution.main.status
}

output "etag" {
  description = "Current version of the distribution's information"
  value       = aws_cloudfront_distribution.main.etag
}

output "origin_access_control_id" {
  description = "ID of the Origin Access Control (if created)"
  value       = length(aws_cloudfront_origin_access_control.main) > 0 ? aws_cloudfront_origin_access_control.main[0].id : null
}
