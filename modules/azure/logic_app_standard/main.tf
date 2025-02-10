terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.4"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.36"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
  identity_type     = var.use_managed_identity && length(var.identity_ids) > 0 ? "SystemAssigned, UserAssigned" : var.use_managed_identity ? "SystemAssigned" : length(var.identity_ids) > 0 ? "UserAssigned" : null
  is_linux          = length(regexall("/home/", lower(abspath(path.root)))) > 0
  identifiers       = var.managed_identity_provider != null ? concat(["api://${var.managed_identity_provider.create.application_name}"], var.managed_identity_provider.identifier_uris != null ? var.managed_identity_provider.identifier_uris : []) : []
  allowed_audiences = var.managed_identity_provider != null ? concat(local.identifiers, var.managed_identity_provider.allowed_audiences != null ? var.managed_identity_provider.allowed_audiences : []) : []
}

resource "azurerm_logic_app_standard" "app" {
  name                = var.logic_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  enabled             = var.enabled
  https_only          = var.https_only
  version             = var.logic_app_version

  dynamic "identity" {
    for_each = local.identity_type != null ? [1] : []
    content {
      type         = local.identity_type
      identity_ids = var.identity_ids
    }
  }

  site_config {
    ftps_state                = "Disabled"
    elastic_instance_minimum  = var.elastic_instance_minimum
    pre_warmed_instance_count = var.pre_warmed_instance_count

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions

      content {
        ip_address                = ip_restriction.value.ip_address
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
        name                      = ip_restriction.value.name
        priority                  = ip_restriction.value.priority
        action                    = ip_restriction.value.action

        dynamic "headers" {
          for_each = ip_restriction.value.headers

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }
  }

  app_settings = merge({
    WEBSITE_NODE_DEFAULT_VERSION             = "~18",
    FUNCTIONS_WORKER_RUNTIME                 = "node",
    MICROSOFT_PROVIDER_AUTHENTICATION_SECRET = var.managed_identity_provider == null ? azuread_application_password.password[0].value : null
  }, var.app_settings)

  app_service_plan_id        = var.service_plan_id
  storage_account_access_key = var.storage_account_access_key
  storage_account_name       = var.storage_account_name
  virtual_network_subnet_id  = var.integration_subnet_id
}

# Safest way is to always zip the file, even if there are no changes, it ensures that portal changes do not affect deployment results
resource "null_resource" "zip_logic_app" {
  triggers = {
    always_run = timestamp()
  }
  # if check.zip file changes, create deploy.zip file
  provisioner "local-exec" {
    interpreter = local.is_linux ? ["bash", "-c"] : ["PowerShell", "-Command"]
    command     = local.is_linux ? "cd ${path.module} && mkdir -p files && cd ${var.workflows_source_path} && zip -rq $OLDPWD/files/deploy.zip ." : "New-Item -Path \"${path.module}\" -Name \"files\" -ItemType \"directory\" -Force; Compress-Archive -Path \"${var.workflows_source_path}\\*\" -DestinationPath \"${path.module}\\files\\deploy.zip\" -Force"
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
}

# The first step is to ensure that the logic apps extension is installed
resource "null_resource" "install-extension" {
  depends_on = [time_sleep.wait_for_app_settings]

  provisioner "local-exec" {
    command = "az extension add --name logic"
  }
}

# Fetch the subscription name
data "azurerm_subscription" "current" {}

# Then use the Azure CLI to start the deployment
resource "null_resource" "deploy" {
  depends_on = [
    null_resource.install-extension,
    null_resource.zip_logic_app
  ]

  triggers = {
    always_run = timestamp() # null_resource.zip_logic_app might not always actually change, trigger ensures the execution anyway
  }

  provisioner "local-exec" {
    command = "az logicapp deployment source config-zip --name ${var.logic_app_name} --resource-group ${var.resource_group_name} --subscription ${data.azurerm_subscription.current.display_name} --src ${path.module}/files/deploy.zip"
  }
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  count       = var.log_analytics_workspace_id == null ? 0 : 1
  resource_id = azurerm_logic_app_standard.app.id
}

// Write logs and metrics to log analytics if specified
// Needs to be done once the deployment is finished, because updating Diagnostic Settings leads to a restart of the Logic App
// which causes the deployment to fail if it is not finished yet
resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  depends_on = [
    null_resource.deploy
  ]

  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.logic_app_name}"
  target_resource_id         = azurerm_logic_app_standard.app.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = length(var.log_analytics_diagnostic_categories) > 0 ? var.log_analytics_diagnostic_categories : data.azurerm_monitor_diagnostic_categories.diagnostic_categories[0].log_category_types

    content {
      category = enabled_log.value

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

# Managed Identity Provider
data "azuread_client_config" "current" {}

resource "random_uuid" "oath2_uuid" {}

resource "azuread_application" "application" {
  count            = var.managed_identity_provider != null ? 1 : 0
  display_name     = var.managed_identity_provider.create.display_name
  owners           = var.managed_identity_provider.create.owners != null ? concat([data.azuread_client_config.current.object_id], var.managed_identity_provider.create.owners) : [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = local.identifiers

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = var.managed_identity_provider.create.oauth2_settings.admin_consent_description
      admin_consent_display_name = var.managed_identity_provider.create.oauth2_settings.admin_consent_display_name
      enabled                    = var.managed_identity_provider.create.oauth2_settings.enabled
      id                         = random_uuid.oath2_uuid.result
      type                       = var.managed_identity_provider.create.oauth2_settings.type
      user_consent_description   = var.managed_identity_provider.create.oauth2_settings.user_consent_description
      user_consent_display_name  = var.managed_identity_provider.create.oauth2_settings.user_consent_display_name
      value                      = var.managed_identity_provider.create.oauth2_settings.role_value
    }
  }

  web {
    redirect_uris = ["https://${var.logic_app_name}.azurewebsites.net/.auth/login/aad/callback"]

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }
}

resource "null_resource" "always_run" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

resource "azapi_update_resource" "setup_auth_settings" {
  count       = var.managed_identity_provider != null ? 1 : 0
  type        = "Microsoft.Web/sites/config@2020-12-01"
  resource_id = "${azurerm_logic_app_standard.app.id}/config/web"

  depends_on = [
    azurerm_logic_app_standard.app,
    null_resource.always_run
  ]

  body = jsonencode({
    properties = {
      siteAuthSettingsV2 = {
        globalValidation = {
          excludedPaths          = []
          require_authentication = true,
          // Even though is looks weird, it is needed. Otherwise, the app and also the designer in Azure Portal are not working
          // https://techcommunity.microsoft.com/blog/integrationsonazureblog/trigger-workflows-in-standard-logic-apps-with-easy-auth/3207378
          unauthenticatedClientAction = "AllowAnonymous"
        },
        IdentityProviders = {
          azureActiveDirectory = {
            enabled = true,
            registration = {
              clientId                = azuread_application.application[0].application_id
              clientSecretSettingName = "MICROSOFT_PROVIDER_AUTHENTICATION_SECRET"
            },
            validation = {
              allowedAudiences = local.allowed_audiences
            }
          }
        }
      }
    }
  })
  lifecycle {
    /* This action should always be replaces since is works under the hood as an api call
    * So it does not really track issues with the function app properly
    */
    replace_triggered_by = [
      null_resource.always_run
    ]
  }
}

resource "azuread_application_password" "password" {
  count                 = var.managed_identity_provider != null ? 1 : 0
  application_object_id = azuread_application.application[0].object_id
}
