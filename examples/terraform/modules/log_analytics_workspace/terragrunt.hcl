terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//modules/log_analytics_workspace?ref=v3.0.0"
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
  name                = "log-${include.locals.client}-${include.locals.workload}-${include.locals.environment}"
  retention_in_days   = include.locals.env.log_analytics_retention_in_days
  daily_quota_gb      = include.locals.env.log_analytics_daily_quota_in_gb
}
