terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }
}

resource "azurerm_servicebus_subscription" "service_bus_subscription" {
  name                                      = var.name
  topic_id                                  = var.topic_id
  max_delivery_count                        = var.max_delivery_count
  lock_duration                             = var.lock_duration
  requires_session                          = var.requires_session
  default_message_ttl                       = var.default_message_ttl
  dead_lettering_on_message_expiration      = var.dead_lettering_on_message_expiration
  dead_lettering_on_filter_evaluation_error = var.dead_lettering_on_filter_evaluation_error
  enable_batched_operations                 = var.enable_batched_operations
  auto_delete_on_idle                       = var.auto_delete_on_idle
  forward_to                                = var.forward_to
}

resource "azurerm_servicebus_subscription_rule" "sql_filter" {
  count           = var.sql_filter_query == null ? 0 : 1
  name            = "${var.name}-filter-sql"
  subscription_id = azurerm_servicebus_subscription.service_bus_subscription.id
  filter_type     = "SqlFilter"
  sql_filter      = var.sql_filter_query
}

resource "azurerm_servicebus_subscription_rule" "correlation_filter" {
  count           = var.correlation_filter == null ? 0 : 1
  name            = "${var.name}-filter-correlation"
  subscription_id = azurerm_servicebus_subscription.service_bus_subscription.id
  filter_type     = "CorrelationFilter"

  correlation_filter {
    correlation_id      = var.correlation_filter.id
    label               = var.correlation_filter.label
    content_type        = var.correlation_filter.content_type
    message_id          = var.correlation_filter.message_id
    reply_to            = var.correlation_filter.reply_to
    reply_to_session_id = var.correlation_filter.reply_to_session_id
    session_id          = var.correlation_filter.session_id
    to                  = var.correlation_filter.to
    properties          = var.correlation_filter.properties
  }
}
