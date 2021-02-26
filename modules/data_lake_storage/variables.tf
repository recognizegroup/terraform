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

variable "datalake_storage_account_kind" {
  type        = string
  description = "Defines the kind to use for this storage account."
  default     = "StorageV2"
}

variable "datalake_storage_account_tier" {
  type        = string
  description = "Defines the tier to use for this storage account."
  default     = "Standard"
}

variable "datalake_storage_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account."
  default     = "GRS"
}

variable "datalake_storage_filesystem_name" {
  type        = string
  description = "Name of the filesystem."
}

variable "datalake_storage_folders" {
  type        = map
  description = "Map of folders and ACLs for datalake storage filesystem."
}

variable "root_permissions" {
  type        = list
  description = "List of permissions on the root filesystem."
}
