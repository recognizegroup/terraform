variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "name" {
  type        = string
  description = "Name of the resource which will be created"
  default     = null
}

variable "connection_name" {
  type        = string
  description = "Name of the connection."
}

variable "principal_id" {
  type        = string
  description = "The ID of the principal."
  default     = null
}
