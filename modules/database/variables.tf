# Database module variables

variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage in GB"
  default     = 20
}

variable "username" {
  type        = string
  description = "Database master username"
  default     = "main_user"
}

variable "password" {
  type        = string
  description = "Database master password"
  sensitive   = true
}

variable "backup_retention_period" {
  type        = number
  description = "Backup retention period in days"
  default     = 7
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of VPC security group IDs"
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to resources"
  default     = {}
}
