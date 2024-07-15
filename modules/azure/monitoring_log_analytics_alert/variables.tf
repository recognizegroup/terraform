variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "action_group_id" {
  type        = string
  description = "ID of the action group to associate the alert with."
  default     = null
}

variable "action_groups" {
  type        = list(string)
  description = "Action groups that must be triggered"
  default     = null
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
