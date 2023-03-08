variable "resource_group_name" {
  type        = string
  description = "Resource group the connection should be placed in"
}

variable "connection_name" {
  type        = string
  description = "Name of the connection"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the connected storage account"
}

variable "storage_account_access_key" {
  type        = string
  description = "Access Key for the storage account"
}
