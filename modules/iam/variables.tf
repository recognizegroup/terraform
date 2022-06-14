variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "roles" {
  type        = list(any)
  description = "List of user and group principals with corresponding roles."
}

variable "scope" {
  type        = string
  description = "The scope to use for the IAM rule, defaults to Resource Group"
  default     = null
}
