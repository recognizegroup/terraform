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
  description = "Name of the service plan."
}

# Possible values: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan#sku_name
variable "sku_name" {
  type        = string
  description = "The SKU for the plan. Possible values can be found on https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan#sku_name"
}

# Possible values: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan#os_type
variable "os_type" {
  type        = string
  description = "The OS type for the service plan. Possible values can be found on https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan#os_type"
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

variable "scaling_rules" {
  type = set(object({
    metric_name = string
    threshold   = number
    operator    = string
    direction   = string
  }))
  description = "Scaling rules for autoscaling."

  default = [
    {
      metric_name = "CpuPercentage"
      threshold   = 80
      operator    = "GreaterThan"
      direction   = "Increase"
    },
    {
      metric_name = "CpuPercentage"
      threshold   = 20
      operator    = "LessThan"
      direction   = "Decrease"
    }
  ]
}
