variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API management service."
}

variable "file_location" {
  type        = string
  description = "Path to schema file."
}

variable "type" {
  type        = string
  description = "The content type of the Schema. Possible values are xml and json."
}

variable "schema_id" {
  type        = string
  description = "A unique identifier for this Schema."
}
