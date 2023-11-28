variable "resource_group_name" {
  type        = string
  description = "Resource group the connection should be placed in"
}

variable "connection_name" {
  type        = string
  description = "Name for the connection"
}

variable "event_hub_namespace_endpoint" {
  type        = string
  description = "The namespace endpoint for the connected Event Hub"
}

variable "location" {
  type        = string
  description = "The location of the connector, set by Azure if not provided and used to avoid deployment differences."
}
