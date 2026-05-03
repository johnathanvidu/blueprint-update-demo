terraform {
  required_version = ">= 1.3.0"
}

locals {
  cluster_id         = "aurora-${var.environment}-${substr(sha256(var.database_name), 0, 8)}"
  cluster_endpoint   = "${local.cluster_id}.cluster-mock123456.us-east-1.rds.amazonaws.com"
  reader_endpoint    = "${local.cluster_id}.cluster-ro-mock123456.us-east-1.rds.amazonaws.com"
  port               = 5432
  master_password    = "mock-password-not-real"
  security_group_id  = "sg-aurora-${substr(sha256(local.cluster_id), 0, 8)}"
  subnet_group_name  = "dbsubnet-${var.environment}"

  instance_ids = [
    for i in range(var.instance_count) :
    "${local.cluster_id}-instance-${i}"
  ]
}

resource "terraform_data" "aurora_subnet_group" {
  input = {
    name       = local.subnet_group_name
    subnet_ids = var.private_subnet_ids
  }
}

resource "terraform_data" "aurora_security_group" {
  input = {
    security_group_id = local.security_group_id
    vpc_id            = var.vpc_id
    ingress_port      = local.port
  }
}

resource "terraform_data" "aurora_cluster" {
  input = {
    cluster_id      = local.cluster_id
    engine          = var.engine
    engine_version  = var.engine_version
    database_name   = var.database_name
    master_username = var.master_username
    endpoint        = local.cluster_endpoint
    reader_endpoint = local.reader_endpoint
    port            = local.port
  }
}

resource "terraform_data" "aurora_instances" {
  for_each = toset(local.instance_ids)

  input = {
    instance_id    = each.key
    cluster_id     = local.cluster_id
    instance_class = var.instance_class
    engine         = var.engine
    engine_version = var.engine_version
  }
}
