variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "application_type" {
  type        = string
  description = "Specifies the type of Application Insights to create."
  default     = "web"
}

variable "name" {
  type        = string
  description = " Specifies the name of the Application Insights component."
}
