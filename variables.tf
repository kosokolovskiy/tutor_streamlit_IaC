# Core configuration variables
variable "aws_region" {
  type        = string
  description = "The AWS region where resources will be created"
  default     = "eu-central-1"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  type        = string
  description = "Name of the project for resource naming"
  default     = "student-infrastructure"
}

# Networking configuration
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks allowed to SSH to instances"
  default     = ["0.0.0.0/0"]
}

# EC2 configuration
variable "ec2_config" {
  type = object({
    instance_type = string
    volume_size   = number
    volume_type   = string
  })
  description = "Configuration for EC2 instances"
  default = {
    instance_type = "t3.nano"
    volume_size   = 10
    volume_type   = "gp3"
  }
}

variable "ssh_key_name" {
  type        = string
  description = "Name of the SSH key pair for EC2 access"
  default     = "students-key"
}

variable "public_key_path" {
  type        = string
  description = "Path to the SSH public key file"
  default     = "~/.ssh/my_key.pub"
}

# S3 configuration
variable "s3_config" {
  type = object({
    enable_versioning = bool
    enable_encryption = bool
    lifecycle_days    = number
  })
  description = "Configuration for S3 buckets"
  default = {
    enable_versioning = true
    enable_encryption = true
    lifecycle_days    = 30
  }
}

# Database configuration
variable "db_config" {
  type = object({
    instance_class            = string
    allocated_storage         = number
    username                  = string
    password                  = string
    backup_retention_period   = number
    vpc_security_group_ids    = list(string)
  })
  description = "Configuration for RDS database"
  default = {
    instance_class            = "db.t3.micro"
    allocated_storage         = 20
    username                  = "main_user"
    password                  = "dummy_password"  # Will be ignored due to lifecycle rule
    backup_retention_period   = 7
    vpc_security_group_ids    = ["sg-0a038475400fdec88", "sg-0b10a84f257baa9d3"]
  }
  sensitive = true
}

# Domain configuration for existing infrastructure
variable "domain_config" {
  type = object({
    zone_name              = string
    zone_id                = string
    subdomain_label        = string
    cloudfront_domain_name = string
    mx_records             = list(string)
    txt_records            = list(string)
  })
  description = "Configuration for existing domain and CloudFront setup"
  default = {
    zone_name              = ""
    zone_id                = ""
    subdomain_label        = ""
    cloudfront_domain_name = ""
    mx_records             = []
    txt_records            = []
  }
}
