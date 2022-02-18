terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//modules/app_service_public?ref=v1.0.0"
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
  resource_group_name        = dependency.resource_group.outputs.name
  app_service_plan_id        = dependency.app_service_plan.outputs.id
  name                       = "app-${include.locals.client}-${include.locals.workload}-${include.locals.environment}"
  log_analytics_workspace_id = dependency.log_analytics_workspace.outputs.id
  linux_fx_version           = "DOCKER|${include.locals.env.docker_container_name}"
  app_settings = {
    "WEBSITE_TIME_ZONE" = include.locals.globals.time_zone
    "SWAGGER_BASE_PATH" = "/v2"
  }
}
