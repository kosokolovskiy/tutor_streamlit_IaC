# S3 Bucket kosokolovsky-bucket-svgs

resource "aws_s3_bucket" "kosokolovsky_bucket_svgs" {
  bucket = "kosokolovsky-bucket-svgs"
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name           = "Students Math"
    can_be_deleted = "no"
  }
}


resource "aws_s3_bucket_versioning" "kosokolovsky_bucket_svgs" {
  bucket = aws_s3_bucket.kosokolovsky_bucket_svgs.id
  versioning_configuration {
    status = "Enabled"
  }
}



###############################################################

# S3 Bucket TEST
resource "aws_s3_bucket" "test_bucket" {
  bucket = "lambda-layers-kosokolovskiy"
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name           = "lambda_layers_bucket_test"
    can_be_deleted = "yes"
  }
}


resource "aws_s3_bucket_public_access_block" "test_bucket" {
  bucket                  = aws_s3_bucket.test_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = "alias/aws/s3"
    }
    bucket_key_enabled = true
  }
}



resource "aws_s3_bucket_ownership_controls" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id
  rule { object_ownership = "BucketOwnerEnforced" }
}

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
}
