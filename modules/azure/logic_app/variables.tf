variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "logic_app_name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workspace."
}

variable "arm_template_path" {
  type        = string
  description = "Specifies the path of ARM template to be used during deployment."
  default     = null
}

variable "arm_parameters" {
  type        = any
  description = "Parameter values for the ARM template."
  default     = {}
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Specifies the ID of a Log Analytics Workspace where diagnostics data should be sent."
  default     = null
}

variable "log_retention_days" {
  type        = number
  description = "Number of days for which logs and metrics will be saved."
  default     = 30
}

variable "enabled" {
  type        = bool
  description = "If this workflow should be enabled by default or not, defaults to true"
  default     = true
}

variable "use_managed_identity" {
  type        = bool
  description = "Use Managed Identity for this logic app"
  default     = false
}

variable "trigger_oauth_policy_claims" {
  type        = map(string)
  description = "Claims validated by OAuth policy in HTTP trigger"
  default     = {}
}

variable "trigger_ip_address_range" {
  type        = set(string)
  description = "IP address range allowed to call HTTP trigger"
  default     = [ "0.0.0.0/0" ]
}
