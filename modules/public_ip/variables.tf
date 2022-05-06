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
  description = "The name of the public-ip."
}

variable "sku" {
    type = string
    description = "sku type, can be Standard or Basic. Defaults to Basic, if set to standard allocation_method is forced to Static"
    default = "Basic"
}

variable "allocation_method" {
  type        = string
  description = "Allocation method for the public-ip. Can be Static or Dynamic, defaults to Static"
  default     = "Static"
}

variable "domain_name_label"{
    type        = string
    description = "zones for this public-ip. Multiple zones are required if specifying route preference"
    default     = ""
}