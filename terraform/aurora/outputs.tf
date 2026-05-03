output "cluster_id" {
  description = "Aurora cluster identifier"
  value       = local.cluster_id
}

output "cluster_endpoint" {
  description = "Writer endpoint for the Aurora cluster"
  value       = local.cluster_endpoint
}

output "reader_endpoint" {
  description = "Reader endpoint for the Aurora cluster"
  value       = local.reader_endpoint
}

output "port" {
  description = "Database port"
  value       = local.port
}

output "database_name" {
  description = "Name of the default database"
  value       = var.database_name
}

output "master_username" {
  description = "Master username"
  value       = var.master_username
}

output "security_group_id" {
  description = "Security group ID for Aurora"
  value       = local.security_group_id
}

output "instance_ids" {
  description = "List of Aurora instance identifiers"
  value       = local.instance_ids
}
