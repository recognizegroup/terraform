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
  sku_name            = include.locals.env.service_plan_sku_name
  os_name             = include.locals.env.service_plan_os_name
  enable_autoscaling  = try(include.locals.env.service_plan_enable_autoscaling, false)
}
