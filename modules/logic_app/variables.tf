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
  description = "Specifies the name of the Log Analytics Workspace."
}

variable "arm_template" {
  type        = string
  description = "Specifies the ARM template to be used during deployment"
  default     = null
}

variable "parameters_content" {
  type        = string
  description = "The contents of the ARM Template parameters file - containing a JSON list of parameters"
  default     = null
}

variable "ise_id" {
  type        = string
  description = "The ID of the Integration Service Environment to which this Logic App Workflow belongs"
  default     = null
}

