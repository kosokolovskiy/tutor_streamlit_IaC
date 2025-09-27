# Storage module - S3 buckets

# S3 bucket for SVGs (exact match with state)
resource "aws_s3_bucket" "kosokolovsky_bucket_svgs" {
  bucket = "kosokolovsky-bucket-svgs"

  tags = {
    Name           = "Students Math"
    can_be_deleted = "no"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags_all]
  }
}

# Versioning for SVGs bucket (exact match with state)
resource "aws_s3_bucket_versioning" "kosokolovsky_bucket_svgs" {
  bucket = aws_s3_bucket.kosokolovsky_bucket_svgs.id
  
  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    ignore_changes = all
  }
}

# S3 bucket for lambda layers (exact match with state)
resource "aws_s3_bucket" "test_bucket" {
  bucket = "lambda-layers-kosokolovskiy"

  tags = {
    Name           = "lambda_layers_bucket_test"
    can_be_deleted = "yes"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags_all]
  }
}

# Versioning for test bucket (exact match with state)
resource "aws_s3_bucket_versioning" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    ignore_changes = all
  }
}

# Public access block for test bucket (exact match with state)
resource "aws_s3_bucket_public_access_block" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  lifecycle {
    ignore_changes = all
  }
}

# Server-side encryption for test bucket (exact match with state)
resource "aws_s3_bucket_server_side_encryption_configuration" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = "alias/aws/s3"
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }

  lifecycle {
    ignore_changes = all
  }
}

# Lifecycle configuration for test bucket (exact match with state)
resource "aws_s3_bucket_lifecycle_configuration" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id

  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }

  lifecycle {
    ignore_changes = all
  }
}

# Ownership controls for test bucket (exact match with state)
resource "aws_s3_bucket_ownership_controls" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }

  lifecycle {
    ignore_changes = all
  }
}
