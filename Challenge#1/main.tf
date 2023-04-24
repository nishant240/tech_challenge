provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source           = "./modules/vpc"
  aws_region       = var.aws_region
  aws_zones        = var.aws_zones
  vpc_cidr         = var.vpc_cidr
  app_name         = var.app_name
  tags             = var.tags
}

module "app_server" {
  source                  = "./modules/ec2"
  app_name                = var.app_name
  instance_count          = var.instance_count
  instance_type           = var.instance_type
  aws_zones               = var.aws_zones
  private_subnet_ids      = module.vpc.private_subnet_ids
  public_subnet_ids       = module.vpc.public_subnet_ids
  instance_volume_size    = var.instance_volume_size
  vpc_cidr                = var.vpc_cidr
  vpc_id                  = module.vpc.vpc_id
  user_data               = var.user_data
  private_key_path        = var.private_key_path
  tags                    = var.tags
}

module "rds" {
  source                = "./modules/rds"
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  engine                = var.engine
  engine_version        = var.engine_version
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  app_name              = var.app_name
  vpc_cidr              = var.vpc_cidr
  tags                  = var.tags
}

module "alb" {
  source              = "./modules/elb"
  vpc_id              = module.vpc.vpc_id
  instance_id         = module.app_server.instance_id
  app_name            = var.app_name
  public_subnet_ids   = module.vpc.public_subnet_ids
  tags                = var.tags
}