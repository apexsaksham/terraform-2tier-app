output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.main.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.main.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "uploaded_files" {
  description = "List of uploaded file keys"
  value       = [for file in aws_s3_object.static_files : file.key]
}

output "bucket_name" {
  description = "The S3 bucket name"
  value       = aws_s3_bucket.main.id
}
