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
  description = "Specifies the name of the function app."
}

variable "app_service_plan_id" {
  type        = string
  description = "The ID of the App Service Plan within which to create this Function App."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}

variable "storage_account_name" {
  type        = string
  description = "The backend storage account name which will be used by this Function App (such as the dashboard, logs)."
}

variable "storage_account_access_key" {
  type        = string
  description = " The access key which will be used to access the backend storage account for the Function App."
}

variable "app_settings" {
  type        = map(any)
  description = "The app settings of this app service."
  default     = {}
}

variable "runtime_version" {
  type        = string
  description = "The runtime version associated with the Function App."
  default     = "~3"
}

variable "always_on" {
  type        = bool
  description = "Should the Function App be loaded at all times?"
  default     = false
}

variable "connection_strings" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  description = "Connection strings for the function app."
  default     = []
}

variable "integration_subnet_id" {
  type        = string
  description = "Define the subnet in which the Function App runs."
  default     = null
}

variable "route_all_outbound_traffic" {
  type        = bool
  description = "Defines whether all outbound traffic of the Function App is routed."
  default     = false
}
