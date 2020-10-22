variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "skip_provider_registration" {
  type        = bool
  description = "Indicates whether the provider should be registered in Azure."
  default     = false
}

variable "datafactory_name" {
  type        = string
  description = "The name of the datafactory."
}
