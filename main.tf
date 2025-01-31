terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source                 = "./modules/vpc"
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source             = "./modules/alb"
  vpc_id             = module.vpc.vpc_id
  public_subnets_by_az  =  module.vpc.public_subnets_by_az 
  security_group_id  = module.security_groups.alb_sg_id
}

module "postgres" {
  source             = "./modules/postgres"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id  = module.security_groups.postgres_sg_id
  key_name = var.key_name
}

module "autoscaling" {
  source               = "./modules/autoscaling"
  private_subnet_ids   = module.vpc.private_subnet_ids
  security_group_id    = module.security_groups.django_sg_id
  alb_target_group_arn = module.alb.target_group_arn
  ecr_image_url        = var.ecr_image_url
  key_name             = var.key_name
  region               = var.region
  db_host              = module.postgres.postgres_private_ip
  iam_instance_profile_name = module.iam.iam_instance_profile_name
}

module "bastion" {
  source             = "./modules/bastion"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = [module.vpc.public_subnet_ids[0]]
  security_group_id  = module.security_groups.bastion_sg_id
  key_name = var.key_name
}

module "iam" {
  source = "./modules/iam"
}
