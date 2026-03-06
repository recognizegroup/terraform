terraform {
  required_version = "~> 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_linux_web_app" "web_app" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
  https_only          = true

  site_config {
    always_on              = var.always_on
    websockets_enabled     = var.websockets_enabled
    health_check_path      = var.health_check_path
    use_32_bit_worker      = var.use_32_bit_worker
    ftps_state             = var.ftps_state
    http2_enabled          = true
    minimum_tls_version    = 1.2
    vnet_route_all_enabled = var.vnet_route_all_enabled

    application_stack {
      dotnet_version      = var.dotnet_version
      docker_image_name   = var.docker_image_name
      docker_registry_url = var.docker_registry_url
      docker_image        = var.docker_image
      docker_image_tag    = var.docker_image_tag
    }

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions
      content {
        action     = ip_restriction.value.action
        ip_address = ip_restriction.value.ip_address
        name       = ip_restriction.value.name
        priority   = ip_restriction.value.priority
      }
    }
  }

  app_settings = var.app_settings

  identity {
    type = "SystemAssigned"
  }

  // Configures a mountpoint to a storage container (ro) or file share (rw)
  // Read more: https://docs.microsoft.com/en-us/azure/app-service/configure-connect-to-azure-storage
  dynamic "storage_account" {
    for_each = var.storage_mount == null ? [] : [1]
    content {
      name         = var.storage_mount.name
      type         = var.storage_mount.type
      account_name = var.storage_mount.account_name
      access_key   = var.storage_mount.access_key
      share_name   = var.storage_mount.share_name
      mount_path   = var.storage_mount.mount_path
    }
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to virtual_network_subnet_id, because we use `app_service_virtual_network_swift_connection`
      # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#virtual_network_subnet_id
      virtual_network_subnet_id,
    ]
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  count          = var.integration_subnet_id == null ? 0 : 1
  app_service_id = azurerm_linux_web_app.web_app.id
  subnet_id      = var.integration_subnet_id
}

resource "azurerm_private_endpoint" "private_endpoint" {
  count               = var.private_subnet_id == null ? 0 : 1
  name                = "pe-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id

  private_service_connection {
    name                           = "psc-${var.name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_linux_web_app.web_app.id
    subresource_names              = ["sites"]
  }

  # Should be deployed by Azure policy
  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

resource "azurerm_app_service_custom_hostname_binding" "custom_domain" {
  for_each            = var.custom_domains
  hostname            = each.value
  app_service_name    = azurerm_linux_web_app.web_app.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_app_service_managed_certificate" "custom_hostname_certificate" {
  for_each                   = azurerm_app_service_custom_hostname_binding.custom_domain
  custom_hostname_binding_id = each.value.id
}

resource "azurerm_app_service_certificate_binding" "custom_hostname_certificate_binding" {
  for_each            = azurerm_app_service_custom_hostname_binding.custom_domain
  hostname_binding_id = each.value.id
  certificate_id      = azurerm_app_service_managed_certificate.custom_hostname_certificate[each.key].id
  ssl_state           = "SniEnabled"
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_linux_web_app.web_app.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  // TODO: not yet implemented by Azure
  // log_analytics_destination_type = "Dedicated"

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
