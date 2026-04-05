locals {
  common_tags = {
    Environment = var.environment
    Name   = "${var.environment}-EC2-Instance"
    ManagedBy   = "Terraform"
    Team        = "Sirsha"
  }

 
}