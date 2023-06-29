terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

###########################################################
##########     API Management custom domains     ##########
###########################################################

resource "azurerm_api_management_custom_domain" "custom_domain" {
  count             = var.custom_domains == null ? 0 : 1
  api_management_id = var.api_management_id

  dynamic "gateway" {
    for_each = {
      for domain in var.custom_domains :
      domain.host_name => domain if domain.type == "gateway"
    }
    content {
      host_name           = gateway.value.host_name
      key_vault_id        = gateway.value.keyvault_certificate_id
      default_ssl_binding = gateway.value.default_ssl_binding
    }
  }

  dynamic "developer_portal" {
    for_each = {
      for domain in var.custom_domains :
      domain.host_name => domain if domain.type == "developer_portal"
    }
    content {
      host_name    = developer_portal.value.host_name
      key_vault_id = developer_portal.value.keyvault_certificate_id
    }
  }

  dynamic "management" {
    for_each = {
      for domain in var.custom_domains :
      domain.host_name => domain if domain.type == "management"
    }
    content {
      host_name    = management.value.host_name
      key_vault_id = management.value.keyvault_certificate_id
    }
  }
}
