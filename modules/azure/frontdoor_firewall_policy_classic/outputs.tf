output "id" {
  value = azurerm_frontdoor_firewall_policy.firewall_policy.id
}

output "frontend_endpoint_ids" {
  value = azurerm_frontdoor_firewall_policy.firewall_policy.frontend_endpoint_ids
}
