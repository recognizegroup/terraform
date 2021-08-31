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

variable "app_service_autoscaling_name" {
  type        = string
  description = "The name of the app service autoscaling configuration."
  default     = ""
}

variable "app_service_default_capacity" {
  type        = number
  description = "The number of instances that are available for scaling if metrics are not available for evaluation."
  default     = 1
}

variable "app_service_minimum_capacity" {
  type        = number
  description = "The minimum number of instances for this resource."
  default     = 1
}

variable "app_service_maximum_capacity" {
  type        = number
  description = "The maximum number of instances for this resource."
  default     = 3
}
