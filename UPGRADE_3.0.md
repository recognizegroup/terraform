# UPGRADE FROM 2.x to 3.0

## azure/subnet

Replace `enforce_private_link_endpoint_network_policies` variable with `private_endpoint_network_policies_enabled` variable.

Warning the value has to be inverted.

Before:
```hcl
inputs = {
  enforce_private_link_endpoint_network_policies = false
}
```

After:
```hcl
inputs = {
  private_endpoint_network_policies_enabled = true
}
```

## azure/monitoring

`azure/monitoring` has been split up in to `azure/azure/monitoring_action_group` and `azure/monitoring_log_analytics_alert`.

Before:

`monitoring/terragrunt.hcl`:
```hcl
terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//modules/azure/monitoring?ref=v2.7.0"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "resource_group" {
  config_path = "../resource_group"
}

dependency "log_analytics_workspace" {
  config_path = "../log_analytics_workspace"
}

inputs = {
  location                    = "westeurope"
  resource_group_name         = dependency.resource_group.outputs.name
  action_group_name           = "ag-example"
  action_group_short_name     = "agexample"
  action_group_email_receiver = "example@example.com"
  action_group_webhook_uri    = "example.com"
  monitoring_rules = [
    {
      name                    = "mon-frontdoor-statuscode-4xx-and-up-${include.locals.environment}"
      description             = "Alert when Front Door statuscode 400 or higher count crosses threshold"
      data_source_id          = dependency.log_analytics_workspace.outputs.id
      enabled                 = true
      severity                = 0 # Critical
      frequency               = 5
      time_window             = 5
      auto_mitigation_enabled = true
      operator                = "GreaterThanOrEqual"
      threshold               = 3
      query                   = <<-QUERY
        AzureDiagnostics
        | where OperationName == "Microsoft.Network/FrontDoor/AccessLog/Write"
        | where httpStatusCode_d >= 400
        | summarize count() by bin(TimeGenerated, 5m)
      QUERY
    }
  ]
}
```

After:

`monitoring_action_group/terragrunt.hcl`:
```hcl
terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//modules/azure/monitoring_action_group?ref=v3.0.0"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "resource_group" {
  config_path = "../resource_group"
}

inputs = {
  resource_group_name = dependency.resource_group.outputs.name
  name                = "ag-example"
  short_name          = "agexample"
  email_receivers     = ["example@example.com"]
  webhook_uris        = ["example.com"]
}
```

`monitoring_log_analytics_alert/terragrunt.hcl`:
```hcl
terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//modules/azure/monitoring_log_analytics_alert?ref=v3.0.0"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "resource_group" {
  config_path = "../resource_group"
}

dependency "log_analytics_workspace" {
  config_path = "../log_analytics_workspace"
}

dependency "monitoring_action_group" {
  config_path = "../monitoring_action_group"
}

inputs = {
  location            = "westeurope"
  resource_group_name = dependency.resource_group.outputs.name
  action_group_id     = dependency.monitoring_action_group.outputs.id

  monitoring_rules = [
    {
      name                    = "mon-frontdoor-statuscode-4xx-and-up-${include.locals.environment}"
      description             = "Alert when Front Door statuscode 400 or higher count crosses threshold"
      data_source_id          = dependency.log_analytics_workspace.outputs.id
      enabled                 = true
      severity                = 0 # Critical
      frequency               = 5
      time_window             = 5
      auto_mitigation_enabled = true
      operator                = "GreaterThanOrEqual"
      threshold               = 3
      query                   = <<-QUERY
        AzureDiagnostics
        | where OperationName == "Microsoft.Network/FrontDoor/AccessLog/Write"
        | where httpStatusCode_d >= 400
        | summarize count() by bin(TimeGenerated, 5m)
      QUERY
    }
  ]
}
```

## azure/app_service_plan to azure/service_plan

Before:
```hcl
terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//modules/azure/app_service_plan?ref=v2.7.0"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "resource_group" {
  config_path = "../resource_group"
}

inputs = {
  resource_group_name = dependency.resource_group.outputs.name
  name                = "asp-${include.locals.client}-${include.locals.workload}-${include.locals.environment}"
  tier                = "PremiumV2"
  size                = "P1v2"
  enable_autoscaling  = try(include.locals.env.app_service_plan_enable_autoscaling, false)
}
```

After:
```hcl
terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//modules/azure/service_plan?ref=v3.0.0"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "resource_group" {
  config_path = "../resource_group"
}

inputs = {
  resource_group_name = dependency.resource_group.outputs.name
  name                = "asp-${include.locals.client}-${include.locals.workload}-${include.locals.environment}"
  sku_name            = "P1v2"
  enable_autoscaling  = try(include.locals.env.app_service_plan_enable_autoscaling, false)
}
```

## azure/app_service to azure/web_app_linux

Before:
```hcl
terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//modules/azure/app_service?ref=v2.7.0"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "resource_group" {
  config_path = "../resource_group"
}

dependency "log_analytics_workspace" {
  config_path = "../log_analytics_workspace"
}

dependency "app_service_plan" {
  config_path = "../app_service_plan"
}

inputs = {
  resource_group_name        = dependency.resource_group.outputs.name
  app_service_plan_id        = dependency.app_service_plan.outputs.id
  name                       = "app-${include.locals.client}-${include.locals.workload}-${include.locals.environment}"
  log_analytics_workspace_id = dependency.log_analytics_workspace.outputs.id
  linux_fx_version           = "DOCKER|docker.io/swaggerapi/petstore"

  app_settings = {
    "WEBSITE_TIME_ZONE" = include.locals.globals.time_zone
    "SWAGGER_BASE_PATH" = "/v2"
  }
}
```

After:
```hcl
terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//modules/azure/web_app_linux?ref=v3.0.0"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "resource_group" {
  config_path = "../resource_group"
}

dependency "log_analytics_workspace" {
  config_path = "../log_analytics_workspace"
}

dependency "service_plan" {
  config_path = "../service_plan"
}

inputs = {
  resource_group_name        = dependency.resource_group.outputs.name
  service_plan_id            = dependency.service_plan.outputs.id
  name                       = "app-${include.locals.client}-${include.locals.workload}-${include.locals.environment}"
  log_analytics_workspace_id = dependency.log_analytics_workspace.outputs.id
  docker_image               = "docker.io/swaggerapi/petstore"
  docker_image_tag           = "latest"

  app_settings = {
    "WEBSITE_TIME_ZONE" = include.locals.globals.time_zone
    "SWAGGER_BASE_PATH" = "/v2"
  }
}
```
