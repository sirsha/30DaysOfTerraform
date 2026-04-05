# =============================================================================
# Day 08: Meta-Arguments in Terraform (count and for_each)
# =============================================================================
# This file demonstrates the use of meta-arguments:
# 1. count - Creates multiple instances using index-based iteration
# 2. for_each - Creates multiple instances using map/set iteration
# =============================================================================

# -----------------------------------------------------------------------------
# Example 1: Using COUNT meta-argument with S3 buckets
# -----------------------------------------------------------------------------
# count is useful when you want to create multiple identical resources
# Access individual instances using count.index


resource "aws_s3_bucket" "bucket1" {
  count = length(var.bucket_names) // Number of buckets to create based on the length of the list
  bucket = var.bucket_names[count.index]

  tags = {
  Name   = var.bucket_names[count.index]
  Environment = var.environment
  Index       = count.index
  ManagedBy   = "sirsha"
  BucketType  = "count-example"
  }
  
}

# -----------------------------------------------------------------------------
# Example 2: Using FOR_EACH meta-argument with S3 buckets
# -----------------------------------------------------------------------------
# for_each is useful when you want to create resources from a map or set
# Access individual instances using each.key and each.value
# Note: for_each requires a map or set, not a list


resource "aws_s3_bucket" "bucket_set" {
  for_each = var.s3_bucket_set
  bucket   = each.value //   bucket = each.key

  tags = {
    Environment = var.environment
    Name        = each.value // Name = each.value
    ManagedBy   = "sirsha"
    BucketType  = "foreach-example"
  }
}

# -----------------------------------------------------------------------------
# Example 3: DEPENDS_ON meta-argument
# -----------------------------------------------------------------------------
# depends_on is used to explicitly specify dependencies between resources
# Terraform automatically handles most dependencies, but sometimes you need explicit control

# First, create a bucket that will be used as a dependency
resource "aws_s3_bucket" "primary" {
  bucket = "tf-day08-primary-${var.environment}-20251017"

  tags = {
    Name        = "Primary Bucket"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# This bucket explicitly depends on the primary bucket
resource "aws_s3_bucket" "dependent" {
  bucket = "tf-day08-dependent-${var.environment}-20251017"

  # Explicit dependency - this will be created AFTER primary bucket
  #depends_on = [aws_s3_bucket.primary]

  tags = {
    Name        = "Dependent Bucket"
    Environment = var.environment
    DependsOn   = "primary-bucket"
    ManagedBy   = "terraform"
  }
}
