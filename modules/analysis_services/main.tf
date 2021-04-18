terraform {
  required_version = ">=0.14.0"

  required_providers {
    azurerm = "=2.51.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_analysis_services_server" "server" {
  name                    = var.analysis_services_server_full_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku                     = var.analysis_services_server_sku
  admin_users             = var.analysis_services_server_admin_users
  enable_power_bi_service = var.analysis_services_server_enable_power_bi

  dynamic "ipv4_firewall_rule" {
    for_each = toset(var.ipv4_firewall_rules)
    content {
      name        = ipv4_firewall_rule.value.name
      range_start = ipv4_firewall_rule.value.range_start
      range_end   = ipv4_firewall_rule.value.range_end
    }
  }
}
