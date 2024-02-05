output "secrets" {
  value = {
    for prop in values(resource.azurerm_key_vault_secret.secret)[*] :
    prop.name => {
      value         = prop.value
      versionlessid = prop.versionless_id
    }
  }
  sensitive = true
}