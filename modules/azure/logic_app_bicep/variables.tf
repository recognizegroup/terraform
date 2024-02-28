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

variable "arm_parameters" {
  type        = any
  description = "Parameter values for the ARM template."
  default     = {}
}

variable "templates_files" {
  type = object({
    bicep_path        = optional(string),
    arm_template_path = optional(string)
  })

  default = {
    bicep_path        = null
    arm_template_path = null
  }

  validation {
    condition     = ((var.templates_files.bicep_path == null && var.templates_files.arm_template_path != null) || (var.templates_files.bicep_path != null && var.templates_files.arm_template_path == null))
    error_message = "One of these (bicep_path, arm_template_path) needs to be set "
  }
}

# it is neccessary for the creation of workflow.json localy using bicep
variable "module_dir" {
  type        = string
  description = "Module direcory"
  default     = "."
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
  default     = ["0.0.0.0/0"]
}
