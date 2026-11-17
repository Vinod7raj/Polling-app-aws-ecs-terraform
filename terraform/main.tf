

provider "aws" {
  region = var.aws_region
}

locals {
  service_name = "polling-backend-service"
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}


module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}


module "alb" {
  source              = "./modules/load_balancer"
  log_bucket_name     = module.s3.bucket_id
  depends_on          = [module.s3]
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  alb_sg_id           = module.security_groups.alb_sg_id
  acm_certificate_arn = module.acm.certificate_arn
}

module "rds" {
  source          = "./modules/rds"
  private_subnets = module.vpc.private_subnets
  db_sg_id        = module.security_groups.db_sg_id
  db_username     = var.db_username
}

module "s3" {
  source = "./modules/s3_bucket"
}


module "ecs" {
  source           = "./modules/ecs"
  private_subnets  = module.vpc.private_subnets
  ecs_sg_id        = module.security_groups.ecs_sg_id
  frontend_tg_arn  = module.alb.frontend_tg
  backend_tg_arn   = module.alb.backend_tg
  frontend_ecr_url = var.frontend_ecr_url
  backend_ecr_url  = var.backend_ecr_url

  db_endpoint   = module.rds.db_endpoint
  db_username   = module.rds.db_username
  db_secret_arn = module.rds.db_secret_arn

  cloudwatch_log_group_name = module.cloudwatch.log_group_name
  depends_on = [
    module.alb,
    module.rds
  ]
}

module "cloudwatch" {
  source                   = "./modules/cloudwatch"
  log_group_name           = var.log_group_name
  sns_topic_name           = var.sns_topic_name
  alert_email              = var.alert_email
  alarm_name               = var.alarm_name
  cluster_name             = module.ecs.cluster_name
  service_name             = local.service_name
  threshold                = var.alarm_threshold
  period                   = var.alarm_period
  alarm_evaluation_periods = var.alarm_evaluation_periods
}

module "acm" {
  source             = "./modules/acm"
  domain_name        = module.route53.domain_name
  pollingapp_zone_id = module.route53.zone_id

}

module "route53" {
  source      = "./modules/route53"
  domain_name = var.domain_name

}

resource "aws_route53_record" "pollingapp_alias" {
  zone_id = module.route53.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}

