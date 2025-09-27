# CloudFront module - CDN distribution and related resources

# Origin Access Control for S3 (if using S3 as origin)
resource "aws_cloudfront_origin_access_control" "main" {
  count = var.s3_bucket_name != "" ? 1 : 0

  name                              = "${var.project_name}-${var.environment}-oac"
  description                       = "Origin Access Control for ${var.project_name} ${var.environment}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "main" {
  # Origin configuration
  dynamic "origin" {
    for_each = var.s3_bucket_name != "" ? [1] : []
    content {
      domain_name              = var.s3_bucket_domain_name
      origin_id                = "${var.origin_id}-s3"
      origin_access_control_id = aws_cloudfront_origin_access_control.main[0].id
    }
  }

  dynamic "origin" {
    for_each = var.origin_domain_name != "" ? [1] : []
    content {
      domain_name = var.origin_domain_name
      origin_id   = var.origin_id

      custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${var.project_name} ${var.environment}"
  default_root_object = var.default_root_object

  # Aliases (custom domain names)
  aliases = var.domain_name != "" ? [var.domain_name] : []

  # Default cache behavior
  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = var.origin_id
    compress               = var.enable_compression
    viewer_protocol_policy = var.viewer_protocol_policy

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin", "Referer"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Additional cache behaviors for API endpoints
  dynamic "ordered_cache_behavior" {
    for_each = var.api_path_patterns
    content {
      path_pattern           = ordered_cache_behavior.value
      allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods         = ["GET", "HEAD"]
      target_origin_id       = var.origin_id
      compress               = true
      viewer_protocol_policy = "redirect-to-https"

      forwarded_values {
        query_string = true
        headers      = ["*"]

        cookies {
          forward = "all"
        }
      }

      min_ttl     = 0
      default_ttl = 0
      max_ttl     = 0
    }
  }

  # Geographic restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL/TLS certificate
  viewer_certificate {
    cloudfront_default_certificate = var.domain_name == ""
    acm_certificate_arn            = var.domain_name != "" ? var.ssl_certificate_arn : null
    ssl_support_method             = var.domain_name != "" ? "sni-only" : null
    minimum_protocol_version       = var.domain_name != "" ? "TLSv1.2_2021" : null
  }

  # Price class
  price_class = var.price_class

  # Custom error pages
  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code         = custom_error_response.value.error_code
      response_code      = custom_error_response.value.response_code
      response_page_path = custom_error_response.value.response_page_path
    }
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-cloudfront"
  })
}

# S3 bucket policy to allow CloudFront access (if using S3 as origin)
resource "aws_s3_bucket_policy" "cloudfront_access" {
  count  = var.s3_bucket_name != "" ? 1 : 0
  bucket = var.s3_bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${var.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.main.arn
          }
        }
      }
    ]
  })
}
