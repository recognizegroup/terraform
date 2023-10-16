variable "resource_group_name" {
  type        = string
  description = "Resource group the connection should be placed in"
}

variable "connection_names" {
  type        = set(string)
  description = "The names for the connection"
}

variable "service_bus_namespace_endpoint" {
  type        = string
  description = "The namespace endpoint for the connected service bus"
}

variable "location" {
  type        = string
  description = "The location of the connector, set by Azure if not provided and used to avoid deployment differences."
}
