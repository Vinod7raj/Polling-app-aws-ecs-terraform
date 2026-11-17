output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}

output "frontend_service_name" {
  value = module.ecs.frontend_service_name
}

output "backend_service_name" {
  value = module.ecs.backend_service_name
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "db_secret_arn" {
  value = module.rds.db_secret_arn
}
