# Networking module outputs

# VPC outputs (default VPC)
output "vpc_id" {
  description = "ID of the default VPC"
  value       = data.aws_vpc.default.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the default VPC"
  value       = data.aws_vpc.default.cidr_block
}

# Security Group outputs
output "ssh_security_group_id" {
  description = "ID of the SSH security group"
  value       = aws_security_group.ssh.id
}

# CloudFront prefix list
output "cloudfront_prefix_list_id" {
  description = "ID of the CloudFront origin prefix list"
  value       = data.aws_ec2_managed_prefix_list.cloudfront_origin.id
}
