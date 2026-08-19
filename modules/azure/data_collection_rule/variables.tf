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
  description = "Specifies the name of the Data Collection Rule."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource id of the Log Analytics Workspace the collected data is sent to."
}

variable "data_collection_endpoint_id" {
  type        = string
  description = "Resource id of the Data Collection Endpoint that receives the data."
}

variable "streams" {
  type = list(object({
    name          = string
    output_stream = string
    transform_kql = string
    columns = list(object({
      name = string
      type = string
    }))
  }))
  description = "The custom streams accepted by this rule. Every stream gets a stream declaration describing the incoming data and a data flow that transforms it into the output stream. Stream names must start with Custom-, and the output stream must reference a table that already exists in the workspace."
}

variable "destination_name" {
  type        = string
  description = "Name used to reference the Log Analytics destination inside the rule."
  default     = "logAnalytics"
}

variable "description" {
  type        = string
  description = "Specifies a description for the Data Collection Rule."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = null
}
