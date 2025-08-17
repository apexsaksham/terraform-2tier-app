variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}
variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the ALB/Target Group"
  type        = string
}

variable "target_port" {
  description = "Target port your backend listens on (e.g., 5000)"
  type        = number
}

variable "backend_instance_id" {
  description = "ID of the backend EC2 instance to attach to the target group"
  type        = string
}