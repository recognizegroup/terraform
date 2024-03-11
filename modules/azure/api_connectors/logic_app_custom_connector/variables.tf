variable "resource_group_name" {
  type        = string
  description = "Resource group this connection should be placed in"
}

variable "connector_name" {
  type        = string
  description = "The name the connection should have"
}

variable "function_url" {
  type        = string
  description = "The url of function"
}

variable "swagger" {
  type        = string
  description = "Swagger definition"
}

variable "swagger_path" {
  description = "Path to the Swagger JSON file"
  type        = string
  default     = ""
}
