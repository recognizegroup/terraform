terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = "=2.72.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "time_sleep" "role_assignment_sleep" {
  create_duration = "60s"

  triggers = {
    role_assignment = azurerm_role_assignment.role_assignment.id
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "filesystem" {
  name               = var.adls_filesystem_name
  storage_account_id = var.storage_account_id

  # When the ACL is written to Datalake, the service puts the entries in a standard order.
  # Reading back the ACL returns the values in the standard order/
  # By replicating that order here we avoid making updates to the permissions when not needed.
  #
  # The order seems to be:
  #  access scope comes before default
  #  then the order is user, group, mask, other
  #  then sorted by id (with blank first)
  #
  # https://github.com/hashicorp/terraform-provider-azurerm/issues/9728

  ace {
    permissions = "rwx"
    scope       = "access"
    type        = "user"
  }
  ace {
    permissions = "---"
    scope       = "access"
    type        = "group"
  }
  dynamic "ace" {
    for_each = {
      for index, permission in var.adls_root_permissions : index => permission
      if permission.scope == "access"
    }
    content {
      type        = ace.value.type
      scope       = ace.value.scope
      id          = ace.value.object_id
      permissions = ace.value.permissions
    }
  }
  ace {
    permissions = "rwx"
    scope       = "access"
    type        = "mask"
  }
  ace {
    permissions = "---"
    scope       = "access"
    type        = "other"
  }

  ace {
    permissions = "---"
    scope       = "default"
    type        = "user"
  }
  ace {
    permissions = "---"
    scope       = "default"
    type        = "group"
  }
  dynamic "ace" {
    for_each = {
      for index, permission in var.adls_root_permissions : index => permission
      if permission.scope == "default"
    }
    content {
      type        = ace.value.type
      scope       = ace.value.scope
      id          = ace.value.object_id
      permissions = ace.value.permissions
    }
  }
  ace {
    permissions = "rwx"
    scope       = "default"
    type        = "mask"
  }
  ace {
    permissions = "---"
    scope       = "default"
    type        = "other"
  }
}

resource "azurerm_storage_data_lake_gen2_path" "path" {
  for_each = {
    for index, path in var.adls_filesystem_paths :
    index => path
  }

  path               = each.value.path
  filesystem_name    = var.adls_filesystem_name
  storage_account_id = var.storage_account_id
  resource           = "directory"

  # When the ACL is written to Datalake, the service puts the entries in a standard order.
  # Reading back the ACL returns the values in the standard order/
  # By replicating that order here we avoid making updates to the permissions when not needed.
  #
  # The order seems to be:
  #  access scope comes before default
  #  then the order is user, group, mask, other
  #  then sorted by id (with blank first)
  #
  # https://github.com/hashicorp/terraform-provider-azurerm/issues/9728

  ace {
    permissions = "rwx"
    scope       = "access"
    type        = "user"
  }
  ace {
    permissions = "---"
    scope       = "access"
    type        = "group"
  }
  dynamic "ace" {
    for_each = [
      for permission in each.value.permissions : permission
      if permission.scope == "access"
    ]
    content {
      type        = ace.value.type
      scope       = ace.value.scope
      id          = ace.value.object_id
      permissions = ace.value.permissions
    }
  }
  ace {
    permissions = "rwx"
    scope       = "access"
    type        = "mask"
  }
  ace {
    permissions = "---"
    scope       = "access"
    type        = "other"
  }

  ace {
    permissions = "---"
    scope       = "default"
    type        = "user"
  }
  ace {
    permissions = "---"
    scope       = "default"
    type        = "group"
  }
  dynamic "ace" {
    for_each = [
      for permission in each.value.permissions : permission
      if permission.scope == "default"
    ]
    content {
      type        = ace.value.type
      scope       = ace.value.scope
      id          = ace.value.object_id
      permissions = ace.value.permissions
    }
  }
  ace {
    permissions = "rwx"
    scope       = "default"
    type        = "mask"
  }
  ace {
    permissions = "---"
    scope       = "default"
    type        = "other"
  }

  depends_on = [
    azurerm_role_assignment.role_assignment,
    time_sleep.role_assignment_sleep
  ]
}
