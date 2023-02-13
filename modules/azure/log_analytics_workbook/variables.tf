variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "workbook_name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workbook."
}

variable "workbook_template" {
  type = string
  description = "location of workbook template"
}

variable "resource_id_with_data" {
  type =  string
  description = "resource id that stores the data, such as Log analytics ID. Leave the default value 'Azure monitor' if you want it to be a part of azure monitor"
  default = "azure monitor"
}