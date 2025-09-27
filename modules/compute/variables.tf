# Compute module variables

variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.nano"
}

variable "volume_size" {
  type        = number
  description = "Size of the root volume in GB"
  default     = 10
}

variable "volume_type" {
  type        = string
  description = "Type of the root volume"
  default     = "gp2"
}

variable "public_key_path" {
  type        = string
  description = "Path to the public key file"
  default     = "~/.ssh/my_key.pub"
}

variable "security_group_id" {
  type        = string
  description = "ID of the security group to attach to the instance"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where the instance will be launched"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to resources"
  default     = {}
}
