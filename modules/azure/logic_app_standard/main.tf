terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.3"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "archive" {
}

locals {
  is_linux = length(regexall("/home/", lower(abspath(path.root)))) > 0
}

resource "azurerm_logic_app_standard" "app" {
  name                = var.logic_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  enabled             = var.enabled
  https_only          = var.https_only
  version             = var.logic_app_version

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
    WEBSITE_NODE_DEFAULT_VERSION = "~18",
    FUNCTIONS_WORKER_RUNTIME     = "node",
  }, var.app_settings)

  app_service_plan_id        = var.service_plan_id
  storage_account_access_key = var.storage_account_access_key
  storage_account_name       = var.storage_account_name
  virtual_network_subnet_id  = var.integration_subnet_id
}

# First, create a check.zip with archive_file to check diffs (this step is required)
# replacing this step by checking of deploy.zip created by local-exec doesn't work
# because local-exec is not executed during 'plan' so it would take old deploy.zip
data "archive_file" "check_zip" {
  type        = "zip"
  source_dir  = var.workflows_source_path
  output_path = "${path.module}/files/check.zip"
}

resource "null_resource" "zip_logic_app" {
  depends_on = [data.archive_file.check_zip]

  triggers = {
    deploy = data.archive_file.check_zip.output_sha
  }
  # if check.zip file changes, create deploy.zip file
  provisioner "local-exec" {
    interpreter = local.is_linux ? ["bash", "-c"] : ["PowerShell", "-Command"]
    command = local.is_linux ? "cd ${path.module} && mkdir -p files && cd files && cd ${var.workflows_source_path} && zip -rq $OLDPWD/deploy.zip ." : "New-Item -Path \"${path.module}\" -Name \"files\" -ItemType \"directory\" -Force; Compress-Archive -Path \"${var.workflows_source_path}\\*\" -DestinationPath \"${path.module}\\files\\deploy.zip\""
  }
}

# After the logic app is created, start a deployment using the Azure CLI
# It is not possible to use a ZIP-deployment from blob storage, as it can not be updated from the portal

# When you add parameters to your logic app using the parameters.json file, and you reference an app setting
# the file will not be accepted if the app setting does not exist. However, there is a small delay between
# updating the logic app and the app settings being available. Therefore, we need to add a timeout to the
# deployment to make sure the app settings are available before the deployment is started.

resource "time_sleep" "wait_for_app_settings" {
  depends_on = [
    azurerm_logic_app_standard.app,
    null_resource.zip_logic_app
  ]
  create_duration = "${var.deployment_wait_timeout}s"

  triggers = {
    deploy = data.archive_file.check_zip.output_sha
  }
}

# The first step is to ensure that the logic apps extension is installed
resource "null_resource" "install-extension" {
  depends_on = [time_sleep.wait_for_app_settings]

  triggers = {
    deploy = data.archive_file.check_zip.output_sha
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
    deploy = data.archive_file.check_zip.output_sha
  }

  provisioner "local-exec" {
    command = "az logicapp deployment source config-zip --name ${var.logic_app_name} --resource-group ${var.resource_group_name} --subscription ${data.azurerm_subscription.current.display_name} --src ${path.module}/files/deploy.zip"
  }
}
