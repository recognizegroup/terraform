variable "databricks_workspace_url" {
  type        = string
  description = "The url of the databricks workspace."
}

variable "databricks_secrets" {
  type = list(object({
    secret_name           = string
    secret_scope          = string
    key_vault_secret_name = string
    key_vault_id          = string
  }))
  description = "Map containing databricks secrets from key vault."
}

variable "databricks_secret_permissions" {
  type = list(object({
    secret_name       = string
    secret_scope      = string
    secret_permission = string
    group_name        = string
  }))
  description = "Map containing databricks secret permission."
}
