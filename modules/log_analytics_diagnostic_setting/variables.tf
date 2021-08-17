variable "target_resource_id" {
  type        = string
  description = "The ID of an existing Resource on which to configure Diagnostic Settings."
}

variable "name" {
  type        = string
  description = "Specifies the name of the Diagnostic Setting."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
}

variable "metric_category" {
  type        = string
  description = "The name of a Diagnostic Metric Category for this Resource."
  default     = "AllMetrics"
}
variable "metric_retention_policy_enabled" {
  type        = bool
  description = "Is this Diagnostic Metric enabled."
  default     = false
}
