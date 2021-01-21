variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "action_group_name" {
  type        = string
  description = "Name of the action group"
}

variable "action_group_short_name" {
  type        = string
  description = "Name of the action group"
}

variable "action_group_email_receiver" {
  type        = string
  description = "The emailaddress where the alert should be sent to"
}

variable "metric_alerts" {
  type = map(object({
    description                 = string
    scopes                      = list(string)
    frequency                   = string
    window_size                 = string
    criteria_metric_namespace   = string
    criteria_metric_name        = string
    criteria_metric_aggregation = string
    criteria_metric_operator    = string
    criteria_threshold          = string
  }))
  description = "List of metric alerts"
}
