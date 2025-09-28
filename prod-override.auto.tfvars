# Production environment overrides
environment = "prod"

# EC2 configuration for production (match current state exactly)
ec2_config = {
  instance_type = "t3.nano" # Match current state
  volume_size   = 10        # Match current state
  volume_type   = "gp2"     # Match current state
}

# Database configuration for production (match current state exactly)
db_config = {
  instance_class          = "db.t3.micro"                                    # Match current state
  allocated_storage       = 20                                               # Match current state
  username                = "main_user"                                      # Match current state
  password                = "dummy_password"                                 # Will be ignored due to lifecycle rule
  backup_retention_period = 7                                                # Match current state
  vpc_security_group_ids  = ["sg-0a038475400fdec88", "sg-0b10a84f257baa9d3"] # Match current state
}

# CloudFront configuration for production (disabled for now)
# Production domain configuration (disabled to avoid Route53 errors)
domain_config = {
  zone_name              = "" # Disabled for now
  zone_id                = "" # Disabled for now
  subdomain_label        = "" # Disabled for now
  cloudfront_domain_name = "" # Disabled for now
  mx_records             = []
  txt_records            = []
}