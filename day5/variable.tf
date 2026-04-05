variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

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

variable "project" {
  description = "Project name"
  type        = string
  default     = "Terraform-Demo"
}