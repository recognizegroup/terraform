# variable "location" {
#   type        = string
#   description = "A datacenter location in Azure."
# }

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "workbook_name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workbook."
}

variable "serializedDataFile" {
  type = string
  description = "location of Serialized Data"
}

variable "resource_id_with_data" {
  type =  string
  description = "resource id that stores the data, such as Log analytics ID"
}

# variable "arm_template_path" {
#   type        = string
#   description = "Specifies the path of ARM template to be used during deployment."
#   default     = null
# }

# variable "arm_parameters" {
#   type        = any
#   description = "Parameter values for the ARM template."
#   default     = {}
# }