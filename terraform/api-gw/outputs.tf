output "api_id" {
  description = "API Gateway REST API ID"
  value       = local.api_id
}

output "api_arn" {
  description = "API Gateway ARN"
  value       = local.api_arn
}

output "execution_arn" {
  description = "Execution ARN for the API"
  value       = local.execution_arn
}

output "invoke_url" {
  description = "URL to invoke the API"
  value       = local.invoke_url
}

output "stage_name" {
  description = "Deployment stage name"
  value       = var.stage_name
}

output "vpc_link_id" {
  description = "VPC Link ID"
  value       = local.vpc_link_id
}

output "resource_ids" {
  description = "Map of endpoint names to resource IDs"
  value       = local.resource_ids
}
