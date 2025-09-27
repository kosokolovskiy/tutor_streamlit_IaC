# Storage module outputs

# SVGs bucket outputs
output "svgs_bucket_id" {
  description = "ID of the SVGs S3 bucket"
  value       = aws_s3_bucket.kosokolovsky_bucket_svgs.id
}

output "svgs_bucket_arn" {
  description = "ARN of the SVGs S3 bucket"
  value       = aws_s3_bucket.kosokolovsky_bucket_svgs.arn
}

output "svgs_bucket_domain_name" {
  description = "Domain name of the SVGs S3 bucket"
  value       = aws_s3_bucket.kosokolovsky_bucket_svgs.bucket_domain_name
}

# Lambda layers bucket outputs
output "lambda_bucket_id" {
  description = "ID of the lambda layers S3 bucket"
  value       = aws_s3_bucket.test_bucket.id
}

output "lambda_bucket_arn" {
  description = "ARN of the lambda layers S3 bucket"
  value       = aws_s3_bucket.test_bucket.arn
}

output "lambda_bucket_domain_name" {
  description = "Domain name of the lambda layers S3 bucket"
  value       = aws_s3_bucket.test_bucket.bucket_domain_name
}
