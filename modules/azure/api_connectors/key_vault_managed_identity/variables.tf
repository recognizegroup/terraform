variable "resource_group_name" {
  type        = string
  description = "Resource group the connection should be placed in"
}

variable "connection_name" {
  type        = string
  description = "Name for the connection"
}

variable "keyvault_name" {
  type        = string
  description = "Name of the Keyvault"
}