variable "products_per_user" {
  type = list(object({
    user_id     = string
    product_ids = list(string)
  }))
  default     = []
  description = "List of users with a list of all products they should be subscribed to."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}
