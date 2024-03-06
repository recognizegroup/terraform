variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

variable "schema" {
  type = object({
    file_location = optional(string),
    type          = optional(string),
    schema_id     = optional(string)
  })

  default = {
    file_location = null
    type          = null
    schema_id     = null
  }

  validation {
    condition     = ((var.schema.file_location != null && var.schema.type != null && var.schema.schema_id != null) || (var.schema.file_location == null && var.schema.type == null && var.schema.schema_id == null))
    error_message = "schema_id, file_location and type must be provided."
  }

  description = "Schema for validation of request"
}
