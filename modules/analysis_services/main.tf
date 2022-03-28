terraform {
  required_version = ">=1.1.3"

  required_providers {
    azurerm = "=2.88.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_analysis_services_server" "server" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku                     = var.sku
  admin_users             = var.admin_users
  enable_power_bi_service = var.enable_power_bi

  dynamic "ipv4_firewall_rule" {
    for_each = toset(var.ipv4_firewall_rules)
    content {
      name        = ipv4_firewall_rule.value.name
      range_start = ipv4_firewall_rule.value.range_start
      range_end   = ipv4_firewall_rule.value.range_end
    }
  }
}
