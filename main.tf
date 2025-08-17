

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  # outputs expected: vpc_id, public_subnet_ids, private_subnet_ids
}

module "security" {
  source           = "./modules/security"
  vpc_id           = module.vpc.vpc_id
  backend_app_port = var.backend_app_port
  ssh_cidr         = var.ec2_public_ip
  # outputs expected: backend_sg_id, rds_sg_id, alb_sg_id
}

module "rds" {
  source             = "./modules/rds"
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security.rds_sg_id
  # outputs expected: db_endpoint
}

module "ec2" {
  source        = "./modules/ec2"
  instance_type = var.instance_type
  subnet_id     = module.vpc.private_subnet_ids[0]
  backend_sg_id = module.security.backend_sg_id
  db_host       = module.rds.db_endpoint
  key_name      = var.key_name
  # ensure EC2 waits for RDS plan-wise
  depends_on = [module.rds]
}


module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  alb_sg_id           = module.security.alb_sg_id
  target_port         = var.backend_app_port
  backend_instance_id = module.ec2.ec2_id
  # ✅ coming from EC2 module output
}



module "s3_frontend" {
  source = "./modules/s3_frontend"
  # bucket_name optional if your module has a default
  tags = {
    Project = "frontend"
  }
  upload_files = true
  files_path   = "./files"
}
