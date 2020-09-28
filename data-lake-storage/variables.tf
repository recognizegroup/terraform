variable "location" {
  type        = string
  description = "A datacenter location in Azure"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "client_id" {
  type        = string
  description = "Azure client ID"
}

variable "client_secret" {
  type        = string
  description = "Azure client secret"
}

variable "skip_provider_registration" {
  type        = string
  description = "Indicates whether the provider should be registered in Azure"
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a resource group"
}

variable "datalake_storage_account_name" {
  type        = string
  description = "A datacenter location in Azure"
}

variable "datalake_storage_account_tier" {
  type        = string
  description = "A datacenter location in Azure"
  default     = "Standard"
}

variable "datalake_storage_replication_type" {
  type        = string
  description = "A datacenter location in Azure"
  default     = "GRS"
}

variable "datalake_storage_container_name" {
  type        = string
  description = "Name of the datalake storage container"
}
