variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "mysql_server_name" {
  type        = string
  description = "Name of the mysql server."
}

variable "mysql_server_sku" {
  type        = string
  description = "Specifies the sku for the mysql server"
  default     = "GP_Gen5_2"
}

variable "mysql_server_max_storage" {
  type        = number
  description = "Max storage allowed for the mysql server."
  default     = 5120
}

variable "mysql_server_version" {
  type        = string
  description = "Mysql server version."
}

variable "storage_auto_grow_enabled" {
  type        = bool
  description = "Enables auto-growing of mysql server storage."
  default     = true
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention days for the mysql server."
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Enables geo-redundant mysql server backups."
  default     = true
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  description = "Whether or not infrastructure is encrypted for the mysql server."
  default     = true
}

variable "mysql_database_name" {
  type        = string
  description = "Name of the mysql database."
}

variable "mysql_database_charset" {
  type        = string
  description = "Specifies the charset for the mysql database."
  default     = "utf8"
}

variable "mysql_database_collation" {
  type        = string
  description = "Specifies the collation for the mysql database."
  default     = "utf8_unicode_ci"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet from which private IP addresses will be allocated for this private endpoint."
}

variable "mysql_admin_username" {
  type        = string
  description = "The administrator login username for the mysql server."
}

variable "password_keeper" {
  type        = map(string)
  description = "Random map of strings, when changed the mysql admin password will rotate."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}
