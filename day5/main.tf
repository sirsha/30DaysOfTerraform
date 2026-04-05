resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "demo" {
  bucket = local.full_bucket_name

  tags = local.common_tags
}