terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. When fixed, we can revert.
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_key_vault_certificate" "certificate_automatic" {
  count = var.ignore_changes ? 0 : 1

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
}

resource "azurerm_key_vault_certificate" "certificate_for_manual_changes" {
  count = var.ignore_changes ? 1 : 0

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
    ignore_changes = [certificate_policy]
  }
}
