

variable "resource_group_name" {
  type        = string
  description = "Location For the Connection"
}

variable "serivce_bus_resource_group" {
  type        = string
  description = "Location Of The Service Bus"
}

variable "service_bus_namespace" {
  type = string
  description = "name space"
}

variable "connection_name" {
  type = string
  description = "connection Name"
}