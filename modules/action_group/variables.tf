variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "name" {
  type        = string
  description = "The name of the action group."
}

variable "short_name" {
  type        = string
  description = "The short name of the action group. This will be used in SMS messages."
}
