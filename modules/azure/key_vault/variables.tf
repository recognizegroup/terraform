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
  description = "Name of the key vault."
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The numer of days items should be retained after soft delete."
  default     = 7
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Enables purge protection for key vault. Cannot be undone!"
  default     = false
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  default     = true
}

variable "sku" {
  type        = string
  description = "Name of the sku used for the key vault."
  default     = "standard"
}

variable "enable_rbac" {
  type        = bool
  description = "Flag to specify whether to use Role Based Access Control."
  default     = false
}

variable "secret_readers" {
  type        = list(string)
  description = "List of object IDs to grant secret reader permissions when RBAC is disabled."
  default     = []
}

variable "secret_administrators" {
  type        = list(string)
  description = "List of object IDs to grant secret administrator permissions when RBAC is disabled."
  default     = []
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}

variable "add_current_principal_as_administrator" {
  type        = bool
  description = "Flag to specify whether to add the current principal as administrator."
  default     = true # This default behavior is to maintain backwards compatibility.
}