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
  description = "The name of the Data Factory."
}

variable "public_network_enabled" {
  type        = bool
  description = "Is the Data Factory visible to the public network?"
  default     = true
}
