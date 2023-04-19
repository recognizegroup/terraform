variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "name" {
  type        = string
  description = "Specifies the name of the PostgreSQL Flexible Server."
}

variable "postgresql_sku_name" {
  type        = string
  description = "Specifies the SKU Name for this PostgreSQL Server"
}

variable "postgresql_db_size" {
  type        = number
  description = "Specifies the max storage allowed for this PostgreSQL Server"
}

variable "postgresql_version" {
  type        = string
  description = "Version of the PostgreSQL database."
}

variable "postgresql_database_name" {
  type        = string
  description = "Name of the PostgreSQL resource."
}

variable "postgresql_database_collation" {
  type        = string
  description = "Specifies the Collation for this PostgreSQL Flexible Server"
  default     = "en_US.utf8"
}

variable "admin_username" {
  type        = string
  description = "Specifies the Administrator username for this PostgreSQL Flexible Server."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}

variable "password_keeper" {
  type        = map(string)
  description = "Random map of strings, when changed the postgresql admin password will rotate."
}

variable "whitelist_ip_addresses" {
  type        = set(string)
  description = "List of IP addresses to whitelist."
  default     = []
}
