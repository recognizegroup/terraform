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
  description = "Name of the storage account."
}

variable "key_vault_name" {
  type        = string
  description = "Name of the key vault."
}

variable "sql_admin_user_secret_name" {
  type        = string
  description = "Name of the sql admin user stored secret."
}

variable "sql_admin_password_secret_name" {
  type        = string
  description = "Name of the sql admin password stored secret."
}

variable "sql_server_name" {
  type        = string
  description = "Name of the sql server."
}

variable "sql_server_version" {
  type        = string
  description = "Azure sql server version."
  default     = "12.0"
}

variable "sql_service_level" {
  type        = string
  description = "Azure sql server version."
  default     = "DW100c"
}

variable "sql_database_name" {
  type        = string
  description = "Name of the azure sql database."
}

variable "sql_edition" {
  type        = string
  description = "Edition of the sql database."
  default     = "DataWarehouse"
}

variable "sql_administrator_object_id" {
  type        = string
  description = "SQL Server administrator object ID."
}

variable "sql_admin_login" {
  type        = string
  description = "Default login for sql admin AD administrator."
  default     = "sqladmin"
}

variable "nw_resource_group_name" {
  type        = string
  description = "Name of the networking resource group."
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the the virtual network."
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet."
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public network access is allowed for this server."
  default     = false
}
