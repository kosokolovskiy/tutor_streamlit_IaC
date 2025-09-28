# Networking module variables

variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to resources"
  default     = {}
}

variable "mongo_allowed_cidrs" {
  description = "CIDRs allowed to access MongoDB (27017)"
  type        = list(string)
  default     = []
}
