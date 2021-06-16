variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "storage_account_kind" {
  type        = string
  description = "Defines the kind to use for this storage account."
  default     = "StorageV2"
}

variable "storage_account_tier" {
  type        = string
  description = "Defines the tier to use for this storage account."
  default     = "Standard"
}

variable "storage_account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account."
  default     = "LRS"
}

variable "container_names" {
  type        = set(string)
  description = "Optionally add predefined container names in this storage."
  default     = []
}
