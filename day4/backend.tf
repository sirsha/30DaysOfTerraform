terraform {
  backend "s3" {
    bucket       = "sirsha-s3-statefile-bucket"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}