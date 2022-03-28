variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "server_name" {
  type        = string
  description = "Name of the sql server."
}

variable "server_version" {
  type        = string
  description = "Azure sql server version."
  default     = "12.0"
}

variable "admin_username" {
  type        = string
  description = "Name of the mssql admin user."
}

variable "password_keeper" {
  type        = map(string)
  description = "Random map of strings, when changed the mssql admin password will rotate."
}

variable "database_name" {
  type        = string
  description = "Name of the azure sql database."
}

variable "database_sku" {
  type        = string
  description = "Azure sql database sku."
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet for the private endpoint."
}

variable "short_term_retention_days" {
  type        = number
  description = "Number of days to keep short term backups."
  default     = null
}

variable "administrator_object_id" {
  type        = string
  description = "Azure AD object ID of the mssql administrator."
  default     = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of a log analytics workspace (optional)."
  default     = null
}

#############################
#### Serverless SKU only ####
#############################

variable "min_capacity" {
  type        = number
  description = "Minimal capacity that database will always have allocated, if not paused."
  default     = null
}

variable "auto_pause_delay" {
  type        = number
  description = "Time in minutes after which database is automatically paused."
  default     = null
}

#############################
## END Serverless SKU only ##
#############################
