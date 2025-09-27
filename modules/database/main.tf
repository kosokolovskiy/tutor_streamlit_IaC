# Database module - RDS MySQL instance

# RDS MySQL instance (exact match with state)
resource "aws_db_instance" "mysql_db" {
  identifier = "mysql-db"
  
  # Engine configuration
  engine         = "mysql"
  engine_version = "8.0.42"
  instance_class = var.instance_class
  
  # Storage configuration (match state exactly)
  allocated_storage     = var.allocated_storage
  max_allocated_storage = 0  # Match state exactly
  storage_type          = "gp2"
  storage_encrypted     = false  # Match state exactly
  
  # Database configuration
  db_name  = ""  # Match state exactly (empty)
  username = var.username
  password = var.password
  port     = 3306
  
  # Network configuration (use existing default subnet group)
  db_subnet_group_name   = "default-vpc-0f427c209ccf14a2d"
  vpc_security_group_ids = var.vpc_security_group_ids
  publicly_accessible    = true  # Match state exactly
  
  # Parameter and option groups (use defaults)
  parameter_group_name = "default.mysql8.0"
  option_group_name    = "default:mysql-8-0"
  
  # Backup configuration (match state exactly)
  backup_retention_period = var.backup_retention_period
  backup_window          = "20:20-20:50"  # Match state exactly
  maintenance_window     = "tue:22:07-tue:22:37"  # Match state exactly
  
  # Snapshot configuration
  skip_final_snapshot       = false
  final_snapshot_identifier = "mysql-db-final-snapshot"
  
  # Other settings (match state exactly)
  auto_minor_version_upgrade = true
  deletion_protection        = false
  copy_tags_to_snapshot     = false
  
  tags = {
    Name = "mysql-db"
    Env  = "prod"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      password,
      username,
      allocated_storage,
      backup_retention_period,
      instance_class,
      vpc_security_group_ids,
      tags_all,
      ca_cert_identifier,
      monitoring_role_arn
    ]
  }
}
