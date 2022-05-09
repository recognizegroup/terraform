output "group_names" {
  value = [
    for group in azurerm_api_management_group.group : group.name
  ]
}