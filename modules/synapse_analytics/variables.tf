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
