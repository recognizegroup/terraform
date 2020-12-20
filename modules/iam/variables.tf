variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "azure_permissions" {
  type        = map
  description = "Mapping of user groups and permissions."
}
