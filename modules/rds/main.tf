# Subnet group for RDS
resource "aws_db_subnet_group" "postgres_subnets" {
  name       = "tf-postgres-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "tf-postgres-subnet-group"
  }
}


# RDS instance
resource "aws_db_instance" "postgres" {
  allocated_storage      = 10
  db_name                = "postgres"
  engine                 = "postgres"
  engine_version         = "16.6"
  instance_class         = "db.t3.micro"
  username               = "saksham"
  password               = "sakshamsingh"
  parameter_group_name   = "default.postgres16"
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnets.name
  vpc_security_group_ids = [var.rds_sg_id] # SG allowing 5432 from backend
  skip_final_snapshot    = true
}