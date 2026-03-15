# 📘 Day 7 – Type Constraints in Terraform

Part of my **30 Days of AWS with Terraform** learning journey.

On **Day 7**, I explored the different **data types Terraform supports**, how they work, and why defining them properly is essential for writing **stable Infrastructure as Code (IaC)**.

Type constraints help Terraform:
- Validate inputs
- Prevent configuration errors
- Make modules reusable
- Maintain predictable infrastructure

---

# 📚 Topics Covered

- Basic Types (`string`, `number`, `bool`)
- Collection Types (`list`, `set`, `map`)
- Structural Types (`tuple`, `object`)
- Type validation and constraints
- Complex type definitions
- Terraform variable best practices

---

# 1️⃣ Basic Types in Terraform

Terraform supports **three primitive data types**.

## 🔹 String

Represents text values.

```hcl
variable "env" {
  description = "Environment name"
  type        = string
}
```

Example values:

```
"dev"
"staging"
"production"
```
![Example 1](https://github.com/sirsha/30DaysOfTerraform/blob/main/day7/1.png)
---

## 🔹 Number

Supports integers and floating-point numbers.

```hcl
variable "instance_count" {
  description = "Number of instances"
  type        = number
}
```

Example values:

```
1
2
5
```
![Example 1](https://github.com/sirsha/30DaysOfTerraform/blob/main/day7/2.png)
---

## 🔹 Boolean

Represents **true or false**.

```hcl
variable "enable_versioning" {
  description = "Enable S3 versioning"
  type        = bool
}
```

Example:

```
true
false
```

Basic types are simple, but real-world infrastructure requires **structured data**, which brings us to collection types.
![Example 1](https://github.com/sirsha/30DaysOfTerraform/blob/main/day7/3.png)
---

# 2️⃣ Collection Types

Collection types store **multiple values of the same type**.

---

## 🔹 List

An **ordered collection** of values.

```hcl
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
```

Example:

```
["us-east-1a", "us-east-1b", "us-east-1c"]
```

Common uses:
- Availability zones
- Subnets
- Instance IDs
  
![Example 1](https://github.com/sirsha/30DaysOfTerraform/blob/main/day7/44.png)
---

## 🔹 Set

An **unordered collection of unique values**.

```hcl
variable "security_groups" {
  type = set(string)
}
```

Example:

```
["sg-123", "sg-456", "sg-789"]
```

Best when **duplicates should not exist**.

![Example 1](https://github.com/sirsha/30DaysOfTerraform/blob/main/day7/5.png)
---

## 🔹 Map

A **key-value pair structure**.

```hcl
variable "tags" {
  description = "Tags for AWS resources"
  type        = map(string)
}
```

Example:

```
{
  Environment = "dev"
  Project     = "terraform-demo"
  Owner       = "devops-team"
}
```

Maps are widely used for **AWS tagging strategies**.

![Example 1](https://github.com/sirsha/30DaysOfTerraform/blob/main/day7/map.png)
---

# 3️⃣ Structural Types

Structural types allow modeling **complex structured data**.

---

## 🔹 Tuple

An ordered structure with predefined element types.

```hcl
variable "config_values" {
  type = tuple([string, number, bool])
}
```

Example:

```
["t3.micro", 2, true]
```

Each element must match the defined type.

![Example 1](https://github.com/sirsha/30DaysOfTerraform/blob/main/day7/7.png)
---

## 🔹 Object

Objects define **named attributes with specific types**.

```hcl
variable "instance_details" {
  type = object({
    name     = string
    cpu      = number
    required = bool
  })
}
```

Example:

```
{
  name     = "web-server"
  cpu      = 2
  required = true
}
```

Objects are commonly used in **Terraform modules and structured configurations**.

![Example 1](https://github.com/sirsha/30DaysOfTerraform/blob/main/day7/9.png)
---

# 4️⃣ Type Validation and Constraints

Terraform allows enforcing **rules using validation blocks**.

Example:

```hcl
variable "instance_count" {
  type = number

  validation {
    condition     = var.instance_count > 0
    error_message = "Instance count must be greater than zero."
  }
}
```

If an invalid value is provided:

```
instance_count = 0
```

Terraform will return an error:

```
Instance count must be greater than zero.
```

This prevents **invalid infrastructure configurations**.

---

# 5️⃣ Complex Type Definitions

Complex types are useful for **real-world infrastructure use cases**.

---

## Environment Configuration

```hcl
variable "env_config" {
  type = object({
    cpu    = number
    memory = number
    tier   = string
  })
}
```

Example input:

```
env_config = {
  cpu    = 2
  memory = 4
  tier   = "backend"
}
```

---

## Tag Standardization

```hcl
variable "tags" {
  type = map(string)
}
```

Ensures consistent tagging across all resources.

---

## Network Configuration Validation

```hcl
variable "vpc_cidr" {
  type = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Invalid CIDR block provided."
  }
}
```

---

## Security Policy Example

```hcl
variable "security_policy" {
  type = object({
    encryption = bool
    logging    = bool
  })
}
```

This ensures mandatory fields exist.

---

# ⭐ Best Practices for Terraform Types

When defining Terraform variables:

- Always specify **types**
- Use **validation blocks**
- Provide **clear error messages**
- Choose correct collection types (`list`, `set`, `map`)
- Validate complex objects thoroughly
- Use type conversion functions when needed

Examples:

```
tostring()
tonumber()
tobool()
```

Also document variables clearly.

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
```

---

# 🎯 Key Learning Points

### Basic Types
- `string`
- `number`
- `bool`

### Collection Types
- `list(type)`
- `set(type)`
- `map(type)`

### Structural Types
- `tuple()`
- `object()`

---

# 🏁 Conclusion

Understanding **Terraform type constraints** is essential for writing **safe, scalable, and reusable Infrastructure as Code**.

Clear type definitions help:

- Catch configuration errors early
- Improve module reusability
- Enforce consistent infrastructure
- Maintain predictable deployments

As I continue building **AWS infrastructure with Terraform**, these fundamentals will become even more important for creating **production-ready IaC**.

---

# 🚀 Series

**30 Days of AWS with Terraform**

📅 Day 7 – Type Constraints in Terraform
