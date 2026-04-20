# ==============================
# General Variables
# ==============================

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

# ==============================
# S3 Bucket Variables
# ==============================

variable "bucket_names" {
  description = "Set of S3 bucket names to create"
  type        = set(string)
  default     = ["demo-lifecycle-bucket-001", "demo-lifecycle-bucket-002"]
}

variable "allowed_regions" {
  description = "List of allowed AWS regions"
  type        = list(string)
  default     = ["us-east-1", "us-west-2", "eu-west-1", "ap-south-1"]
}

# ==============================
# EC2 Variables
# ==============================

# variable "instance_type" {
#   description = "EC2 instance type"
#   type        = list(string)
#   default     = ["t2.micro", "t3.micro", "t3a.micro"]
# }

variable "instance_name" {
  description = "Name tag for EC2 instance"
  type        = string
  default     = "lifecycle-demo-instance"
}

# ==============================
# RDS Variables
# ==============================

variable "db_username" {
  description = "Database administrator username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  default     = "ChangeMe123!"
  sensitive   = true
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "myappdb"
}

# ==============================
# Tags
# ==============================

variable "resource_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Team        = "DevOps"
    CostCenter  = "Engineering"
    # Compliance   = "true"
  }
}


# ==============================================================================
# ASSIGNMENT 1: Project Naming Convention
# ==============================================================================

variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "Project ALPHA Resource"
}


# ==============================================================================
# ASSIGNMENT 2: Resource Tagging
# ==============================================================================

variable "default_tags" {
  type = map(string)
  default = {
    company    = "TechCorp"
    managed_by = "terraform"
  }
}

variable "environment_tags" {
  type = map(string)
  default = {
    environment = "production"
    cost_center = "cc-123"
  }
}

# ==============================================================================
# ASSIGNMENT 3: S3 Bucket Naming
# ==============================================================================

variable "bucket_name" {
  type        = string
  description = "S3 bucket name (must be globally unique)"
  default     = "ProjectAlphaStorageBucket with CAPS and spaces!!!"
}

# ==============================================================================
# ASSIGNMENT 4: Security Group Port Configuration
# ==============================================================================

variable "allowed_ports" {
  type        = string
  description = "Comma-separated list of allowed ports"
  default     = "80,443,8080,3306"
}
variable "instance_sizes" {
  type = map(string)
  default = {
    dev     = "t2.micro"
    staging = "t3.small"
    prod    = "t3.large"
  }

  
}


# ==============================================================================
# ASSIGNMENT 6: Instance Type Validation
# ==============================================================================

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"

  validation {
    condition     = length(var.instance_type) >= 2 && length(var.instance_type) <= 20
    error_message = "Instance type must be between 2 and 20 characters"
  }

  validation {
    condition     = can(regex("^t[2-3]\\.", var.instance_type))
    error_message = "Instance type must start with t2 or t3"
  }
}

# ==============================================================================
# ASSIGNMENT 7: Backup Configuration
# ==============================================================================

variable "backup_name" {
  type        = string
  description = "Backup configuration name"
  default     = "daily_backup"

  validation {
    condition     = endswith(var.backup_name, "_backup")
    error_message = "Backup name must end with '_backup'"
  }
}

variable "credential" {
  type        = string
  description = "Sensitive credential"
  default     = "xyz123"
  sensitive   = true
}

# ==============================================================================
# ASSIGNMENT 9: Resource Location Management
# ==============================================================================

variable "user_locations" {
  type        = list(string)
  description = "User-specified AWS regions"
  default     = ["us-east-1", "us-west-2", "us-east-1"] # Contains duplicate
}

variable "default_locations" {
  type        = list(string)
  description = "Default AWS regions"
  default     = ["us-west-1"]
}

# ==============================================================================
# ASSIGNMENT 10: Cost Calculation
# ==============================================================================

variable "monthly_costs" {
  type        = list(number)
  description = "Monthly infrastructure costs (can include negative values for credits)"
  default     = [-50, 100, 75, 200]
}
