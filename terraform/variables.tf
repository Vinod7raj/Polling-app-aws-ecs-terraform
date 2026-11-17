variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

variable "frontend_ecr_url" {
  type        = string
  description = "ECR repo URL for frontend image"
}

variable "backend_ecr_url" {
  type        = string
  description = "ECR repo URL for backend image"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "log_group_name" {
  type        = string
  default     = "/ecs/polling-app"
  description = "CloudWatch log group name"
}

variable "sns_topic_name" {
  type        = string
  default     = "ecs-alerts"
  description = "SNS topic name for alerts"
}

variable "alert_email" {
  type        = string
  default     = "vinodutk123@gmail.com"
  description = "Email address for alerts"
}

variable "alarm_name" {
  type        = string
  default     = "ecs-cpu-high"
  description = "CloudWatch alarm name"
}

variable "alarm_threshold" {
  type        = number
  default     = 70
  description = "CPU utilization threshold"
}

variable "alarm_period" {
  type        = number
  default     = 60
  description = "Period in seconds"
}

variable "alarm_evaluation_periods" {
  type        = number
  default     = 2
  description = "Number of consecutive periods to evaluate"
}

variable "domain_name" {
  type        = string
  description = "The root domain name"
}
