output "id" {
  value = azurerm_maps_account.maps_account.id
}

output "primary_access_key" {
  value     = azurerm_maps_account.maps_account.primary_access_key
  sensitive = true
}

output "secondary_access_key" {
  value     = azurerm_maps_account.maps_account.secondary_access_key
  sensitive = true
}

output "x_ms_client_id" {
  value     = azurerm_maps_account.maps_account.x_ms_client_id
  sensitive = true
}
