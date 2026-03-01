# 📦 Day 3 — S3 Bucket & AWS Authentication

Today’s focus was on understanding how Terraform authenticates with AWS and how to provision an S3 bucket.

Infrastructure creation starts with **secure authentication**, and then moves into resource provisioning.

---

## 🎯 Topics Covered

- Authentication & Authorization to AWS
- AWS CLI setup
- Terraform AWS provider configuration
- S3 bucket provisioning
- Terraform workflow commands

---

# 🔐 AWS Authentication

Before creating any resources, Terraform must authenticate with AWS APIs.

Terraform does NOT store credentials itself — it relies on AWS credential sources.

---

## 🛠 Authentication Methods

### 1️⃣ AWS CLI Configuration (Recommended)

```bash
aws configure
```

You’ll be prompted to enter:

- AWS Access Key ID  
- AWS Secret Access Key  
- Default region (e.g., `us-east-1`)  
- Default output format (`json`)  

Credentials are stored in:

```
~/.aws/credentials
```

---

### 2️⃣ Environment Variables

Linux/macOS:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

Windows PowerShell:

```powershell
$env:AWS_ACCESS_KEY_ID="your-access-key"
$env:AWS_SECRET_ACCESS_KEY="your-secret-key"
$env:AWS_DEFAULT_REGION="us-east-1"
```

---

### 3️⃣ IAM Roles (Best Practice in Production)

Used when running Terraform from:
- EC2
- ECS
- EKS
- CI/CD systems

No hardcoded credentials required.

---

# ☁️ AWS CLI Installation

Official site:  
https://aws.amazon.com/cli/

---

## 🪟 Windows

Using MSI installer (recommended):  
Download from:  
https://awscli.amazonaws.com/AWSCLIV2.msi

Using winget:

```bash
winget install Amazon.AWSCLI
```

Using Chocolatey:

```bash
choco install awscli
```

---

## 🍎 macOS

Using Homebrew:

```bash
brew install awscli
```

Or official installer:

```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

---

## 🐧 Ubuntu / Debian

```bash
sudo apt update
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

Verify installation:

```bash
aws --version
```

---

# 🪣 S3 (Simple Storage Service)

Amazon S3 is an object storage service designed for:

- Scalability
- High availability
- Durability
- Security
- Performance

S3 bucket names must be globally unique.

---

# 🛠 Terraform Tasks

## 1️⃣ Explore Documentation

Terraform AWS Provider:  
https://registry.terraform.io/providers/hashicorp/aws/latest

S3 Resource Docs:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

---

## 2️⃣ Create S3 Bucket WS VPC and an S3 bucket Using Terraform, ensuring the bucket has an implicit dependency on the VPC

Example:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    
  }
  required_version = ">= 1.3.0"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-demo-vpc"
  }
}
resource "aws_s3_bucket" "demo" {
  bucket = "sirsha-terraform-vpc-demo-123456"  # Must be globally unique

  # 🔹 Implicit dependency created here
  # Because we reference aws_vpc.main.id
  tags = {
    Name   = "terraform-demo-bucket"
    VpcId  = aws_vpc.example.id
    VpcCIDR = aws_vpc.example.cidr_block
  }

}
```
👉 Implicit Dependencies

In Terraform, you don’t always need depends_on.

If one resource references another, Terraform automatically understands the dependency.

For example:

Create a VPC

Create an S3 bucket

Reference the VPC ID inside the S3 bucket tags

That simple reference makes Terraform:

VPC → created first
S3 bucket → created after

No manual dependency declaration required.
---

# 🚀 Terraform Workflow Commands

```bash
terraform init        # Initialize working directory
terraform validate    # Validate configuration
terraform plan        # Preview changes
terraform apply       # Apply changes
terraform show        # Show state
terraform destroy     # Destroy resources
```

---

# ⚠ Important Notes

- ✅ S3 bucket names must be globally unique
- ✅ Always verify your AWS region
- ✅ Monitor AWS Free Tier usage
- ✅ Destroy resources after practice

---

# 🧠 Troubleshooting Tips

- Check AWS credentials using:

```bash
aws sts get-caller-identity
```

- Ensure region matches your configuration
- Verify S3 bucket naming rules
- Review AWS CloudTrail logs for API calls

---

# 📌 Key Learnings

- Terraform requires valid AWS credentials
- AWS CLI configuration is the easiest setup method
- Providers rely on authentication chain
- S3 bucket naming is globally enforced
- Terraform workflow remains consistent across resources

---

## 🔥 Reflection

Day 3 reinforced that infrastructure provisioning is not just about writing Terraform code, it starts with proper authentication and secure configuration.

Understanding credential flow and authentication methods makes Terraform safer and more production-ready.

---

#30DaysOfTerraform #Terraform #AWS #S3 #InfrastructureAsCode #DevOps
