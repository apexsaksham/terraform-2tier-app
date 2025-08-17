variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "backend_sg_id" {
  description = "Backend security group ID"
  type        = string
}

variable "db_host" {
  description = "RDS endpoint"
  type        = string
}

variable "key_name" {
  description = "Name of an existing EC2 key pair to attach"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for EC2 (optional)"
  type        = string
  default     = ""
}
