# Terragrunt sample project

This Terragrunt sample project showcases a well-tailored structure that includes three layers of `.hcl` files. This setup means that configuration can be globally defined, environment-specific or module-specific.

* Keeps your terragrunt configuration DRY accross multiple environments.
* Enables you to re-use terraform modules defined in a central place.
* Makes module development and project deployment easy.
* Runs well in Github actions or other build pipelines.

## Frequently Asked Questions

- [When deploying this sample project, how does the remote state look like?](#faq1)
- [I am debugging my deployment; how to only deploy a single module without causing state conflicts?](#faq2)
- [How to deploy a resource in one environment, but prevent it from being deployed in another?](#faq3)
- [How does the Terragrunt configuration know in which environment to deploy my resources](#faq4)
- [Can I also use this project structure with Terraform Cloud?](#faq5)
- [I want to define a naming convention within my Terraform modules, how do I do this?](#faq6)
- [When developing new modules, how to specify a local module source?](#faq7)

---

###### <a name="faq1"></a> When deploying this sample project, how does the remote state look like?

Your remote state, in a storage container, will be empty before the very first deployment. After the first deployment, the storage container contains a directory structure that is equivalent to the `modules` directory, containing the state per module.

###### <a name="faq2"></a> I am debugging my deployment; how to only deploy a single module without causing state conflicts?

A little magic trick in the backend configuration allows you to deploy all modules from an environment with `terragrunt run-all apply`, while still being able to deploy modules separately with `terragrunt apply`. This little magic trick ensures that both commands will talk to the same remote state paths.

###### <a name="faq3"></a> How to deploy a resource in one environment, but prevent it from being deploy in another?

Sometimes environments are not exact mirrors of one another. For example, you only need resources in a test environment, that you don't want in production. Terragrunt offers the ability to skip deployment for a resource. This is done by including `skip = true` in the Terragrunt module configuration. You can read more about this feature [here](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#skip). Here is a short example:

```terraform
# ...

include {
  path   = find_in_parent_folders()
  expose = true
}

# Skip deployment based on a variable that is environment specific
skip = includes.locals.env.skip_log_analytics_workspace

inputs {
  foo = "bar"
}
```

###### <a name="faq4"></a> How does the Terragrunt configuration know in which environment to deploy my resources?

This is all done within the root `terragrunt.hcl` file, with a little help of a built-in function that reads environment variables: `get_env("ENVIRONMENT", "dev")`. By default you can deploy the development environment, so you don't have to set anything locally. Within your CI/CD pipeline, you can set this environment variable explicitly.

###### <a name="faq5"></a> Can I also use this project structure with Terraform Cloud?

This is not currently possible, because Terraform cloud uses workspaces which do not have a directory structure like storage containers.

###### <a name="faq6"></a> I want to define a naming convention within my Terraform modules, how do I do this?

Fortunately, Terraform itself has a nice feature that can validate input variables for a module. This feature is very flexible, allowing you to enforce naming conventions, restrict regions or locations and much more.

```terraform
variable "name" {
  type        = string
  description = "Name of a resource group."

  validation {
    condition     = substr(var.name, 0, 2) == "rg-"
    error_message = "Resource group name must start with 'rg-'".
  }
}
```

##### <a name="faq7"></a> When developing new modules, how to specify a local module source?

As you can read in the official [documentation](https://www.terraform.io/language/modules/sources), terraform modules can come from many places. When your Terraform modules are defined in a Github repository, I would recommend to check out that repository next to your project repository. This enables you to easily import those modules from a local path.

```bash
$HOME/git
│
└───terraform # Terraform module repository
│   │
│   └───modules
│       │
│       └─── module_a # Contains the module source code
│       │       main.tf
│       │       outputs.tf
│       │       variables.tf             
│       └─── ...
│
└───project-a # Some Terragrunt project repository
│   │
│   └───terraform
│       │   globals.hcl
│       │   terragrunt.hcl
│       │  
│       └───environments
│       │   └─── dev # Contains env.hcl environment configuration
│       │   └─── tst
│       │   └─── ...
│       │
│       └─── modules
│            └─── module_a # Contains terragrunt.hcl module configuration
│            └─── ...
│       
└───project-b # Another Terragrunt project repository
    │
    └─── ...
```

The above directory structure allows you to easily import a local Terraform module by going a few paths up from the root of the Terragrunt configuration.

```terraform
terraform {
  source = "../../../../terraform//modules/module_a"
}
```

## Github actions

This sample Terragrunt directory structure works well with Github actions or other build pipelines. The following Github actions workflow demonstrates the  deployments

```yaml
name: Deployment
on:
  push:
    branches:
      - feature/*
      - develop
      - release/*
      - main

jobs:
  environments:
    name: Get environment
    runs-on: ubuntu-latest
    steps:
      - run: echo "Setting $ENVIRONMENT.."
    outputs:
      environment: ${{ github.ref == 'refs/heads/main' && 'prd' || (startsWith(github.ref, 'refs/heads/release/') && 'acc' || github.ref == 'refs/heads/develop' && 'tst' || 'dev') }}

  infrastructure:
    name: Terraform
    runs-on: ubuntu-latest
    needs: [environments]
    environment: ${{ needs.environments.outputs.environment }}
    concurrency: ${{ needs.environments.outputs.environment }}
    env:
      ENVIRONMENT: ${{ needs.environments.outputs.environment }}
      ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
      ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
      ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
      ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
      TF_WORKING_DIR: terraform
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Setup
        run: brew install terragrunt
      - name: Apply
        run: |
          terragrunt run-all apply \
          --terragrunt-non-interactive
```
