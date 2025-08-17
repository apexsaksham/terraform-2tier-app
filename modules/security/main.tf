# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-2"
  description = "Allow HTTP from anywhere"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg-2"
  }
}

# Backend Security Group
resource "aws_security_group" "backend_sg" {
  name        = "backend-sg-2"
  description = "Allow traffic from ALB and optional SSH"
  vpc_id      = var.vpc_id

  # Allow from ALB SG
  ingress {
    description     = "App traffic from ALB"
    from_port       = var.backend_app_port
    to_port         = var.backend_app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Optional SSH from your IP
  dynamic "ingress" {
    for_each = var.ssh_cidr != "" ? [1] : []
    content {
      description = "SSH from my IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.ssh_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-sg-2"
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-2"
  description = "Allow Postgres from backend SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from backend SG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg-2"
  }
}
