variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

variable "openapi_file_path" {
  type        = string
  description = "Path to an openAPI .yaml file that describes this API"
}

variable "owners" {
  type        = list(any)
  description = "List of AAD object IDs to set as API management owners."
  default     = []
}

variable "object_ids" {
  type        = list(string)
  description = "managed identity object ids that want access to the through AAD application"
}
variable "require_api_subscription" {
  type        = string
  description = "bool value for required subscriptions at the api level"
  default     = false
}
