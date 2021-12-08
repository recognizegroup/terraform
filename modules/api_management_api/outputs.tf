output "api_names" {
  value = [
    for api in azurerm_api_management_api.api : api.name
  ]
}
