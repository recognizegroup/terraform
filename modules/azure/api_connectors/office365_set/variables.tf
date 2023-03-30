variable "resource_group_name" {
  type        = string
  description = "Resource group this connection should be placed in"
}

variable "connection_names" {
  type        = set(string)
  description = "The names the connection should have"
}
