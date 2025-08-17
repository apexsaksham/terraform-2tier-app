# VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}

# Public subnet IDs
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

# Private subnet IDs
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
