
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "name" {
  type        = string
  description = "Specifies the name of the Front Door service."

  validation {
    condition     = can(regex("^fd", var.name))
    error_message = "The name of this resource must start with 'fd'. For a list of common Azure abbreviations see https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations."
  }
}

variable "custom_domains" {
  type = list(object({
    name      = string
    host_name = string
  }))
  description = "List of custom domains for frontdoor."
}
variable "redirect_routes" {
  type = list(object({
    name                = string
    custom_domain_name  = string
    origin_group_name   = string
    enabled             = optional(bool)
    supported_protocols = list(string)
    patterns_to_match   = list(string)
  }))
  description = "A list of redirect routes for frontdoor."

  validation {
    condition     = length(var.redirect_routes) > 0
    error_message = "The list with redirect routes should at least contain one object."
  }
}

variable "forwarding_routes" {
  type = list(object({
    name                = string
    custom_domain_name  = string
    origin_group_name   = string
    enabled             = optional(bool)
    supported_protocols = list(string)
    patterns_to_match   = list(string)
  }))
  description = "A list of forwarding routes for frontdoor."

  validation {
    condition     = length(var.forwarding_routes) > 0
    error_message = "The list with forwarding routes should at least contain one object."
  }
}

variable "origin_groups" {
  type = list(object({
    name         = string
    health_probe = optional(object({
      protocol            = string
      interval_in_seconds = number
      path                = optional(string)
      request_type        = optional(string)
    }))
    origins = list(object({
      host_name          = string
      origin_host_header = optional(string)
      http_port          = optional(number)
      https_port         = optional(number)
      enabled            = optional(bool)
      priority           = optional(number)
      weight             = optional(number)
    }))
  }))
  description = "A list of origin groups for frontdoor."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}
