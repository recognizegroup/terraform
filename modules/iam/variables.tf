variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "roles" {
  type        = list
  description = "List of user and group principals with corresponding roles."
}
