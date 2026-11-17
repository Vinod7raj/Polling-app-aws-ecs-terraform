output "db_endpoint" {
  value = aws_db_instance.mysql.address
}

output "db_username" {
  value = var.db_username
}

output "db_secret_arn" {
  value = aws_db_instance.mysql.master_user_secret[0].secret_arn
}
