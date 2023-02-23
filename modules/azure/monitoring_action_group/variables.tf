variable "name" {
  type        = string
  description = "Name of the action group."

  validation {
    condition     = can(regex("^ag", var.name))
    error_message = "The name of this resource must start with 'ag'. For a list of common Azure abbreviations see https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "short_name" {
  type        = string
  description = "Short name of the action group. Can only be 12 characters long."

  validation {
    condition     = can(regex("^ag", var.short_name))
    error_message = "The name of this resource must start with 'ag'. For a list of common Azure abbreviations see https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations."
  }
}

variable "enabled" {
  type        = string
  description = "Indicates whether the action group is enabled."
  default     = true
}

variable "email_receivers" {
  type        = set(string)
  description = "The email addresses where the alert should be sent to."
  default     = []
}

variable "webhook_uris" {
  type        = set(string)
  description = "The webhook addresses where the alert should be sent to."
  default     = []
}

variable "use_common_alert_schema" {
  type        = bool
  description = "Enables or disables the action group common alert schema."
  default     = true
}
