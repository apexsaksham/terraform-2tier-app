resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = merge({
    Name = var.bucket_name
  }, var.tags)
}

# Object Ownership - ACLs disabled (recommended)
resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Block Public Access settings - disabled as requested
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket Versioning - Disabled
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Disabled"
  }
}

# Server-side encryption configuration with bucket key enabled
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Upload static files
locals {
  files_to_upload = var.upload_files ? {
    "index.html"  = { content_type = "text/html" }
    "result.html" = { content_type = "text/html" }
    "style.css"   = { content_type = "text/css" }
  } : {}
}

resource "aws_s3_object" "static_files" {
  for_each = local.files_to_upload

  bucket       = aws_s3_bucket.main.id
  key          = each.key
  source       = "${var.files_path}/${each.key}"
  etag         = filemd5("${var.files_path}/${each.key}")
  content_type = each.value.content_type

  tags = var.tags
}