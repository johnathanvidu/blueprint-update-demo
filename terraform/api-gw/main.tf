terraform {
  required_version = ">= 1.3.0"
}

locals {
  api_full_name  = "${var.api_name}-${var.environment}"
  api_id         = "api-${substr(sha256(local.api_full_name), 0, 10)}"
  api_arn        = "arn:aws:apigateway:us-east-1::/restapis/${local.api_id}"
  execution_arn  = "arn:aws:execute-api:us-east-1:123456789012:${local.api_id}"
  invoke_url     = "https://${local.api_id}.execute-api.us-east-1.amazonaws.com/${var.stage_name}"
  vpc_link_id    = "vpclink-${substr(sha256(local.api_full_name), 0, 8)}"

  resource_ids = {
    for name, ep in var.endpoints :
    name => "res-${substr(sha256("${local.api_id}-${ep.path}"), 0, 8)}"
  }
}

resource "terraform_data" "api_gateway" {
  input = {
    api_id      = local.api_id
    api_name    = local.api_full_name
    description = var.api_description
    api_arn     = local.api_arn
  }
}

resource "terraform_data" "vpc_link" {
  input = {
    vpc_link_id  = local.vpc_link_id
    name         = "${local.api_full_name}-vpc-link"
    target_arns  = var.vpc_link_target_arns
  }
}

resource "terraform_data" "api_resources" {
  for_each = var.endpoints

  input = {
    resource_id = local.resource_ids[each.key]
    path        = each.value.path
    method      = each.value.method
    type        = each.value.type
    api_id      = local.api_id
  }
}

resource "terraform_data" "api_deployment" {
  input = {
    api_id     = local.api_id
    stage_name = var.stage_name
    invoke_url = local.invoke_url
  }

  depends_on = [terraform_data.api_resources]
}

resource "terraform_data" "cors_config" {
  count = var.enable_cors ? 1 : 0

  input = {
    api_id         = local.api_id
    allowed_origins = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allowed_headers = ["Content-Type", "Authorization"]
  }
}
