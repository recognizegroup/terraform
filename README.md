# Terraform

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
  config_path = "../storage"
}

inputs = {
  storage_account_name   = dependency.storage.outputs.storage_account_name
  storage_container_name = dependency.storage.outputs.storage_container_name
  event_hub_name         = "my-event-hub"
  ...
}
```

### Azure authentication

Terraform provides different ways to authenticate to Azure. When working locally, it is recommended that you use the Azure cli to login with your user account.
After the authentication succeeds, you should always set the subscription you want to deploy to. Optionally, when working in a tenant with a guest account, you need to pass the tenant ID when you log in. By default az login authenticates with your own tenant.

```bash
az login [-t tenant]
az account set --subscription <name or id>
```

When automating deployments from a CI/CD pipeline, it is recommended that you use environment variables to authenticate. Setting environment variables always prevails logging into the Azure cli.

```bash
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-000M0-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

### Terraform state storage
#### Linux
```bash
export SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export RESOURCE_GROUP_NAME="xxxxx"
export STORAGE_ACCOUNT_NAME="xxxxx"
export CONTAINER_NAME="xxxxx"
export LOCATION="westeurope"

az account set --subscription $SUBSCRIPTION_ID

# Create resource group
az group create \
  --name $RESOURCE_GROUP_NAME \
  --location $LOCATION

# Create storage account
az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --location $LOCATION \
  --sku Standard_LRS \
  --encryption-services blob \
  --https-only true \
  --allow-blob-public-access false

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --query '[0].value' -o tsv)

# Create blob container
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --account-key $ACCOUNT_KEY
```

#### Windows

Powershell script:

```bash
$env:SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000" 
$env:RESOURCE_GROUP_NAME="xxxxx"
$env:STORAGE_NAME="xxxxx"
$env:CONTAINER_NAME="xxxxx"
$env:LOCATION="westeurope"
 az group create  `
  --name $env:RESOURCE_GROUP_NAME  `
  --location $env:LOCATION 

 az storage account create  `
  --name $env:STORAGE_NAME  `
  --resource-group $env:RESOURCE_GROUP_NAME  `
  --location $env:LOCATION  `
  --sku Standard_LRS  `
  --encryption-services blob  `
  --https-only true  `
  --allow-blob-public-access false

 $output = az storage account keys list  `
  --resource-group $env:RESOURCE_GROUP_NAME  `
  --account-name $env:STORAGE_NAME  `
  --query '[0].value'  `
  -o tsv
 
 az storage container create  `
  --name $env:CONTAINER_NAME  `
  --account-name $env:STORAGE_NAME  `
  --account-key $ACCOUNT_KEY $output
```
