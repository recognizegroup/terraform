variable "resource_group_name" {
  type        = string
  description = "Resource group this connection should be placed in"
}

variable "connection_name" {
  type        = string
  description = "The name the connection should have"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "The ID for the connected workspace"
}

variable "log_analytics_workspace_key" {
  type        = string
  description = "The access key for the connected workspace"
}
