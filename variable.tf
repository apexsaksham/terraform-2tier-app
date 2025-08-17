variable "vpc_cidr" {

}
variable "public_subnet_cidrs" {

}

variable "private_subnet_cidrs" {

}

variable "availability_zones" {

}




variable "backend_app_port" {


}

variable "ssh_cidr" {

}

variable "ec2_public_ip" {

}










variable "instance_type" {

}





variable "iam_instance_profile" {
  description = "IAM instance profile name for EC2 (optional)"
  type        = string
  default     = "ec2-backend-role"
}










variable "key_name" {

}