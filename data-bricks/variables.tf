variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "skip_provider_registration" {
  type        = string
  description = "Indicates whether the provider should be registered in Azure."
  default     = false
}

variable "databricks_name" {
	type        = string
	description =  "The name of the databricks worskpace"
}

variable "databricks_namespace_sku" {
	type		= string
  description =  "The databricks sku"
  default = "standard"
}
