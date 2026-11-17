output "bucket_id" {
  description = "Name of the log bucket"
  value       = aws_s3_bucket.alb_logs.id
}

output "bucket_arn" {
  description = "ARN of the log bucket"
  value       = aws_s3_bucket.alb_logs.arn
}

output "bucket_policy_id" {
  description = "Bucket policy ID, used so the ALB waits for the policy"
  value       = aws_s3_bucket_policy.alb_logs.id
}
