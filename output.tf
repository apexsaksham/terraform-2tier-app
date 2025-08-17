# -----------------
# VPC Info
# -----------------
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# -----------------
# Security Groups
# -----------------
output "backend_sg_id" {
  value = module.security.backend_sg_id
}

output "alb_sg_id" {
  value = module.security.alb_sg_id
}

output "rds_sg_id" {
  value = module.security.rds_sg_id
}

# -----------------
# RDS Info
# -----------------
output "rds_endpoint" {
  description = "The RDS endpoint"
  value       = module.rds.db_endpoint
}

# -----------------
# EC2 Info
# -----------------
output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}
# -----------------
# ALB Info
# -----------------
output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

# -----------------
# S3 Info
# -----------------
output "s3_bucket_name" {
  description = "The name of the frontend S3 bucket"
  value       = module.s3_frontend.bucket_name
}

