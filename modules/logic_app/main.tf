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

resource "azurerm_logic_app_workflow" "workflow" {
  name                = var.logic_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

// Deploy workflow as ARM template conditional when arm_template_path is specified
// To export the ARM template from the Azure portal go to Logic App > Automation > Export Template
resource "azurerm_resource_group_template_deployment" "workflow_deployment" {
  count               = var.arm_template_path == null ? 0 : 1
  name                = "${var.logic_app_name}-deployment"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  template_content    = file(var.arm_template_path)
  parameters_content  = jsonencode(var.parameters_content)

  depends_on = [azurerm_logic_app_workflow.workflow]
}

// Write logs and metrics to log analytics if specified
resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                          = var.log_analytics_workspace_id == null ? 0 : 1
  name                           = "${var.logic_app_name}-logs"
  target_resource_id             = azurerm_logic_app_workflow.workflow.id
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
