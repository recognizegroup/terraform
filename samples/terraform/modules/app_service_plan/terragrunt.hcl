terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//modules/app_service_plan?ref=v1.0.0"
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
  tier                = include.locals.env.app_service_plan_tier
  size                = include.locals.env.app_service_plan_size
  enable_autoscaling  = try(include.locals.env.app_service_plan_enable_autoscaling, false)
}
