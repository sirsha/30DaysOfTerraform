# Terraform Variables Demo (S3 Bucket)

A simple Terraform project demonstrating the **three types of Terraform variables** using an AWS S3 bucket.

This project helps understand how Terraform variables make Infrastructure as Code **flexible, reusable, and maintainable**.

---

# 📘 Day 5 – Terraform Variables

Welcome to **Day 5 of my 30 Days AWS Terraform Journey**.

Today I explored one of the most fundamental Terraform concepts — **Variables**.

Instead of hardcoding values in Terraform configurations, variables allow us to **parameterize infrastructure** so that the same code can be reused across multiple environments.

Benefits of using variables:

- Flexible infrastructure configuration
- Reusable Terraform code
- Cleaner and maintainable code
- Environment-specific deployments

---

# What Are Variables in Terraform?

Variables allow you to **customize Terraform configurations without modifying the core code**.

Instead of writing hardcoded values like:

```
bucket = "dev-project-bucket"
```

You can define a variable:

```
bucket = var.bucket_name
```

Now the value can be **changed dynamically without editing Terraform code**.

---

# 🎯 Types of Variables in Terraform

Terraform supports **three main types of variables**.

| Variable Type | Purpose | Similar To |
|---|---|---|
| Input Variables | Pass values into Terraform | Function parameters |
| Local Variables | Internal computed values | Local variables in programming |
| Output Variables | Values returned after deployment | Function return values |

---

# 🏗 Demo Architecture

This project creates a **simple S3 bucket** to demonstrate how all three variable types work together.

The bucket:

- Uses **Input Variables** for environment and bucket name
- Uses **Local Variables** for computed values and reusable tags
- Uses **Output Variables** to display infrastructure details after deployment

---

# Project Structure

```
terraform-variables-demo/
│
├── main.tf
├── providers.tf
├── variables.tf
├── locals.tf
├── outputs.tf
├── terraform.tfvars
├── README.md
└── .gitignore
```

---

# providers.tf

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

---

# variables.tf (Input Variables)

```hcl
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
```

---

# locals.tf (Local Variables)

Local variables help reduce repetition and follow the **DRY principle (Don't Repeat Yourself)**.

```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
    Team        = "Sirsha"
  }

  full_bucket_name = "${var.environment}-${var.bucket_name}-${random_string.suffix.result}"
}
```

---

# main.tf

```hcl
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "demo" {
  bucket = local.full_bucket_name

  tags = local.common_tags
}
```

---

# outputs.tf (Output Variables)

Outputs allow us to **view important resource attributes after deployment**.

```hcl
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
```

---

# terraform.tfvars

Terraform automatically loads values from this file.

```hcl
aws_region  = "us-east-1"
environment = "demo"
bucket_name = "terraform-demo-bucket"
project     = "Terraform-Demo"
```

---

# Variable Precedence

Terraform determines variable values using this priority:

| Priority | Source |
|---|---|
| 1 (Highest) | Command line `-var` |
| 2 | `.tfvars` or `-var-file` |
| 3 | Environment variables `TF_VAR_` |
| 4 (Lowest) | Default values |

---

# How to Run This Project

Initialize Terraform:

```
terraform init
```

Preview the execution plan:

```
terraform plan
```

Apply infrastructure:

```
terraform apply
```

---

# View Outputs

```
terraform output
```

View specific output:

```
terraform output bucket_name
```

JSON output format:

```
terraform output -json
```

---

# Example Output

```
It  changes because of terraform.tfvars has higher precedence than local variable.
bucket_name = "demo-terraform-demo-bucket-x8sd2"
bucket_arn  = "arn:aws:s3:::demo-terraform-demo-bucket-x8sd2"
environment = "demo"

tags = {
  "Environment" = "demo"
  "Project"     = "Terraform-Demo"
}
```

---

# 📦 What This Project Demonstrates

This project demonstrates:

- Input variables for dynamic infrastructure configuration
- Local variables for reusable expressions
- Output variables for exposing resource attributes
- Dynamic S3 bucket naming
- Reusable tagging strategy


## 🚀 Variable Precedence Testing

### 1. **Default Values** (temporarily hide terraform.tfvars)
```bash
mv terraform.tfvars terraform.tfvars.backup
terraform plan
# Uses: environment = "staging" (from variables.tf default)
mv terraform.tfvars.backup terraform.tfvars  # restore
```
![Example 1](https://github.com/sirsha/30DaysOfTerraform/blob/main/day5/sc1.png)

### 2. **Using terraform.tfvars** (automatically loaded)
```bash
terraform plan
# Uses: environment = "demo" (from terraform.tfvars)
```
![Example 2](https://github.com/sirsha/30DaysOfTerraform/blob/main/day5/sc3.png)

### 3. **Command Line Override** (highest precedence)
```bash
terraform plan -var="environment=production"
# Overrides tfvars: environment = "production"
```
![Example 3](https://github.com/sirsha/30DaysOfTerraform/blob/main/day5/sc4.png)
### 4. **Environment Variables**
```bash
export TF_VAR_environment="staging-from-env"
terraform plan
# Uses environment variable (but command line still wins)
```

### 5. **Using Different tfvars Files**
```bash
terraform plan -var-file="dev.tfvars"        # environment = "development"
terraform plan -var-file="production.tfvars"  # environment = "production"
```

# 🚀 Key Takeaways

- **Input Variables** allow Terraform configurations to accept external values.
- **Local Variables** simplify complex expressions and reduce repetition.
- **Output Variables** expose important infrastructure details after deployment.

Together they make Terraform configurations **clean, modular, and reusable**.

---

# Next Steps

Possible improvements for this project:

- Add **S3 bucket versioning**
- Enable **server-side encryption**
- Configure **remote Terraform state**
- Create **Terraform modules**
- Integrate with **CI/CD pipelines**

---

# Author

**Sirsha Thapa**

DevOps Engineer | Cloud | Kubernetes | Terraform | AWS | Azure
