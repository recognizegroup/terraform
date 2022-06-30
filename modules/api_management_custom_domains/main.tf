terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.5.0"
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
  for_each = {
    for domain in var.custom_domains :
    domain.host_name => domain
  }
  api_management_id = var.api_management_id

  dynamic "gateway" {
    for_each = each.value.type == "gateway" ? [1] : []
    content {
      host_name    = each.value.host_name
      key_vault_id = azurerm_key_vault_certificate.certificate[each.key].versionless_secret_id
    }
  }

  dynamic "developer_portal" {
    for_each = each.value.type == "developer_portal" ? [1] : []
    content {
      host_name    = each.value.host_name
      key_vault_id = azurerm_key_vault_certificate.certificate[each.key].versionless_secret_id
    }
  }

  dynamic "management" {
    for_each = each.value.type == "management" ? [1] : []
    content {
      host_name    = each.value.host_name
      key_vault_id = azurerm_key_vault_certificate.certificate[each.key].versionless_secret_id
    }
  }
}
