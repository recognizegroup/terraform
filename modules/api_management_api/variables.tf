variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

# variable "api_management_group_name" {
#   type        = string
#   description = "The name of the API management group."
# }

variable "openapi_file_path"{
  type        = string
  description = "Path to an openAPI .yaml file that describes this API"
}
