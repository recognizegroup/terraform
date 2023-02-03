variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "workspace_url" {
  type        = string
  description = "The url of the databricks workspace."
}

variable "cluster_id" {
  type        = string
  description = "The ID of a databricks cluster."
  default     = null
}

variable "groups" {
  type = map(object({
    cluster_usage = string,
    display_name  = string,
    policy_usage  = string,
    token_usage   = string,
    users         = list(string),
  }))
  description = "Groups, users and permissions for a databricks workspace."
}

variable "default_policy" {
  type        = string
  description = "Default cluster policy."
  default     = ""
}
