terraform {
  required_version = ">= 1.3.0"
}

locals {
  vpc_id = "vpc-mock-${var.environment}-${substr(sha256(var.vpc_cidr), 0, 8)}"

  private_subnet_ids = [
    for i, cidr in var.private_subnet_cidrs :
    "subnet-priv-${substr(sha256(cidr), 0, 8)}"
  ]

  public_subnet_ids = [
    for i, cidr in var.public_subnet_cidrs :
    "subnet-pub-${substr(sha256(cidr), 0, 8)}"
  ]

  nat_gateway_ip = "203.0.113.1"
  igw_id         = "igw-mock-${substr(sha256(local.vpc_id), 0, 8)}"
}

resource "terraform_data" "vpc" {
  input = {
    vpc_id     = local.vpc_id
    cidr_block = var.vpc_cidr
    environment = var.environment
  }
}

resource "terraform_data" "private_subnets" {
  for_each = { for i, cidr in var.private_subnet_cidrs : var.availability_zones[i] => cidr }

  input = {
    subnet_id         = local.private_subnet_ids[index(var.availability_zones, each.key)]
    cidr_block        = each.value
    availability_zone = each.key
    vpc_id            = local.vpc_id
  }
}

resource "terraform_data" "public_subnets" {
  for_each = { for i, cidr in var.public_subnet_cidrs : var.availability_zones[i] => cidr }

  input = {
    subnet_id         = local.public_subnet_ids[index(var.availability_zones, each.key)]
    cidr_block        = each.value
    availability_zone = each.key
    vpc_id            = local.vpc_id
  }
}
