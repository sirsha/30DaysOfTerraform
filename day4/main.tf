terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    
  }
 
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "day4" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-demo-vpc"
  }
}
resource "aws_s3_bucket" "demo" {
  bucket = "sirsha-terraform-vpc-demo-123456"
  tags = {
    Name   = "terraform-demo-bucket"
    VpcId  = aws_vpc.day4.id
    VpcCIDR = aws_vpc.day4.cidr_block
  }


}