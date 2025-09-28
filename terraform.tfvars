# Development environment configuration
aws_region   = "eu-central-1"
environment  = "dev"
project_name = "student-infrastructure"

# Networking configuration
vpc_cidr          = "10.0.0.0/16"
allowed_ssh_cidrs = ["0.0.0.0/0"]

# EC2 configuration
ec2_config = {
  instance_type = "t3.nano"
  volume_size   = 10
  volume_type   = "gp2"
}

ssh_key_name = "students-key"

# S3 configuration
s3_config = {
  enable_versioning = true
  enable_encryption = true
  lifecycle_days    = 30
}

# Database configuration
db_config = {
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = "main_user"
  password                = "dummy_password" # Will be ignored due to lifecycle rule
  backup_retention_period = 7
  vpc_security_group_ids  = ["sg-0a038475400fdec88", "sg-0b10a84f257baa9d3"]
}

# CloudFront configuration
# Domain configuration for existing infrastructure
domain_config = {
  zone_name              = "" # Set to your domain name if you have one
  zone_id                = "" # Set to your hosted zone ID if known
  subdomain_label        = "" # Set to subdomain like "students"
  cloudfront_domain_name = "" # Set to your existing CloudFront domain
  mx_records             = []
  txt_records            = []
}