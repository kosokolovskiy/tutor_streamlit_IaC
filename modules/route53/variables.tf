# Core variables
variable "project_name" {
  type        = string
  description = "Project name for tagging"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to resources"
  default     = {}
}

# Zone configuration
variable "zone_name" {
  type        = string
  description = "Public hosted zone name (e.g. tutor-kosokolovskiy.com)"
}

variable "zone_id" {
  type        = string
  description = "Hosted zone ID if known (to skip lookup)"
  default     = ""
}

# Subdomain configuration
variable "subdomain_label" {
  type        = string
  description = "Subdomain label (e.g. 'students' for students.domain.com)"
}

# CloudFront configuration
variable "use_cloudfront" {
  type        = bool
  description = "Whether to create CloudFront alias records"
  default     = true
}

variable "cloudfront_domain_name" {
  type        = string
  description = "CloudFront distribution domain name (e.g. d123456789.cloudfront.net)"
  default     = ""
}

variable "cloudfront_hosted_zone_id" {
  type        = string
  description = "CloudFront hosted zone ID (always Z2FDTNDATAQYW2 for CloudFront)"
  default     = "Z2FDTNDATAQYW2"
}

variable "enable_ipv6" {
  type        = bool
  description = "Create AAAA record for IPv6 support"
  default     = true
}

# Optional DNS records for zone apex
variable "mx_records" {
  type        = list(string)
  description = "MX records for the zone apex"
  default     = []
}

variable "txt_records" {
  type        = list(string)
  description = "TXT records for the zone apex"
  default     = []
}
