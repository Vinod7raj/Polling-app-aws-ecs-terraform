data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {}   # the right ELB log-writer account for this region

resource "aws_s3_bucket" "alb_logs" {
  bucket = "access-log-polling710321"
}


resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = data.aws_elb_service_account.main.arn }
      Action    = "s3:PutObject"
      Resource  = "${aws_s3_bucket.alb_logs.arn}/alb/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    }]
  })
}

