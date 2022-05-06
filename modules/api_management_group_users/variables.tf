variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

variable "users" {
    type      = list(object({
        user_id     = string
        first_name  = string
        last_name   = string
        email       = string
    }))
    description = "A list of users"
}

variable "groups" {
    type      = list(object({
        name          = string
        display_name  = string
    }))
    description = "A list of groups"
}

variable "users_per_group" {
    type      = list(object({
        group_name    = string
        user_ids      = list(string)
    }))
    description = "A list of groups"
}