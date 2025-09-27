# Core infrastructure outputs
output "my_region" {
  description = "AWS region where resources are deployed"
  value       = var.aws_region
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

# Compute outputs
output "elastic_ip" {
  description = "Elastic IP address (immutable: 3.67.163.253)"
  value       = module.compute.elastic_ip
}

# # Networking outputs
# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = module.networking.vpc_id
# }

# output "public_subnet_ids" {
#   description = "IDs of the public subnets"
#   value       = module.networking.public_subnet_ids
# }

# output "private_subnet_ids" {
#   description = "IDs of the private subnets"
#   value       = module.networking.private_subnet_ids
# }

# # Compute outputs
# output "ec2_instance_id" {
#   description = "ID of the EC2 instance"
#   value       = module.compute.instance_id
# }

# output "ec2_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = module.compute.public_ip
# }

# output "ec2_private_ip" {
#   description = "Private IP address of the EC2 instance"
#   value       = module.compute.private_ip
# }

# # Storage outputs
# output "s3_bucket_names" {
#   description = "Names of the S3 buckets"
#   value       = module.storage.bucket_names
# }

# output "s3_bucket_arns" {
#   description = "ARNs of the S3 buckets"
#   value       = module.storage.bucket_arns
# }

# # Database outputs
# output "database_endpoint" {
#   description = "RDS instance endpoint"
#   value       = module.database.endpoint
#   sensitive   = true
# }

# output "database_port" {
#   description = "RDS instance port"
#   value       = module.database.port
# }

# # Route53 outputs
# output "hosted_zone_id" {
#   description = "ID of the Route53 hosted zone"
#   value       = length(module.route53) > 0 ? module.route53[0].zone_id : ""
# }

# output "record_fqdn" {
#   description = "FQDN of the DNS record created"
#   value       = length(module.route53) > 0 ? module.route53[0].record_fqdn : ""
# }

# output "domain_url" {
#   description = "URL of the application"
#   value       = length(module.route53) > 0 ? "https://${module.route53[0].record_fqdn}" : "http://${module.compute.public_ip}"
# }