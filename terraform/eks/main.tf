terraform {
  required_version = ">= 1.3.0"
}

locals {
  cluster_full_name  = "${var.cluster_name}-${var.environment}"
  cluster_arn        = "arn:aws:eks:us-east-1:123456789012:cluster/${local.cluster_full_name}"
  cluster_endpoint   = "https://${substr(sha256(local.cluster_full_name), 0, 32)}.gr7.us-east-1.eks.amazonaws.com"
  cluster_ca_data    = base64encode("mock-certificate-authority-data-${local.cluster_full_name}")
  oidc_issuer        = "https://oidc.eks.us-east-1.amazonaws.com/id/${upper(substr(sha256(local.cluster_full_name), 0, 32))}"
  security_group_id  = "sg-eks-${substr(sha256(local.cluster_full_name), 0, 8)}"
  node_role_arn      = "arn:aws:iam::123456789012:role/${local.cluster_full_name}-node-role"
  cluster_role_arn   = "arn:aws:iam::123456789012:role/${local.cluster_full_name}-cluster-role"

  node_group_name = "${local.cluster_full_name}-default-ng"
  node_ids = [
    for i in range(var.desired_capacity) :
    "i-node-${substr(sha256("${local.cluster_full_name}-${i}"), 0, 12)}"
  ]
}

resource "terraform_data" "eks_cluster_role" {
  input = {
    role_arn  = local.cluster_role_arn
    role_name = "${local.cluster_full_name}-cluster-role"
  }
}

resource "terraform_data" "eks_node_role" {
  input = {
    role_arn  = local.node_role_arn
    role_name = "${local.cluster_full_name}-node-role"
  }
}

resource "terraform_data" "eks_security_group" {
  input = {
    security_group_id = local.security_group_id
    vpc_id            = var.vpc_id
  }
}

resource "terraform_data" "eks_cluster" {
  input = {
    cluster_name    = local.cluster_full_name
    cluster_arn     = local.cluster_arn
    cluster_version = var.cluster_version
    endpoint        = local.cluster_endpoint
    ca_data         = local.cluster_ca_data
    oidc_issuer     = local.oidc_issuer
    vpc_id          = var.vpc_id
    subnet_ids      = var.private_subnet_ids
  }
}

resource "terraform_data" "eks_node_group" {
  input = {
    node_group_name = local.node_group_name
    cluster_name    = local.cluster_full_name
    instance_type   = var.node_instance_type
    desired_size    = var.desired_capacity
    min_size        = var.min_size
    max_size        = var.max_size
    subnet_ids      = var.private_subnet_ids
    node_ids        = local.node_ids
  }
}
