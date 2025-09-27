# CloudFront module variables

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "project_name" {
  type        = string
  description = "Name of the project for resource naming"
}

variable "origin_domain_name" {
  type        = string
  description = "Domain name of the origin (e.g., EC2 public IP or ALB DNS)"
  default     = ""
}

variable "origin_id" {
  type        = string
  description = "Unique identifier for the origin"
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket to use as origin (optional)"
  default     = ""
}

variable "s3_bucket_domain_name" {
  type        = string
  description = "Domain name of the S3 bucket (optional)"
  default     = ""
}

variable "s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket (optional)"
  default     = ""
}

variable "domain_name" {
  type        = string
  description = "Custom domain name for the distribution (optional)"
  default     = ""
}

variable "ssl_certificate_arn" {
  type        = string
  description = "ARN of the SSL certificate for custom domain (required if domain_name is set)"
  default     = ""
}

variable "price_class" {
  type        = string
  description = "Price class for the distribution"
  default     = "PriceClass_100"
  
  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "Price class must be one of: PriceClass_All, PriceClass_200, PriceClass_100."
  }
}

variable "enable_compression" {
  type        = bool
  description = "Enable compression for the distribution"
  default     = true
}

variable "viewer_protocol_policy" {
  type        = string
  description = "Protocol policy for viewers"
  default     = "redirect-to-https"
  
  validation {
    condition     = contains(["allow-all", "https-only", "redirect-to-https"], var.viewer_protocol_policy)
    error_message = "Viewer protocol policy must be one of: allow-all, https-only, redirect-to-https."
  }
}

variable "allowed_methods" {
  type        = list(string)
  description = "HTTP methods that CloudFront processes and forwards"
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "cached_methods" {
  type        = list(string)
  description = "HTTP methods for which CloudFront caches responses"
  default     = ["GET", "HEAD"]
}

variable "default_root_object" {
  type        = string
  description = "Default root object for the distribution"
  default     = "index.html"
}

variable "api_path_patterns" {
  type        = list(string)
  description = "Path patterns for API endpoints that should not be cached"
  default     = ["/api/*", "/admin/*"]
}

variable "custom_error_responses" {
  type = list(object({
    error_code         = number
    response_code      = number
    response_page_path = string
  }))
  description = "Custom error response configurations"
  default = [
    {
      error_code         = 404
      response_code      = 404
      response_page_path = "/404.html"
    },
    {
      error_code         = 500
      response_code      = 500
      response_page_path = "/500.html"
    }
  ]
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default     = {}
}
