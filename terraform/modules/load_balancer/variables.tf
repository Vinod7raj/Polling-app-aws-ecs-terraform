variable "vpc_id" {
  type        = string
  description = "VPC ID for the ALB"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet IDs for ALB"
}

variable "alb_sg_id" {
  type        = string
  description = "Security group ID for ALB"
}

variable "log_bucket_name" {
  type        = string
  description = "s3 bucket id to store the access log"
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate to attach to the ALB HTTPS listener"
  type        = string
}
