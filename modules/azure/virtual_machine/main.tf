terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40"
    }
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

data "azurerm_key_vault_secret" "vm_user_secret" {
  name         = var.vm_user_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "vm_password_secret" {
  name         = var.vm_password_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_platform_image" "image" {
  location  = var.location
  publisher = var.image_publisher
  offer     = var.image_offer
  sku       = var.image_sku
  version   = var.image_version
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
    public_ip_address_id          = var.public_ip_address_id
  }
}

resource "azurerm_windows_virtual_machine" "virtual_machine" {
  name                     = var.virtual_machine_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  size                     = var.virtual_machine_size
  computer_name            = var.virtual_machine_name
  admin_username           = data.azurerm_key_vault_secret.vm_user_secret.value
  admin_password           = data.azurerm_key_vault_secret.vm_password_secret.value
  timezone                 = var.timezone
  provision_vm_agent       = var.enable_guest_agent
  enable_automatic_updates = var.enable_auto_updates
  network_interface_ids    = [azurerm_network_interface.network_interface.id]
  license_type             = var.license_type

  dynamic "plan" {
    for_each = var.requires_plan ? [1] : []
    content {
      name      = var.image_sku
      publisher = var.image_publisher
      product   = var.image_offer
    }
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_disk {
    name                 = var.os_disk_name
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }
}
