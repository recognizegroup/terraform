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
  description = "Specifies the name of the container registery component."
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "Specifies the container registery pricing model."
}
