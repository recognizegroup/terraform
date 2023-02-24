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
