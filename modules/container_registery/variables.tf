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
  description = "Specifies the name of the application insights component."
}

variable "sku" {
  type    = string
  default = "Standard"
}

variable "create_container" {
  type    = number
  default = 0
}
