output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.demo.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.demo.arn
}

output "environment" {
  description = "Environment value used in deployment"
  value       = var.environment
}

output "tags" {
  description = "Tags applied to the bucket"
  value       = local.common_tags
}