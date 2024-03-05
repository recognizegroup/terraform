variable "resource_group_name" {
  type        = string
  description = "Resource group the connection should be placed in"
}

variable "connection_name" {
  type        = string
  description = "Name for the connection"
}

variable "connector_resource_group_name" {
  type        = string
  description = "Name for the connection"
}

variable "connector_name" {
  type        = string
  description = "Name for the connection"
}

variable "location" {
  type        = string
  description = "The location of the connector, set by Azure if not provided and used to avoid deployment differences."
}
