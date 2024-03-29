variable "workspace_url" {
  type        = string
  description = "The url of the databricks workspace."
}

variable "users" {
  type        = list(string)
  description = "A list of users in the databricks workspace."
  default     = []
}

variable "admins" {
  type        = list(string)
  description = "A list of admins in the databricks workspace."
  default     = []
}
