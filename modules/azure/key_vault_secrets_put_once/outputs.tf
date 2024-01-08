output "secrets" {
  value = {
    for prop in values(data.azurerm_key_vault_secret.secrets)[*] :
    prop.name => prop.value
  }
  sensitive = true
}
