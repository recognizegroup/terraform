terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = "=2.94.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_key_vault_certificate" "certificate" {
  name         = var.name
  key_vault_id = var.key_vault_id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    key_properties {
      exportable = true
      key_size   = var.key_properties.key_size
      key_type   = var.key_properties.key_type
      reuse_key  = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      key_usage = [
        "cRLSign",
      ]
      subject_alternative_names {
        dns_names = var.dns_names
      }
      subject            = var.subject
      validity_in_months = 12
    }
  }

  lifecycle {
    ignore_changes = var.ignore_changes == false? [] : [certificate_policy]
  }
}
