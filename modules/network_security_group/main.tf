terraform {
  required_version = ">=0.13.4"

  required_providers {
    azurerm = ">=2.24.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = {
      for rule in var.security_rules :
      rule.name => rule
    }
    content {
      name                       = each.value.name
      priority                   = each.value.priority
      direction                  = each.value.direction
      access                     = each.value.access
      protocol                   = each.value.protocol
      source_port_range          = each.value.source_port_range
      destination_port_range     = each.value.destination_port_range
      source_address_prefix      = each.value.source_address_prefix
      destination_address_prefix = each.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_association" {
  for_each                  = toset(var.subnet_ids)
  subnet_id                 = each.key
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}
