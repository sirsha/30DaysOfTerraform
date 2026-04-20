output "sg-rules" {
  description = "List of security group rules created from allowed ports"
  value       = local.sg_rules
}
output "instance_size" {
  description = "EC2 instance size based on environment"
  value       = local.instance_size
}
# ==============================================================================
# ASSIGNMENT 7 OUTPUTS: Backup Configuration
# ==============================================================================
# Uncomment when testing Assignment 7

output "backup_name" {
  description = "Backup configuration name (validated)"
  value       = var.backup_name
}

output "backup_credential" {
  description = "Backup credential (sensitive)"
  value       = var.credential
  sensitive   = true
}

output "backup_config" {
  description = "Complete backup configuration"
  value       = local.backup_config
  sensitive   = true
}
output "location" {
  description = "Unique list of AWS regions"
  value       = local.unique_locations
}
output "all_locations" {
  description = "Unique list of AWS regions from user input and current region"
  value       = local.all_locations
  
}
output "positive_costs" {
  description = "Monthly costs converted to positive values"
  value       = local.positive_costs
}
output "max_cost" {
  description = "Maximum monthly cost"
  value       = local.max_cost
}
output "total_cost" {
  description = "Total monthly cost"
  value       = local.total_cost
}
output "average_cost" {
  description = "Average monthly cost"
  value       = local.total_cost / length(var.monthly_costs)
}
output "config_data"{
    description = "Configuration data from JSON file"
    value       = local.config_data
}
