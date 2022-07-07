variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "action_group_name" {
  type        = string
  description = "Name of the action group."

  validation {
    condition     = can(regex("^ag", var.action_group_name))
    error_message = "The name of this resource must start with 'ag'. For a list of common Azure abbreviations see https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations."
  }
}

variable "action_group_short_name" {
  type        = string
  description = "Short name of the action group. Can only be 12 characters long."

  validation {
    condition     = can(regex("^ag", var.action_group_short_name))
    error_message = "The name of this resource must start with 'ag'. For a list of common Azure abbreviations see https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations."
  }
}

variable "action_group_enabled" {
  type        = string
  description = "Indicates whether the action group is enabled."
  default     = true
}

variable "action_group_email_receiver" {
  type        = string
  description = "The email address where the alert should be sent to."
}

variable "action_group_use_common_alert_schema" {
  type        = bool
  description = "Enables or disables the action group common alert schema."
  default     = true
}

variable "monitoring_rules" {
  type = list(object({
    name                    = string
    description             = string
    enabled                 = optional(bool)
    data_source_id          = string
    frequency               = number
    query                   = string
    time_window             = number
    operator                = string
    threshold               = number
    auto_mitigation_enabled = optional(bool)
    severity                = optional(number)
  }))
  description = "A list of monitoring rule objects. For details see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert#argument-reference"
  default     = []
}
