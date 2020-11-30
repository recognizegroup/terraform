terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = "=2.37.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "vm_password_secret" {
  name         = var.vm_user_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "vm_user_secret" {
  name         = var.vm_password_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.nw_resource_group_name
}

resource "azurerm_network_interface" "network_interface" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
  }
}

resource "azurerm_virtual_machine" "virtual_machine" {
  name                          = var.virtual_machine_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  vm_size                       = var.virtual_machine_size
  network_interface_ids         = [azurerm_network_interface.network_interface.id]
  delete_os_disk_on_termination = var.delete_os_disk_on_termination

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  plan {
    name      = var.image_sku
    publisher = var.image_publisher
    product   = var.image_offer
  }

  storage_os_disk {
    name              = var.os_disk_name
    create_option     = var.os_disk_create_option
    caching           = var.os_disk_caching
    managed_disk_type = var.os_disk_managed_disk_type
  }

  os_profile {
    computer_name  = var.computer_name
    admin_username = data.azurerm_key_vault_secret.vm_user_secret.value
    admin_password = data.azurerm_key_vault_secret.vm_password_secret.value
  }

  os_profile_windows_config {
    provision_vm_agent        = var.enable_guest_agent
    enable_automatic_upgrades = var.enable_auto_updates
  }
}
