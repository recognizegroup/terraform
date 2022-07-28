terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = ">=2.24.0"
  }

  backend "azurerm" {}

  experiments = [module_variable_optional_attrs]
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
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges         = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_range     = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges    = lookup(security_rule.value, "destination_port_ranges", null)
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_association" {
  for_each                  = toset(var.subnet_ids)
  subnet_id                 = each.key
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}
