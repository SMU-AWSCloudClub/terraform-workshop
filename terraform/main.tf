locals {
  prefix = "itsa-singapore"
}

module "vpc" {
  source = "./modules/vpc"
  prefix = local.prefix
}

module "aurora" {
  source               = "./modules/aurora"
  prefix               = local.prefix
  security_group_id    = module.vpc.db_sg_id
  db_subnet_group_name = module.vpc.db_subnet_group_name
}

module "ecs" {
  source            = "./modules/ecs"
  prefix            = local.prefix
  lb_sg_ids         = [module.vpc.lb_sg_id]
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  ecs_tasks_sg_ids  = [module.vpc.ecs_tasks_sg_id]
  db_endpoint       = module.aurora.aurora_instance_endpoint
}
