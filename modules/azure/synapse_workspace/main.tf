terraform {
  required_version = ">=1.3.4"

  required_providers {
    azurerm = "=3.36.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "filesystem" {
  name               = var.filesystem_name
  storage_account_id = azurerm_storage_account.storage_account.id
}

resource "random_password" "sql_admin_password" {
  length           = 16
  special          = true
  lower            = true
  upper            = true
  numeric          = true
  override_special = "_%@"
  keepers = {
    keeper = var.sql_admin_password_keeper
  }
}

resource "azurerm_synapse_workspace" "workspace" {
  name                                 = var.workspace_name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.filesystem.id
  sql_administrator_login              = var.sql_admin_login
  sql_administrator_login_password     = random_password.sql_admin_password.result
  compute_subnet_id                    = var.compute_subnet_id
  managed_virtual_network_enabled      = var.managed_virtual_network_enabled
  public_network_access_enabled        = var.public_network_access_enabled
  data_exfiltration_protection_enabled = null
  linking_allowed_for_aad_tenant_ids   = var.linking_allowed_for_aad_tenant_ids
  managed_resource_group_name          = var.managed_resource_group_name

  aad_admin {
    login     = "AzureAD Admin"
    object_id = var.aad_admin_object_id
    tenant_id = var.aad_admin_tenant_id
  }

  sql_aad_admin {
    login     = "AzureAD Admin"
    object_id = var.aad_admin_object_id
    tenant_id = var.aad_admin_tenant_id
  }

  identity {
    type = "SystemAssigned"
  }

  dynamic "github_repo" {
    for_each = var.github == null ? [] : [1]
    content {
      account_name    = var.github.account_name
      branch_name     = var.github.branch_name
      repository_name = var.github.repository_name
      root_folder     = var.github.root_folder
      last_commit_id  = var.github.last_commit_id
      git_url         = var.github.git_url
    }
  }

  dynamic "azure_devops_repo" {
    for_each = var.devops == null ? [] : [1]
    content {
      account_name    = var.devops.account_name
      project_name    = var.devops.project_name
      branch_name     = var.devops.branch_name
      repository_name = var.devops.repository_name
      root_folder     = var.devops.root_folder
      last_commit_id  = var.devops.last_commit_id
      tenant_id       = var.devops.tenant_id
    }
  }
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_synapse_workspace.workspace.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.workspace_name}"
  target_resource_id         = azurerm_synapse_workspace.workspace.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].log_category_types

    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].metrics

    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }
}

resource "azurerm_synapse_firewall_rule" "firewall_rule" {
  name                 = "AllowAll"
  synapse_workspace_id = azurerm_synapse_workspace.workspace.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}

resource "azurerm_synapse_role_assignment" "role_assignment" {
  for_each = {
    for index, role in var.role_assignments :
    index => role
  }
  synapse_workspace_id = azurerm_synapse_workspace.workspace.id
  role_name            = each.value.role_name
  principal_id         = each.value.object_id

  # HACK: This is needed for the role assigment to be created after the firewall rule is set
  depends_on = [
    azurerm_synapse_firewall_rule.firewall_rule
  ]
}

resource "azurerm_synapse_managed_private_endpoint" "managed_private_endpoints" {
  for_each = {
    for endpoint in var.managed_private_endpoints :
    endpoint.resource_name => endpoint
  }
  name                 = "mpep-${each.value.resource_name}"
  synapse_workspace_id = azurerm_synapse_workspace.workspace.id
  target_resource_id   = each.value.resource_id
  subresource_name     = each.value.subresource_name

  depends_on = [azurerm_synapse_firewall_rule.firewall_rule]
}

