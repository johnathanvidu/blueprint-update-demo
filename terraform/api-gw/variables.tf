variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "app-api"
}

variable "api_description" {
  description = "Description of the API Gateway"
  type        = string
  default     = "Application REST API"
}

variable "stage_name" {
  description = "Deployment stage name"
  type        = string
  default     = "v1"
}

variable "vpc_link_target_arns" {
  description = "Target ARNs for VPC link (e.g., NLB ARNs)"
  type        = list(string)
  default     = ["arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/mock-nlb/abc123"]
}

variable "endpoints" {
  description = "Map of API endpoints to configure"
  type = map(object({
    method = string
    path   = string
    type   = string
  }))
  default = {
    get_items = {
      method = "GET"
      path   = "/items"
      type   = "HTTP_PROXY"
    }
    post_items = {
      method = "POST"
      path   = "/items"
      type   = "HTTP_PROXY"
    }
    get_item = {
      method = "GET"
      path   = "/items/{id}"
      type   = "HTTP_PROXY"
    }
  }
}

variable "enable_cors" {
  description = "Enable CORS on the API"
  type        = bool
  default     = true
}
