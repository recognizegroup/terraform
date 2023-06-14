terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_application_insights" "application_insights" {
  location             = var.location
  resource_group_name  = var.resource_group_name
  name                 = var.name
  application_type     = var.application_type
  daily_data_cap_in_gb = var.daily_data_cap_in_gb
  retention_in_days    = var.retention_in_days
  sampling_percentage  = var.sampling_percentage
  workspace_id         = var.log_analytics_workspace_id
}
