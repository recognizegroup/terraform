variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "app_service_plan_name" {
  type        = string
  description = "Name of the ASP"
}

variable "app_service_plan_tier" {
  type        = string
  description = "Tier of the ASP"
}

variable "app_service_plan_size" {
  type        = string
  description = "size of the ASP"
}

variable "app_service_plan_kind" {
  type        = string
  description = "The kind of the ASP."
  default     = "Windows"
}
