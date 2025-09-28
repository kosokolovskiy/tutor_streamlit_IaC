############################
# CloudFront module inputs #
############################

# Required for your current distribution/state
variable "origin_domain_name" {
  type        = string
  description = "Origin DNS name (EC2/ALB), e.g., ec2-*.compute.amazonaws.com"
}

variable "origin_id" {
  type        = string
  description = "Exact origin identifier used by the distribution (must match state)"
  default     = ""
}

variable "cache_policy_id" {
  type        = string
  description = "Managed Cache Policy ID used by default cache behavior"
}

variable "origin_request_policy_id" {
  type        = string
  description = "Managed Origin Request Policy ID used by default cache behavior"
}

# Optional/customization
variable "domain_name" {
  type        = string
  description = "Custom CNAME for the distribution (leave empty to use the default CloudFront domain)"
  default     = ""
}

variable "ssl_certificate_arn" {
  type        = string
  description = "ACM certificate ARN in us-east-1 (required when domain_name is set)"
  default     = ""
}

variable "price_class" {
  type        = string
  description = "CloudFront price class: PriceClass_All | PriceClass_200 | PriceClass_100"
  default     = "PriceClass_All"
}

variable "viewer_protocol_policy" {
  type        = string
  description = "Viewer protocol policy: allow-all | https-only | redirect-to-https"
  default     = "redirect-to-https"
}

variable "allowed_methods" {
  type        = list(string)
  description = "HTTP methods CloudFront will accept at the edge"
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "cached_methods" {
  type        = list(string)
  description = "HTTP methods CloudFront will cache"
  default     = ["GET", "HEAD"]
}

variable "origin_protocol_policy" {
  type        = string
  description = "How CloudFront connects to origin: http-only | https-only | match-viewer"
  default     = "http-only"
}

variable "origin_ssl_protocols" {
  type        = list(string)
  description = "TLS protocols allowed when connecting to the origin (keep as-is to match current state)"
  default     = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
}

# Tagging / naming (optional)
variable "environment" {
  type        = string
  description = "Environment label for tagging (e.g., dev, staging, prod)"
  default     = ""
}

variable "project_name" {
  type        = string
  description = "Project name for tagging"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the distribution"
  default     = {}
}
