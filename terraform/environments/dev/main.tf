data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "network" {
  source = "../../modules/network"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = local.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.network.vpc_id
  admin_cidr   = var.admin_cidr
  app_port     = var.app_port
}

module "compute" {
  source = "../../modules/compute"

  project_name            = var.project_name
  environment             = var.environment
  public_subnet_id        = module.network.public_subnet_ids[0]
  private_subnet_ids      = module.network.private_subnet_ids
  admin_security_group_id = module.security.admin_security_group_id
  app_security_group_id   = module.security.app_security_group_id
  ssh_public_key_path     = var.ssh_public_key_path
  admin_instance_type     = var.admin_instance_type
  app_instance_type       = var.app_instance_type
}

module "load_balancer" {
  source = "../../modules/load-balancer"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  app_instance_ids      = module.compute.app_instance_ids
  app_port              = var.app_port
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name            = var.project_name
  environment             = var.environment
  aws_region              = var.aws_region
  admin_instance_id       = module.compute.admin_instance_id
  app_instance_ids        = module.compute.app_instance_ids
  alb_arn_suffix          = module.load_balancer.alb_arn_suffix
  target_group_arn_suffix = module.load_balancer.target_group_arn_suffix
}


