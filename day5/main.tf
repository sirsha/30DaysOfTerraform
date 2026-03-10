 resource "aws_s3_bucket" "demo" {
  bucket = local.full_bucket_name

  tags = local.common_tags  # comman tag
}

# resource "aws_instance" "web" {
#   ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (us-east-1)
#   instance_type = "t2.micro"

#   tags = {
#     Name        = "WebServer-${var.environment}"   # dynamic name tag
#     Environment = var.environment
#     Project     = local.common_tags.Project
#     Owner       = local.common_tags.Owner
#   }
  
# }