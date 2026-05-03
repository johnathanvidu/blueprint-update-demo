output "cluster_name" {
  description = "EKS cluster name"
  value       = local.cluster_full_name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = local.cluster_arn
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = local.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "Base64-encoded cluster CA certificate"
  value       = local.cluster_ca_data
}

output "oidc_issuer" {
  description = "OIDC provider URL for IRSA"
  value       = local.oidc_issuer
}

output "cluster_security_group_id" {
  description = "Security group ID for the EKS cluster"
  value       = local.security_group_id
}

output "node_group_name" {
  description = "Name of the default node group"
  value       = local.node_group_name
}

output "node_role_arn" {
  description = "IAM role ARN for worker nodes"
  value       = local.node_role_arn
}

output "cluster_version" {
  description = "Kubernetes version"
  value       = var.cluster_version
}
