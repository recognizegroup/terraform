output "key_vault_secret_value" {
  value     = data.azurerm_key_vault_secret.secret.value
  sensitive = true
}