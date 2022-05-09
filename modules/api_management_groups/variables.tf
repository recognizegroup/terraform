variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

variable "groups" {
  type = list(object({
    name         = string
    display_name = string
    external_id  = string
  }))
  description = "A list of groups"
}
