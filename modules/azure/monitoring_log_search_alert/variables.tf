variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "action_group_ids" {
  type        = list(string)
  description = "IDs of the action groups that are triggered when an alert fires."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the alert rules."
  default     = {}
}

variable "monitoring_rules" {
  type = list(object({
    name                    = string
    description             = string
    enabled                 = optional(bool, true)
    scope                   = string
    query                   = string
    evaluation_frequency    = optional(string, "PT30M")
    window_duration         = optional(string, "PT30M")
    operator                = optional(string, "GreaterThanOrEqual")
    threshold               = optional(number, 1)
    severity                = optional(number, 3)
    auto_mitigation_enabled = optional(bool, true)
    skip_query_validation   = optional(bool, false)
    dimensions              = optional(list(string), [])
  }))
  description = "Log search alert rules. Each rule gets a system-assigned managed identity, which is required for queries that use arg() or adx(). The scope is the resource the query runs against, usually a Log Analytics workspace. For details see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert_v2"
  default     = []
}
