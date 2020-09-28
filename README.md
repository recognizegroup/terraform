# terraform

This repository contains terraform modules which can be used in combination with [Terragrunt](https://terragrunt.gruntwork.io/). Terragrunt allows you to keep your Terraform backend configuration DRY (“Don’t Repeat Yourself”) by defining versioned modules once and reusing those modules inside terragrunt configuration files.

### Usage

1. Create a terragrunt.hcl file:

```terraform
# Use Terragrunt to download the module code
terraform {
  source = "git::https://github.com/vwt-digital/terraform.git//path/to/module?ref=v0.0.1"
}

# Fill in the variables for that module
inputs = {
  foo = "bar"
  baz = 3
}
```

2. Make sure the source points to the correct module (i.e. path) and version (i.e. tag).
3. Assign all the exposed variables as input.
4. Run `terragrunt apply`.

### Dependency management

Sometimes you happen to have dependencies between modules, but you don't want to put the configuration for multiple modules in one `terragrunt.hcl` file. On the other hand, you also don't want to declare variables twice. Luckily, dependency management is very simple in Terragrunt ([documentation](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency)). For example, an Azure event hub may need a storage account and container to write events to. In this case you need to specify that the storage configuration is a dependency of the event hub configuration. You can do this as follows:

```terraform
dependency "storage" {
  config_path = "../data-lake-storage"
}

inputs = {
  storage_account_name   = dependency.storage.outputs.storage_account_name
  storage_container_name = dependency.storage.outputs.storage_container_name
  event_hub_name         = "my-event-hub"
}
```
