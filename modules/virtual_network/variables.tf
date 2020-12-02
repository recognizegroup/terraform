variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network."
}

variable "virtual_network_address_space" {
  type        = list
  default     = ["10.0.0.0/16"]
  description = "Address space of the virtual network."
}

variable "virtual_network_subnets" {
  type        = list
  description = "Subnets to deploy inside the virtual network. Each subnet should include a name and address_space variable."
  default     = []
}
