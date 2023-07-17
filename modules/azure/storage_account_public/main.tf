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

resource "azurerm_storage_account" "storage_account" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_kind                    = var.kind
  account_tier                    = var.tier
  account_replication_type        = var.replication_type
  enable_https_traffic_only       = var.enable_https_traffic_only
  allow_nested_items_to_be_public = var.allow_public_access
  min_tls_version                 = var.min_tls_version
  nfsv3_enabled                   = var.nfsv3_enabled
  is_hns_enabled                  = var.is_hns_enabled

  dynamic "blob_properties" {
    for_each = var.cors_rules != null ? [1] : []

    content {
      dynamic "cors_rule" {
        for_each = var.cors_rules

        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
    }
  }

  dynamic "network_rules" {
    for_each = var.nfsv3_enabled == true ? [1] : []
    content {
      default_action = "Deny"
      bypass         = ["AzureServices"]
      ip_rules       = ["${chomp(data.http.amazonaws[0].body)}"]
    }
  }

  dynamic "azure_files_authentication" {
    for_each = var.authentication_directory_type == null ? [] : [1]
    content {
      directory_type = var.authentication_directory_type
    }
  }

  dynamic "static_website" {
    for_each = var.static_website != null ? [1] : []
    content {
      index_document     = var.static_website.index_document
      error_404_document = var.static_website.error_document
    }
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain != null ? [1] : []
    content {
      name                = var.custom_domain.name
      use_sub_domain_name = var.custom_domain.use_sub_domain_name
    }
  }
}

# Get our public IP address
data "http" "amazonaws" {
  count = var.nfsv3_enabled == true ? 1 : 0
  url   = "https://checkip.amazonaws.com/"
}

resource "azurerm_storage_management_policy" "storage_management_policy" {
  count = var.auto_delete_rules != null ? 1 : 0

  storage_account_id = azurerm_storage_account.storage_account.id

  dynamic "rule" {
    for_each = var.auto_delete_rules

    content {
      name    = rule.value.name
      enabled = true

      filters {
        prefix_match = rule.value.prefixes
        blob_types   = ["blockBlob"]
      }

      actions {
        base_blob {
          delete_after_days_since_modification_greater_than     = rule.value.days_after_modification
          delete_after_days_since_last_access_time_greater_than = rule.value.days_after_access
          delete_after_days_since_creation_greater_than         = rule.value.days_after_creation
        }
      }
    }
  }
}
