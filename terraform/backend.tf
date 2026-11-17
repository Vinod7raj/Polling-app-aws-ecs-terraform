terraform {
  backend "s3" {
    bucket         = "polling-terraform-automation"
    key            = "polling-app/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}
