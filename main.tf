# Main Terraform configuration for student infrastructure
# This file orchestrates all modules to create a complete AWS infrastructure

terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Additional provider for SSL certificates (CloudFront requires certificates in us-east-1)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Data sources for existing resources
data "aws_caller_identity" "current" {}

# Local values for consistent naming and tagging
locals {
  common_tags = {
    Project     = "student-infrastructure"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "konstantin-sokolovskiy"
  }

  name_prefix = "${var.project_name}-${var.environment}"
}

# Networking module - Security groups for default VPC
module "networking" {
  source = "./modules/networking"

  environment  = var.environment
  project_name = var.project_name

  mongo_allowed_cidrs = var.mongo_allowed_cidrs

  tags = local.common_tags
}

# Compute module - EC2 instances using default VPC
module "compute" {
  source = "./modules/compute"

  environment  = var.environment
  project_name = var.project_name

  # Instance configuration (match state exactly)
  instance_type     = var.ec2_config.instance_type
  volume_size       = var.ec2_config.volume_size
  volume_type       = var.ec2_config.volume_type
  public_key_path   = var.public_key_path

  # Network configuration (using default VPC)
  security_group_id = module.networking.ssh_security_group_id

  tags = local.common_tags
}

# Data source for default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [module.networking.vpc_id]
  }
}

# Storage module - S3 buckets for different purposes
module "storage" {
  source = "./modules/storage"

  environment  = var.environment
  project_name = var.project_name

  tags = local.common_tags
}

# Database module - RDS MySQL instance
module "database" {
  source = "./modules/database"

  environment  = var.environment
  project_name = var.project_name

  # Database configuration (match state exactly)
  instance_class            = var.db_config.instance_class
  allocated_storage         = var.db_config.allocated_storage
  username                  = var.db_config.username
  password                  = var.db_config.password
  backup_retention_period   = var.db_config.backup_retention_period
  vpc_security_group_ids    = var.db_config.vpc_security_group_ids

  tags = local.common_tags
}


# Route53 module - DNS records for existing infrastructure
module "route53" {
  count  = var.domain_config.zone_name != "" ? 1 : 0
  source = "./modules/route53"

  environment  = var.environment
  project_name = var.project_name

  # Zone configuration
  zone_name       = var.domain_config.zone_name
  zone_id         = var.domain_config.zone_id
  subdomain_label = var.domain_config.subdomain_label

  # CloudFront configuration
  use_cloudfront            = true
  cloudfront_domain_name    = var.domain_config.cloudfront_domain_name
  cloudfront_hosted_zone_id = "Z2FDTNDATAQYW2"
  enable_ipv6               = true

  # Optional DNS records for zone apex
  mx_records  = var.domain_config.mx_records
  txt_records = var.domain_config.txt_records

  tags = local.common_tags

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

# Note: CloudFront distribution already exists and is managed outside Terraform
# The existing CloudFront distribution should be configured to use module.compute.public_ip as origin
