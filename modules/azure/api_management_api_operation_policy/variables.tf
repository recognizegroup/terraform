variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "operation_id" {
  type        = string
  description = "id of the operation"
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

variable "api_name" {
  type        = string
  description = "API name"
}

variable "policy_location" {
  type        = string
  description = "location of xml policy file for this specific operation"
}
