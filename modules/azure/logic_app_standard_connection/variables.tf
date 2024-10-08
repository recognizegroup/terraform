variable "location" {
  type = string
  description = "location"
  default = "northeurope" //Was hardcoded in ARM, for backward compatibility kept as northeurope
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "connection_name" {
  type        = string
  description = "Name of the connection."
}

variable "managed_api_id" {
  type        = string
  description = "The ID of the API to manage."
}

variable "parameter_values" {
  type        = map(string)
  description = "Set of parameter values for the API connection."
}

variable "kind" {
  type        = string
  description = "The kind of the api connection (either V1 or V2)."
  default     = "V1"
}
