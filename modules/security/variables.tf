variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "backend_app_port" {
  description = "Port on which backend application listens"
  type        = number

}

variable "ssh_cidr" {
  description = "Your IP address for SSH access (e.g., 203.0.113.10/32). Leave empty to disable SSH rule."
  type        = string

}
