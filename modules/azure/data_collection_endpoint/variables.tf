variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "name" {
  type        = string
  description = "Specifies the name of the Data Collection Endpoint."
}

variable "kind" {
  type        = string
  description = "The kind of the Data Collection Endpoint. Possible values are Linux and Windows."
  default     = "Linux"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether network access from public internet to the endpoint is allowed."
  default     = true
}

variable "description" {
  type        = string
  description = "Specifies a description for the Data Collection Endpoint."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = null
}
