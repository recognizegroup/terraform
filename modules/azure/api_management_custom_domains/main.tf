terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

###########################################################
##########     API Management custom domains     ##########
###########################################################

resource "azurerm_key_vault_certificate" "certificate" {
  for_each = {
    for domain in var.custom_domains :
    domain.host_name => domain
  }

  name         = each.value.certificate_name
  key_vault_id = each.value.key_vault_id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=${each.value.host_name}"
      validity_in_months = 12

      subject_alternative_names {
        dns_names = [each.value.host_name]
      }
    }
  }
}

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
      key_vault_id        = azurerm_key_vault_certificate.certificate[gateway.value.host_name].versionless_secret_id
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
      key_vault_id = azurerm_key_vault_certificate.certificate[developer_portal.value.host_name].versionless_secret_id
    }
  }

  dynamic "management" {
    for_each = {
      for domain in var.custom_domains :
      domain.host_name => domain if domain.type == "management"
    }
    content {
      host_name    = management.value.host_name
      key_vault_id = azurerm_key_vault_certificate.certificate[management.value.host_name].versionless_secret_id
    }
  }
}
