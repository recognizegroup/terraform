variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "name" {
  type        = string
  description = "Name of the service bus."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "sku" {
  type        = string
  description = "Stock Keeping Unit of the service bus."
  default     = "Standard"
}

variable "authorization_rule" {
  type = object({
    listen = bool
    send   = bool
    manage = bool
  })
  description = "Manages a ServiceBus Namespace authorization Rule within the ServiceBus."
  default     = null
}
