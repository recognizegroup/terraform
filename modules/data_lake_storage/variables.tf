variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "datalake_storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "datalake_storage_account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account."
  default     = "Standard"
}

variable "datalake_storage_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account."
  default     = "GRS"
}

variable "datalake_storage_container_name" {
  type        = string
  description = "Name of the storage container."
}
