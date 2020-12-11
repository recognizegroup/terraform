variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "azure_identities" {
  type        = map
  description = "Name of the identity in Azure, could be a user or a group."
}
