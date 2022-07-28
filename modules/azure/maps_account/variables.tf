variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "name" {
  type        = string
  description = "Specifies the name of the azure maps account."
}

variable "sku" {
  type        = string
  description = "Specifies the sku of the azure maps account."
  default     = "S0"
}
