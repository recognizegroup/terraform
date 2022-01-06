terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = "=2.88.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
  logic_app_instances = {for app in var.logic_app_instances: app.logic_app_name => app}
}

resource "azurerm_logic_app_workflow" "workflow" {
  for_each            = local.logic_app_instances
  name                = each.value.logic_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

// Deploy workflow as ARM template conditional when arm_template_path is specified
// To export the ARM template from the Azure portal go to Logic App > Automation > Export Template
resource "azurerm_resource_group_template_deployment" "workflow_deployment" {
  for_each            = var.arm_template_path == null ? {} : local.logic_app_instances
  name                = "${each.key}-deployment"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  template_content    = file(var.arm_template_path)
  parameters_content  = jsonencode({
    // Set value to value field.
    for key, value in each.value.arm_parameters :
    key => { "value" = value }
  })

  depends_on = [azurerm_logic_app_workflow.workflow]
}

// Write logs and metrics to log analytics if specified
resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  for_each                       = var.log_analytics_workspace_id == null ? {} : local.logic_app_instances
  name                           = "${each.key}-logs"
  target_resource_id             = azurerm_logic_app_workflow.workflow["${each.key}-deployment"].id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  log {
    category = "WorkflowRuntime"
    retention_policy {
      enabled = true
      days    = var.log_retention_days
    }
  }

  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = true
      days    = var.log_retention_days
    }
  }
}
