output "virtual_machine_name" {
  value = azurerm_windows_virtual_machine.virtual_machine.name
}

output "virtual_machine_id" {
  value = azurerm_windows_virtual_machine.virtual_machine.id
}

output "virtual_machine_disk_id" {
  value = azurerm_windows_virtual_machine.virtual_machine.os_disk
}

output "virtual_machine_admin_user" {
  value = azurerm_windows_virtual_machine.virtual_machine.admin_username
}

output "virtual_machine_admin_password" {
  value     = azurerm_windows_virtual_machine.virtual_machine.admin_password
  sensitive = true
}
