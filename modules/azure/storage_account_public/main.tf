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

  blob_properties {
    dynamic "cors_rule" {
      for_each = var.cors_rules != null ? [1] : []

      content {
        allowed_headers    = var.cors_rules.value.allowed_headers
        allowed_methods    = var.cors_rules.value.allowed_methods
        allowed_origins    = var.cors_rules.value.allowed_origins
        exposed_headers    = var.cors_rules.value.exposed_headers
        max_age_in_seconds = var.cors_rules.value.max_age_in_seconds
      }
    }

    dynamic "delete_retention_policy" {
      for_each = var.delete_retention_policy_days != null ? [1] : []

      content {
        days = var.delete_retention_policy_days
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
      name          = var.custom_domain.name
      use_subdomain = var.custom_domain.use_subdomain
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

data "azurerm_monitor_diagnostic_categories" "blob" {
  count       = var.loganalytics_diagnostic_setting.workspace_id == null || var.loganalytics_diagnostic_setting.blob == null ? 0 : 1
  resource_id = "${azurerm_storage_account.storage_account.id}/blobServices/default/"
}

data "azurerm_monitor_diagnostic_categories" "queue" {
  count       = var.loganalytics_diagnostic_setting.workspace_id == null || var.loganalytics_diagnostic_setting.queue == null ? 0 : 1
  resource_id = "${azurerm_storage_account.storage_account.id}/queueServices/default/"
}

data "azurerm_monitor_diagnostic_categories" "table" {
  count       = var.loganalytics_diagnostic_setting.workspace_id == null || var.loganalytics_diagnostic_setting.table == null ? 0 : 1
  resource_id = "${azurerm_storage_account.storage_account.id}/tableServices/default/"
}

data "azurerm_monitor_diagnostic_categories" "file" {
  count       = var.loganalytics_diagnostic_setting.workspace_id == null || var.loganalytics_diagnostic_setting.file == null ? 0 : 1
  resource_id = "${azurerm_storage_account.storage_account.id}/tableServices/default/"
}

resource "azurerm_monitor_diagnostic_setting" "blob" {
  count                      = var.loganalytics_diagnostic_setting.workspace_id == null || var.loganalytics_diagnostic_setting.blob == null ? 0 : 1
  name                       = "diag-blob-${var.name}"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/blobServices/default/"
  log_analytics_workspace_id = var.loganalytics_diagnostic_setting.workspace_id

  dynamic "enabled_log" {
    for_each = var.loganalytics_diagnostic_setting.blob.categories == null ? data.azurerm_monitor_diagnostic_categories.blob[0].log_category_types : var.loganalytics_diagnostic_setting.blob.categories

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.loganalytics_diagnostic_setting.blob.metrics == null ? data.azurerm_monitor_diagnostic_categories.blob[0].metrics : var.loganalytics_diagnostic_setting.blob.metrics

    content {
      category = metric.value
      enabled  = true
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "queue" {
  count                      = var.loganalytics_diagnostic_setting.workspace_id == null || var.loganalytics_diagnostic_setting.queue == null ? 0 : 1
  name                       = "diag-blob-${var.name}"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/queueServices/default/"
  log_analytics_workspace_id = var.loganalytics_diagnostic_setting.workspace_id

  dynamic "enabled_log" {
    for_each = var.loganalytics_diagnostic_setting.queue.categories == null ? data.azurerm_monitor_diagnostic_categories.queue[0].log_category_types : var.loganalytics_diagnostic_setting.queue.categories

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.loganalytics_diagnostic_setting.queue.metrics == null ? data.azurerm_monitor_diagnostic_categories.queue[0].metrics : var.loganalytics_diagnostic_setting.queue.metrics

    content {
      category = metric.value
      enabled  = true
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "table" {
  count                      = var.loganalytics_diagnostic_setting.workspace_id == null || var.loganalytics_diagnostic_setting.table == null ? 0 : 1
  name                       = "diag-blob-${var.name}"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/tableServices/default/"
  log_analytics_workspace_id = var.loganalytics_diagnostic_setting.workspace_id

  dynamic "enabled_log" {
    for_each = var.loganalytics_diagnostic_setting.table.categories == null ? data.azurerm_monitor_diagnostic_categories.table[0].log_category_types : var.loganalytics_diagnostic_setting.table.categories

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.loganalytics_diagnostic_setting.table.metrics == null ? data.azurerm_monitor_diagnostic_categories.table[0].metrics : var.loganalytics_diagnostic_setting.table.metrics

    content {
      category = metric.value
      enabled  = true
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "file" {
  count                      = var.loganalytics_diagnostic_setting.workspace_id == null || var.loganalytics_diagnostic_setting.table == null ? 0 : 1
  name                       = "diag-blob-${var.name}"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/fileServices/default/"
  log_analytics_workspace_id = var.loganalytics_diagnostic_setting.workspace_id

  dynamic "enabled_log" {
    for_each = var.loganalytics_diagnostic_setting.file.categories == null ? data.azurerm_monitor_diagnostic_categories.file[0].log_category_types : var.loganalytics_diagnostic_setting.file.categories

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.loganalytics_diagnostic_setting.file.metrics == null ? data.azurerm_monitor_diagnostic_categories.file[0].metrics : var.loganalytics_diagnostic_setting.file.metrics

    content {
      category = metric.value
      enabled  = true
    }
  }
}
