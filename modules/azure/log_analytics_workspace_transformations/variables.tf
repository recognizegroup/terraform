variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "name" {
  type        = string
  description = "Specifies the name of the workspace transformation Data Collection Rule."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource id of the Log Analytics Workspace. The rule becomes its default (workspace transformation) Data Collection Rule. A workspace can have only one."
}

variable "transformations" {
  type        = map(string)
  description = "Ingestion-time transformation per table, keyed by table name (for example FunctionAppLogs) with the KQL starting with source as value. Only tables that support transformations can be used, and the transformation applies to all data sent to that table that does not come from another Data Collection Rule, such as diagnostic settings and Application Insights."
}

variable "destination_name" {
  type        = string
  description = "Name used to reference the Log Analytics destination inside the rule."
  default     = "logAnalytics"
}

variable "description" {
  type        = string
  description = "Specifies a description for the Data Collection Rule."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = null
}
