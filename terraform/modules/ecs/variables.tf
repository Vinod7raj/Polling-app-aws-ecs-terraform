variable "backend_ecr_url" {
  type        = string
  description = "ECR repository URL for backend image"
}

variable "frontend_ecr_url" {
  type        = string
  description = "ECR repository URL for frontend image"
}

variable "db_endpoint" {
  type        = string
  description = "RDS endpoint for backend service"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet IDs for ECS tasks"
}

variable "ecs_sg_id" {
  type        = string
  description = "Security group ID for ECS tasks"
}

variable "backend_tg_arn" {
  type        = string
  description = "Target group ARN for backend service"
}

variable "frontend_tg_arn" {
  type        = string
  description = "Target group ARN for frontend service"
}

variable "cloudwatch_log_group_name" {
  type        = string
  description = "cloudwatch log group name for the task definition"
}


variable "db_secret_arn" {
  type        = string
  description = "Target group ARN for frontend service"
}
