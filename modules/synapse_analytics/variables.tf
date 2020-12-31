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

variable "sql_database_sku" {
  type        = string
  description = "Azure sql database sku."
  default     = "DW100c"
}

variable "sql_database_name" {
  type        = string
  description = "Name of the azure sql database."
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

variable "audit_logging_primary_blob_endpoint" {
  type        = string
  description = "The blob storage endpoint."
}

variable "audit_logging_primary_access_key" {
  type        = string
  description = "The access key to use for the auditing storage account."
}

variable "audit_logging_primary_access_key_is_secondary" {
  type        = bool
  description = "Specifies if storage_account_access_key is a secondary key."
  default     = false
}

variable "audit_logging_retention" {
  type        = number
  description = "The number of days to retain audit logs."
}
