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

variable "policy" {
  type = object({
    file_location = optional(string),
    xml_string    = optional(string)
  })
  validation {
    condition     = (file_location != null || xml_string != null)
    error_message = "Either file_location or xml_string must be provided."
  }
  description = "XML policy described by a file (location) or raw string."
}
