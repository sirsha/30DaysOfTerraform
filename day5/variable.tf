variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "bucket_name" {
  description = "Base S3 bucket name"
  type        = string
  default     = "my-terraform-bucket"
}