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
  description = "Name of the app service plan."
}

variable "tier" {
  type        = string
  description = "Tier of the app service plan."
}

variable "size" {
  type        = string
  description = "Size of the app service plan."
}

variable "kind" {
  type        = string
  description = "The kind of app service plan."
  default     = "Linux"
}

variable "enable_autoscaling" {
  type        = bool
  description = "Indicates whether autoscaling should be turned on."
  default     = false
}

variable "default_scaling_capacity" {
  type        = number
  description = "The number of instances that are available for scaling if metrics are not available for evaluation."
  default     = 1
}

variable "minimum_scaling_capacity" {
  type        = number
  description = "The minimum number of instances for this resource."
  default     = 1
}

variable "maximum_scaling_capacity" {
  type        = number
  description = "The maximum number of instances for this resource."
  default     = 3
}
