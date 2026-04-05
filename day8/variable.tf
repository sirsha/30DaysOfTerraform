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

variable "instance_count"{
  description = "Number of EC2 instances to create"
  type        = number
  
}

variable "monitoring_enabled" {
  description = "Enabled detail monitoring for EC2 Instance"
  type = bool
  default = true
  
}

variable "associate_public_ip_address" {
  description = "associated public IP address with EC2 Instance"
  type = bool
  default = true

}

variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = list(string)
  default     = ["10.0.0.0/16", "20.0.0.0/16", "30.0.0.0/16" ]
  
}

variable "allowed_vm_type" {
  description = "Allowed VM types for EC2 instance"
  type        = set(string)
  default     = ["t2.micro", "t3.micro", "t4g.micro"]
  
}
variable "tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Name = "dev-Instance"
    CreatedBy = "Sirsha"
  }
  
}

variable "ingress_values" {
  description = "Value for ingress rule"
  type        = tuple([ number, string, number ])
  default = [ 443, "tcp", 443 ]
  
}
variable "storage_size" {
    type = number
    description = "the storage size for ec2 instance in GB"
    default = 8
}
variable "server_config" {
    type = object({
        name = string
        instance_type = string
        monitoring = bool
        storage_gb = number
        backup_enabled = bool
    })
    description = "Complete server configuration object"
    default = {
        name = "web-server"
        instance_type = "t2.micro"
        monitoring = true
        storage_gb = 20
        backup_enabled = false
    }
}

variable "bucket_names" {
    type = list(string)
    description = "List of S3 bucket names to create"
    default = ["my-unique-bucket1-name-1234596", "my-unique-bucket1-name-6789096"]

  
}

# Set type - used with for_each
variable "s3_bucket_set" {
  type        = set(string)
  description = "Set of S3 bucket names for for_each example"
  default     = ["tf-day08-foreach-bucket-a-20251016aaaaa", "tf-day08-foreach-bucket-b-20251016bbbbbb"]
}
