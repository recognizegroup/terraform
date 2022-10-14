# Terraform

This repository contains terraform modules which can be used in combination with [Terragrunt](https://terragrunt.gruntwork.io/). Terragrunt allows you to keep your Terraform backend configuration DRY (“Don’t Repeat Yourself”) by defining versioned modules once and reusing those modules inside terragrunt configuration files.

## Getting started

1. Create a `terragrunt.hcl` file:

```terraform
# Use Terragrunt to download the module code
terraform {
  source = "git::https://github.com/recognizegroup/terraform.git//path/to/module?ref=v1.0.0"
}

# Fill in the variables for that module
inputs = {
  foo = "bar"
  zot = 3
}
```

2. Make sure the source points to the correct module (i.e. path) and version (i.e. tag).
3. Assign all the exposed variables as input.
4. Run `terragrunt apply` to deploy the resource.

## Dependency management

Sometimes you happen to have dependencies between modules, but you don't want to put the configuration for multiple modules in one `terragrunt.hcl` file. On the other hand, you also don't want to declare variables twice. Luckily, dependency management is very simple in Terragrunt ([documentation](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency)). For example, an Azure event hub may need a storage account and container to write events to. In this case you specify the storage configuration as a dependency of the event hub configuration:

```terraform
# ...

dependency "storage" {
  config_path = "../storage"
}

inputs = {
  storage_account_name   = dependency.storage.outputs.storage_account_name
  storage_container_name = dependency.storage.outputs.storage_container_name
  event_hub_name         = "my-event-hub"
  # ...
}
```

## Authenticating to Azure

This repository mainly contains Terraform modules using the [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs). Terraform supports ways to authenticate to Azure. When working locally, it is recommended that you use the Azure cli to login with your user account.

```bash
az login [--tenant <id>]
az account set --subscription <name or id>
```

When automating deployments with a CI/CD pipeline, it is recommended that you use credentials from a service principal. When set as environment variables in your pipeline, Terraform will known how to authenticate to Azure.

```bash
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-000M0-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

## Creating remote backend

One of the great benefits of using Terragrunt, is that it will keep your remote state DRY. Terragrunt allows you to use variables, conditions and expressions when defining backends. This means you only have to specify your backend configuration once. Within Azure, storage containers are the place where remote state is stored. The following snippet allows you to rapidly setup backend storage containers for every environment in your project.

#### Linux/macOS

```bash
export SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export RESOURCE_GROUP_NAME="xxxxx"
export STORAGE_ACCOUNT_NAME="xxxxx"
export CONTAINER_NAME="tfstate"
export LOCATION="westeurope"

az account set --subscription $SUBSCRIPTION_ID

# Create resource group
az group create \
  --subscription $SUBSCRIPTION_ID \
  --name $RESOURCE_GROUP_NAME \
  --location $LOCATION \
  --tags 'CostCenter=XXXX' 'Environment=XXXX' 'Workload=XXXX'

# Create storage account
az storage account create \
  --subscription $SUBSCRIPTION_ID \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --location $LOCATION \
  --sku Standard_GRS \
  --encryption-services blob \
  --https-only true \
  --allow-blob-public-access false

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list \
  --subscription $SUBSCRIPTION_ID \
  --resource-group $RESOURCE_GROUP_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --query '[0].value' -o tsv)

# Create blob container
az storage container create \
  --subscription $SUBSCRIPTION_ID \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --account-key $ACCOUNT_KEY

# Lock storage account
az lock create \
  --name CanNotDelete \
  --lock-type CanNotDelete \
  --resource-group $RESOURCE_GROUP_NAME \
  --resource-name $STORAGE_ACCOUNT_NAME \
  --resource-type Microsoft.Storage/storageAccounts
```

#### Windows Powershell

```ps1
$env:SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
$env:RESOURCE_GROUP_NAME="xxxxx"
$env:STORAGE_ACCOUNT_NAME="xxxxx"
$env:CONTAINER_NAME="tfstate"
$env:LOCATION="westeurope"

az group create `
  --subscription $env:SUBSCRIPTION_ID `
  --name $env:RESOURCE_GROUP_NAME `
  --location $env:LOCATION `
  --tags 'CostCenter=XXXX' 'Environment=XXXX' 'Workload=XXXX'

az storage account create `
  --subscription $env:SUBSCRIPTION_ID `
  --name $env:STORAGE_ACCOUNT_NAME `
  --resource-group $env:RESOURCE_GROUP_NAME `
  --location $env:LOCATION `
  --sku Standard_GRS`
  --encryption-services blob `
  --https-only true `
  --allow-blob-public-access false

$output = az storage account keys list `
  --subscription $env:SUBSCRIPTION_ID `
  --resource-group $env:RESOURCE_GROUP_NAME `
  --account-name $env:STORAGE_ACCOUNT_NAME `
  --query '[0].value' `
  -o tsv

az storage container create `
  --subscription $env:SUBSCRIPTION_ID `
  --name $env:CONTAINER_NAME `
  --account-name $env:STORAGE_ACCOUNT_NAME `
  --account-key $output

az lock create `
  --name CanNotDelete `
  --lock-type CanNotDelete `
  --resource-group $env:RESOURCE_GROUP_NAME `
  --resource-name $env:STORAGE_ACCOUNT_NAME `
  --resource-type Microsoft.Storage/storageAccounts
```
