output "roles" {
  value = azurerm_role_definition.role_definition
}

output "groups" {
  value = data.azuread_group.group
}
