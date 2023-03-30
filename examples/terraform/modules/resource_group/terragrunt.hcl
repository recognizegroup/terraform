terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//modules/azure/resource_group?ref=v3.0.0"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  name = "rg-${include.locals.client}-${include.locals.workload}-${include.locals.environment}"
}
