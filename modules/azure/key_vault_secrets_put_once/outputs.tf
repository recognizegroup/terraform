output "secrets" {
  value = {
    for prop in values(resource.azurerm_key_vault_secret.secret)[*] :
    prop.name => prop.value
  }
  sensitive = true
}
