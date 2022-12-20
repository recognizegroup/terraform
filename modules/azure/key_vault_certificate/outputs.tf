output "name" {
  value = var.name
}

output "secret_id" {
  value = azurerm_key_vault_certificate.certificate.secret_id
}

output "versionless_secret_id" {
  value = azurerm_key_vault_certificate.certificate.versionless_secret_id
}

output "id" {
  value = azurerm_key_vault_certificate.certificate.id
}