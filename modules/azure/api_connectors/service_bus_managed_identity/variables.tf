variable "resource_group_name" {
  type        = string
  description = "Resource group the connection should be placed in"
}

variable "connection_name" {
  type        = string
  description = "Name for the connection"
}

variable "service_bus_namespace_endpoint" {
  type        = string
  description = "The namespace endpoint for the connected service bus"
}
