variable "name" {
  type        = string
  description = "The name of the WAF policy."

  validation {
    condition     = can(regex("^waf", var.name))
    error_message = "The name of this resource must start with 'waf'. For a list of common Azure abbreviations see https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "enabled" {
  type        = bool
  description = "Is the WAF policy in a enabled state or disabled state."
  default     = true
}

variable "mode" {
  type        = string
  description = "The firewall policy mode. Possible values are Detection, Prevention."
  default     = "Prevention"
}

variable "redirect_url" {
  type        = string
  description = "If action type is redirect, this field represents redirect URL for the client."
  default     = null
}

variable "custom_rules" {
  type = list(object({
    name     = string
    action   = string
    enabled  = optional(bool)
    priority = optional(number)
    type     = string
    match_conditions = list(object({
      match_variable     = string
      match_values       = list(string)
      operator           = string
      selector           = optional(string)
      negation_condition = optional(bool)
      transforms         = optional(list(string))
    }))
    rate_limit_duration_in_minutes = optional(number)
    rate_limit_threshold           = optional(number)
  }))
  description = "A list of custom rule objects. For details see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/frontdoor_firewall_policy#custom_rule"
  default     = []
}

variable "custom_block_response_status_code" {
  type        = number
  description = "If a custom_rule block's action type is block, this is the response status code."
  default     = null
}

variable "custom_block_response_body" {
  type        = string
  description = "If a custom_rule block's action type is block, this is the response body. Must be bas64 encoded."
  default     = null
}

variable "managed_rules" {
  type = list(object({
    type    = string
    version = string
    exclusion = optional(list(object({
      match_variable = string
      operator       = string
      selector       = string
    })))
    override = optional(list(object({
      rule_group_name = string
      exclusion = optional(list(object({
        match_variable = string
        operator       = string
        selector       = string
      })))
      rule = optional(list(object({
        rule_id = string
        action  = string
        enabled = optional(bool)
        exclusion = optional(list(object({
          match_variable = string
          operator       = string
          selector       = string
        })))
      })))
    })))
  }))
  description = "A list of managed rule objects. For details see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/frontdoor_firewall_policy#managed_rule"
  default     = []
}
