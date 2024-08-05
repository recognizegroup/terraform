variable "resource_group_name" {
  type        = string
  description = "Resource group this connection should be placed in"
}

variable "connection_name" {
  type        = string
  description = "The name the connection should have"
}

variable "sftp_password" {
  type        = string
  description = "The sftp password"
}

variable "sftp_username" {
  type        = string
  description = "The sftp username"
}

variable "sftp_hostname" {
  type        = string
  description = "The sftp hostname"
}

