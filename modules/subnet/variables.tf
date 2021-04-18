variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet."
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network."
}

variable "subnet_address_prefixes" {
  type        = list
  description = "The address prefix to use for the subnet."
}

variable "route_table_id" {
  type        = string
  description = "The ID of the route table which should be associated with the Subnet."
}
