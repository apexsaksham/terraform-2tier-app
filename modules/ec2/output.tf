output "ami_id" {
  value = data.aws_ami.ubuntu.id

}

# EC2 instance ID
output "ec2_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}


# EC2 private IP
output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web.private_ip
}

output "ec2_public_ip" {
  description = "public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}