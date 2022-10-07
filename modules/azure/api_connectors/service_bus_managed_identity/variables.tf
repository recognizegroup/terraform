variable "resource_group_name" {
  type        = string
  description = "Location For the Connection."
}

variable "connection_name" {
  type        = string
  description = "Name of the connection."
}

variable "service_bus_namespace_endpoint" {
  type        = string
  description = "The namespace endpoint for the connected service bus"
}
