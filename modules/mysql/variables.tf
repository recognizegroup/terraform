variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "key_vault_id" {
  type        = string
  description = "ID of the key vault."
}

variable "mysql_admin_user_secret_name" {
  type        = string
  description = "Name of the mysql admin user stored secret."
}

variable "mysql_admin_password_secret_name" {
  type        = string
  description = "Name of the mysql admin password stored secret."
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
  default     = "5.7"
}

variable "mysql_server_auto_grow_enabled" {
  type        = bool
  description = "Enables auto-growing of mysql server storage."
  default     = true
}

variable "mysql_server_backup_retention_days" {
  type        = number
  description = "Backup retention days for the mysql server."
  default     = 7
}

variable "mysql_server_geo_redundant_backup_enabled" {
  type        = bool
  description = "Enables geo-redundant mysql server backups."
  default     = true
}

variable "mysql_server_infrastructure_encryption_enabled" {
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

variable "private_endpoint_name" {
  type        = string
  description = "Specifies the name of the Private Endpoint."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet from which private IP addresses will be allocated for this private endpoint."
}

variable "private_service_connection_name" {
  type        = string
  description = "Specifies the Name of the private service connection."
}

variable "private_dns_zone_group_name" {
  type        = string
  description = "Specifies the name of the private DNS zone group."
}

variable "private_dns_zone_ids" {
  type        = list
  description = "Specifies a list of private DNS zones IDs"
  default     = []
}
