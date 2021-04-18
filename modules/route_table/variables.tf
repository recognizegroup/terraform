variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "route_table_name" {
  type        = string
  description = "The name of the route table."
}

variable "routes" {
  type        = list
  description = "List of objects representing routes."
}
