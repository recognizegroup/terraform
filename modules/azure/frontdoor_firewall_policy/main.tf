terraform {
  required_version = ">=1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_frontdoor_firewall_policy" "firewall_policy" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  enabled                           = var.enabled
  mode                              = var.mode
  redirect_url                      = var.redirect_url
  custom_block_response_status_code = var.custom_block_response_status_code
  custom_block_response_body        = var.custom_block_response_body

  dynamic "custom_rule" {
    for_each = {
      for rule in var.custom_rules :
      rule.name => rule
    }
    iterator = rule

    content {
      name                           = rule.value.name
      action                         = rule.value.action
      enabled                        = rule.value.enabled
      priority                       = rule.value.priority
      type                           = rule.value.type
      rate_limit_duration_in_minutes = rule.value.rate_limit_duration_in_minutes
      rate_limit_threshold           = rule.value.rate_limit_threshold

      dynamic "match_condition" {
        for_each = {
          for index, condition in rule.value.match_conditions :
          index => condition
        }
        iterator = condition

        content {
          match_variable     = condition.value.match_variable
          match_values       = condition.value.match_values
          operator           = condition.value.operator
          selector           = condition.value.selector
          negation_condition = condition.value.negation_condition
          transforms         = condition.value.transforms
        }
      }
    }
  }

  dynamic "managed_rule" {
    for_each = {
      for rule in var.managed_rules :
      rule.name => rule
    }
    iterator = rule

    content {
      type    = rule.value.type
      version = rule.value.version

      # Managed rule exclusions
      dynamic "exclusion" {
        for_each = {
          for index, exclusion in rule.value.exclusions :
          index => exclusion
        }

        content {
          match_variable = exclusion.value.match_variable
          operator       = exclusion.value.operator
          selector       = exclusion.value.selector
        }
      }

      # Managed rule overrides
      dynamic "override" {
        for_each = {
          for index, override in rule.value.overrides :
          index => override
        }

        content {
          rule_group_name = override.value.rule_group_name

          # Managed rule overrides exclusions
          dynamic "exclusion" {
            for_each = {
              for index, exclusion in override.value.exclusions :
              index => exclusion
            }
            iterator = override_exclusion

            content {
              match_variable = override_exclusion.value.match_variable
              operator       = override_exclusion.value.operator
              selector       = override_exclusion.value.selector
            }
          }

          # Managed rule overrides rules
          dynamic "rule" {
            for_each = {
              for rule in override.value.rules :
              rule.rule_id => rule
            }

            content {
              rule_id = rule.value.rule_id
              action  = rule.value.action
              enabled = rule.value.enabled

              # Managed rule overrides rules exlusions
              dynamic "exclusion" {
                for_each = {
                  for index, exclusion in rule.value.exclusions :
                  index => exclusion
                }
                iterator = rule_exclusion

                content {
                  match_variable = rule_exclusion.value.match_variable
                  operator       = rule_exclusion.value.operator
                  selector       = rule_exclusion.value.selector
                }
              }
            }
          }
        }
      }
    }
  }
}
