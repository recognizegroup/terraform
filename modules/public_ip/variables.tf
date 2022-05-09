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
  description = "The name of the Public IP."
}

variable "sku" {
  type        = string
  description = "sku type, can be Standard or Basic. Defaults to Basic, if set to standard allocation_method is forced to Static"
  default     = "Basic"
}

variable "allocation_method" {
  type        = string
  description = "Allocation method for the Public IP. Can be Static or Dynamic, defaults to Static"
  default     = "Static"
}

variable "domain_name_label" {
  type        = string
  description = "Label for the Domain Name. Will be used to make up the FQDN"
  default     = null
}

variable "sku" {
  type        = string
  description = "The SKU of the Public IP."
  default     = "Basic"
}
