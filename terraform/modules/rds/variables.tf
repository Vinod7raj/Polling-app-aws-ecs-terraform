variable "private_subnets" {
  type        = list(string)
  description = "Private subnet IDs where RDS will be deployed"
}

variable "db_sg_id" {
  type        = string
  description = "Security group IDs for RDS instance"
}

variable "db_username" {
  type        = string
  description = "Master username for the RDS instance"
}
