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
  docker_image               = include.locals.env.docker_image
  docker_image_tag           = include.locals.env.docker_image_tag

  app_settings = {
    "WEBSITE_TIME_ZONE" = include.locals.globals.time_zone
    "SWAGGER_BASE_PATH" = "/v2"
  }
}
