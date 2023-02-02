output "name" {
  value = var.name
}

output "secret_id" {
  value = var.ignore_changes ? azurerm_key_vault_certificate.certificate_for_manual_changes[0].secret_id : azurerm_key_vault_certificate.certificate_automatic[0].secret_id
}

output "versionless_secret_id" {
  value = var.ignore_changes ? azurerm_key_vault_certificate.certificate_for_manual_changes[0].versionless_secret_id : azurerm_key_vault_certificate.certificate_automatic[0].versionless_secret_id
}

output "id" {
  value = var.ignore_changes ? azurerm_key_vault_certificate.certificate_for_manual_changes[0].id : azurerm_key_vault_certificate.certificate_automatic[0].id
}
