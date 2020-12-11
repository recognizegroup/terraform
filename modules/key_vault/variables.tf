variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "key_vault_name" {
  type        = string
  description = "Name of the key vault."
}

variable "soft_delete_enabled" {
  type        = string
  description = "Enables soft delete for key vault."
}

variable "soft_delete_retention_days" {
  type        = string
  description = "The numer of days items should be retained after soft delete."
}

variable "purge_protection_enabled" {
  type        = string
  description = "Enables purge protection for key vault."
}

variable "key_vault_sku" {
  type        = string
  description = "Name of the sku used for the key vault."
  default     = "standard"
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Flag to specify whether to use Role Based Access Control."
  default     = true
}
