# ==============================
# Data Sources
# ==============================

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get current AWS region
data "aws_region" "current" {}

# Get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# ==============================
# Example 1: create_before_destroy
# Use Case: EC2 instance that needs zero downtime during updates
# ==============================

# resource "aws_instance" "web_server" {
#   ami           = data.aws_ami.amazon_linux_2.id
#   instance_type = var.instance_type[1]
#   subnet_id              = aws_subnet.main.id
#   vpc_security_group_ids = [aws_security_group.web_sg.id]

#   tags = merge(
#     var.resource_tags,
#     {
#       Name = var.instance_name
#       Demo = "create_before_destroy"
#     }
#   )

#   # Lifecycle Rule: Create new instance before destroying the old one
#   # This ensures zero downtime during instance updates (e.g., changing AMI or instance type)
#   lifecycle {
#     create_before_destroy = false
#   }
# }

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# resource "aws_security_group" "web_sg" {
#   name   = "web-sg"
#   vpc_id = aws_vpc.main.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # ==============================
# # Example 2: prevent_destroy
# # Use Case: Critical S3 bucket that should never be accidentally deleted
# # ==============================

# resource "aws_s3_bucket" "critical_data" {
#   bucket = "my-critical-production-data-sirsha-bucket123"

#   tags = merge(
#     var.resource_tags,
#     {
#       Name       = "Critical Production Data Bucket"
#       Demo       = "prevent_destroy"
#       DataType   = "Critical"
#       Compliance = "Required"
#     }
#   )

#   # Lifecycle Rule: Prevent accidental deletion of this bucket
#   # Terraform will throw an error if you try to destroy this resource
#   # To delete: Comment out prevent_destroy first, then run terraform apply
#   lifecycle {
#     # prevent_destroy = true  # COMMENTED OUT TO ALLOW DESTRUCTION
#   }
# }

# # Enable versioning on the critical bucket
# resource "aws_s3_bucket_versioning" "critical_data" {
#   bucket = aws_s3_bucket.critical_data.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }
# # ==============================
# # Example 3: ignore_changes
# # Use Case: Auto Scaling Group where capacity is managed externally
# # ==============================

# # Launch Template for Auto Scaling Group
# resource "aws_launch_template" "app_server" {
#   name_prefix   = "app-server-"
#   image_id      = data.aws_ami.amazon_linux_2.id
#   instance_type = var.instance_type[0]

#   vpc_security_group_ids = [aws_security_group.web_sg.id]

#   tag_specifications {
#     resource_type = "instance"
#     tags = merge(
#       var.resource_tags,
#       {
#         Name = "App Server from ASG"
#         Demo = "ignore_changes"
#       }
#     )
#   }
# }

# resource "aws_autoscaling_group" "app_servers" {
#   name              = "app-servers-asg"
#   min_size          = 1
#   max_size          = 5
#   desired_capacity  = 2
#   health_check_type = "EC2"

#   vpc_zone_identifier = [aws_subnet.main.id]

#   launch_template {
#     id      = aws_launch_template.app_server.id
#     version = "$Latest"
#   }

#   tag {
#     key                 = "Name"
#     value               = "App Server ASG"
#     propagate_at_launch = true
#   }

#   tag {
#     key                 = "Demo"
#     value               = "ignore_changes"
#     propagate_at_launch = false
#   }

#   lifecycle {
#     ignore_changes = [
#       desired_capacity
#     ]
#   }
# }

# ==============================
# Example 4: precondition
# Use Case: Ensure we're deploying in an allowed region
# ==============================

# resource "aws_s3_bucket" "regional_validation" {
#   bucket = "validated-region-bucket-${var.environment}-sirsha123"

#   tags = merge(
#     var.resource_tags,
#     {
#       Name = "Region Validated Bucket"
#       Demo = "precondition"
#     }
#   )

#   # Lifecycle Rule: Validate region before creating resource
#   # This prevents resource creation in unauthorized regions
#   lifecycle {
#     precondition {
#       condition     = contains(var.allowed_regions, data.aws_region.current.name)
#       error_message = "ERROR: This resource can only be created in allowed regions: ${join(", ", var.allowed_regions)}. Current region: ${data.aws_region.current.name}"
#     }
#   }
# }

# output "current_region" {
#   value = data.aws_region.current.name
# }

# # ==============================
# # Example 5: postcondition
# # Use Case: Ensure S3 bucket has required tags after creation
# # ==============================

# resource "aws_s3_bucket" "compliance_bucket" {
#   bucket = "compliance-bucket-${var.environment}-${data.aws_region.current.name}-sirsha123"

#   tags = merge(
#     var.resource_tags,
#     {
#       Name       = "Compliance Validated Bucket"
#       Demo       = "postcondition"
#     #   Compliance = "SOC2"
#     }
#   )

#   # Lifecycle Rule: Validate bucket has required tags after creation
#   # This ensures compliance with organizational tagging policies
#   lifecycle {
#     postcondition {
#       condition     = contains(keys(self.tags), "Compliance")
#       error_message = "ERROR: Bucket must have a 'Compliance' tag for audit purposes!"
#     }

#     postcondition {
#       condition     = contains(keys(self.tags), "Environment")
#       error_message = "ERROR: Bucket must have an 'Environment' tag!"
#     }
#   }
# }

# ==============================
# Example 6: replace_triggered_by
# Use Case: Replace EC2 instances when security group changes
# ==============================

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }
 
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }
  # Added new ingress rule for SSH  to demonstrate replace_triggered_by
  ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow SSH"
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "App Security Group"
      Demo = "replace_triggered_by"
    }
  )
}

# EC2 Instance that gets replaced when security group changes
resource "aws_instance" "app_with_sg" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type[0]
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  subnet_id              = aws_subnet.main.id

  tags = merge(
    var.resource_tags,
    {
      Name = "App Instance with Security Group"
      Demo = "replace_triggered_by"
    }
  )

  # Lifecycle Rule: Replace instance when security group changes
  # This ensures the instance is recreated with new security rules
  lifecycle {
    replace_triggered_by = [
      aws_security_group.app_sg
    ]
  }
}
