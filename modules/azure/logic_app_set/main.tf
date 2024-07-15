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

locals {
  logic_app_instances = { for app in var.logic_app_instances : app.logic_app_name => app }
}

resource "azurerm_logic_app_workflow" "workflow" {
  for_each            = local.logic_app_instances
  name                = each.value.logic_app_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "identity" {
    for_each = var.use_managed_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
}

// Deploy workflow as ARM template conditional when arm_template_path is specified
// To export the ARM template from the Azure portal go to Logic App > Automation > Export Template
resource "azurerm_resource_group_template_deployment" "workflow_deployment" {
  for_each            = var.arm_template_path == null ? {} : local.logic_app_instances
  name                = "${each.key}-deployment"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  template_content    = file(var.arm_template_path)
  parameters_content = jsonencode({
    // Set value to value field.
    for key, value in each.value.arm_parameters :
    key => { "value" = value }
  })

  depends_on = [azurerm_logic_app_workflow.workflow]
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  for_each    = var.log_analytics_workspace_id == null ? {} : local.logic_app_instances
  resource_id = azurerm_logic_app_workflow.workflow[each.key].id
}

// Write logs and metrics to log analytics if specified
resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  for_each                   = var.log_analytics_workspace_id == null ? {} : local.logic_app_instances
  name                       = "diag-${each.key}"
  target_resource_id         = azurerm_logic_app_workflow.workflow[each.key].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  // TODO: not yet implemented by Azure
  // log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[each.key].log_category_types

    content {
      category = enabled_log.value

      retention_policy {
        enabled = false
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories[each.key].metrics

    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }
}
