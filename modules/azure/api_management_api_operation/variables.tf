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

variable "display_name" {
  type        = string
  description = "Operation display name"
}

variable "operation_method" {
  type        = string
  description = "Operation method"
}

variable "url_template" {
  type        = string
  description = "Url of operation"
}

variable "description" {
  type        = string
  description = "Description of operation"
}

variable "request_content_type" {
  type        = string
  description = "Request representation content type"
}

variable "policy" {
  type = object({
    file_location = optional(string),
    xml_string    = optional(string)
  })
  validation {
    condition     = (var.policy.file_location != null || var.policy.xml_string != null)
    error_message = "Either file_location or xml_string must be provided."
  }
  description = "XML policy described by a file (location) or raw string."
}
