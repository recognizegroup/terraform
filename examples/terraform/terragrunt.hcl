locals {
  env         = read_terragrunt_config("${get_parent_terragrunt_dir()}/environments/${get_env("ENVIRONMENT", "dev")}/env.hcl").locals
  globals     = read_terragrunt_config("${get_parent_terragrunt_dir()}/globals.hcl").locals
  module      = replace(path_relative_to_include(), "modules/", "")
  environment = get_env("ENVIRONMENT", "dev")
  client      = "contoso"
  workload    = "workload"
}

inputs = {
  location = local.globals.location
}

remote_state {
  backend = "azurerm"
  config = {
    key                  = "${local.module}/terraform.tfstate"
    container_name       = "tfstate"
    resource_group_name  = "rg-${local.client}-${local.workload}-tf-${local.environment}"
    storage_account_name = "st${local.client}${local.workload}tf${local.environment}"
  }
}
