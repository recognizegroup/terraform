variable "user_subscriptions" {
  type        = list(object({
    user_id = string 
    product_ids = list(string)
    }))
    default   =  []
  description = "Name of the resource group."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}
