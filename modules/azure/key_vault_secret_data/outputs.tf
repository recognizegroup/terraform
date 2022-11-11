output "key_value" {
    value = data.azurerm_key_vault_secret.secretName.value
    sensitive = true
}
