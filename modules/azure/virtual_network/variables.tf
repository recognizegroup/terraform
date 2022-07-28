variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "name" {
  type        = string
  description = "Name of the virtual network."
}

variable "address_space" {
  type        = list
  description = "Address space of the virtual network."
}
