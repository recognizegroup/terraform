terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = "=3.25.0"
    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "archive" {
}

resource "azurerm_logic_app_standard" "app" {
  name                = var.logic_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  enabled             = var.enabled

  dynamic "identity" {
    for_each = var.use_managed_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  site_config {
    ftps_state                = "Disabled"
    elastic_instance_minimum  = var.elastic_instance_minimum
    pre_warmed_instance_count = var.pre_warmed_instance_count
  }

  app_settings = merge({
    WEBSITE_NODE_DEFAULT_VERSION = "~14",
    FUNCTIONS_WORKER_RUNTIME     = "node",
  }, var.app_settings)

  app_service_plan_id        = var.service_plan_id
  storage_account_access_key = var.storage_account_access_key
  storage_account_name       = var.storage_account_name
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  count          = var.integration_subnet_id == null ? 0 : 1
  app_service_id = azurerm_logic_app_standard.app.id
  subnet_id      = var.integration_subnet_id
}

# First, create a zip file containing the workflow
data "archive_file" "workflow" {
  type        = "zip"
  source_dir  = var.workflows_source_path
  output_path = "${path.module}/files/deploy.zip"
}

# After the logic app is created, start a deployment using the Azure CLI
# It is not possible to use a ZIP-deployment from blob storage, as it can not be updated from the portal

# The first step is to ensure that the logic apps extension is installed
resource "null_resource" "install-extension" {
  depends_on = [azurerm_logic_app_standard.app]

  triggers = {
    deploy = data.archive_file.workflow.output_sha
  }

  provisioner "local-exec" {
    command = "az extension add --name logic"
  }
}

# Fetch the subscription name
data "azurerm_subscription" "current" {}

# Then use the Azure CLI to start the deployment
resource "null_resource" "deploy" {
  depends_on = [null_resource.install-extension]

  triggers = {
    deploy = data.archive_file.workflow.output_sha
  }

  provisioner "local-exec" {
    command = "az logicapp deployment source config-zip --name ${var.logic_app_name} --resource-group ${var.resource_group_name} --subscription ${data.azurerm_subscription.current.display_name} --src ${data.archive_file.workflow.output_path}"
  }
}
