# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Common Changelog](https://common-changelog.org),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2023-01-12

_If you are upgrading: please see [UPGRADE_3.0.md](UPGRADE_3.0.md)._

### Changed

- **Breaking:** Bump minimum version of terraform to `~> 1.3` ([#264](https://github.com/recognizegroup/terraform/pull/264)) ([`b01fac27`](https://github.com/recognizegroup/terraform/commit/b01fac27))
- **Breaking:** Bump provider `hashicorp/azurerm` from all different versions to `~> 3.40` ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`3620b4bb`](https://github.com/recognizegroup/terraform/commit/3620b4bb))
- **Breaking:** Bump provider `cloudflare/cloudflare` from `~> 3.14.0` to `~> 4.0` ([#270](https://github.com/recognizegroup/terraform/pull/270)) ([`a643f228`](https://github.com/recognizegroup/terraform/commit/a643f228))
- **Breaking:** `azure/storage_share`: Remove default of variable `quota`, variable is now required ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`84c2448b`](https://github.com/recognizegroup/terraform/commit/84c2448b))
- **Breaking:** `azure/subnet`: Change type of variable `service_endpoints` from `list` to `set(string)` ([#257](https://github.com/recognizegroup/terraform/pull/257)) ([`f3e9d233`](https://github.com/recognizegroup/terraform/commit/f3e9d233))
- **Breaking:** `azure/api_connectors/service_bus_managed_identity`: Add required variable `location` ([#269](https://github.com/recognizegroup/terraform/pull/269)) ([`d9243eba`](https://github.com/recognizegroup/terraform/commit/d9243eba), [`123fbee4`](https://github.com/recognizegroup/terraform/commit/123fbee4), [`724a0910`](https://github.com/recognizegroup/terraform/commit/724a0910))
- `azure/log_analytics_workspace`: Change default of variable `sku` from `pergb2018` to `PerGB2018` ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`84c2448b`](https://github.com/recognizegroup/terraform/commit/84c2448b))
- `azure/function_app_linux`: Change default of variable `runtime_version` from `~3` to `~4` ([#259](https://github.com/recognizegroup/terraform/pull/259)) ([`b3edd9e7`](https://github.com/recognizegroup/terraform/commit/b3edd9e7))
- `azure/function_app_linux_managed_identity`: Change default of variable `runtime_version` from `~3` to `~4` ([#259](https://github.com/recognizegroup/terraform/pull/259)) ([`b3edd9e7`](https://github.com/recognizegroup/terraform/commit/b3edd9e7))
- `azure/function_app_windows`: Change default of variable `runtime_version` from `~3` to `~4` ([#259](https://github.com/recognizegroup/terraform/pull/259)) ([`b3edd9e7`](https://github.com/recognizegroup/terraform/commit/b3edd9e7))
- `azure/api_management_custom_domains`: Add `default_ssl_binding` option to `custom_domains` variable ([#260](https://github.com/recognizegroup/terraform/pull/260)) ([`d44ab78d`](https://github.com/recognizegroup/terraform/commit/d44ab78d))

### Added

- Add terraform linter ([#263](https://github.com/recognizegroup/terraform/pull/263)) ([`b70b7689`](https://github.com/recognizegroup/terraform/commit/b70b7689))
- Add module `azure/mysql_flexible_server` ([#258](https://github.com/recognizegroup/terraform/pull/258)) ([`46bcaf56`](https://github.com/recognizegroup/terraform/commit/46bcaf56), [`66c62906`](https://github.com/recognizegroup/terraform/commit/66c62906))
- Add module `azure/api_management_custom_domains_simple` ([#260](https://github.com/recognizegroup/terraform/pull/260)) ([`d44ab78d`](https://github.com/recognizegroup/terraform/commit/d44ab78d))
- Add module `azure/application_insights_workbook` ([#262](https://github.com/recognizegroup/terraform/pull/262), [#263](https://github.com/recognizegroup/terraform/pull/263)) ([`93b1f1d7`](https://github.com/recognizegroup/terraform/commit/93b1f1d7), [`b70b7689`](https://github.com/recognizegroup/terraform/commit/b70b7689))
- `azure/subnet`: Add variable `private_endpoint_network_policies_enabled` ([#265](https://github.com/recognizegroup/terraform/pull/265)) ([`b26228b4`](https://github.com/recognizegroup/terraform/commit/b26228b4))
- Add module `azure/monitoring_action_group` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1), [`a1e363a6`](https://github.com/recognizegroup/terraform/commit/a1e363a6))
- Add module `azure/monitoring_log_analytics_alert` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1))
- Add module `azure/monitoring_metric_alert` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1))

### Removed

- **Breaking:** Remove deprecated module `azure/key_vault_cetificate`, replace with `azure/key_vault_certificate` ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`d1574f22`](https://github.com/recognizegroup/terraform/commit/d1574f22))
- **Breaking:** Remove module `azure/storage_container_nfsv3`, already exists as `azure/data_lake_filesystem` module ([#257](https://github.com/recognizegroup/terraform/pull/257)) ([`a1d585f3`](https://github.com/recognizegroup/terraform/commit/a1d585f3))
- **Breaking:** Remove module `azure/log_analytics_workbook`, replace with `azure/application_insights_workbook` ([#262](https://github.com/recognizegroup/terraform/pull/262), [#263](https://github.com/recognizegroup/terraform/pull/263)) ([`93b1f1d7`](https://github.com/recognizegroup/terraform/commit/93b1f1d7), [`b70b7689`](https://github.com/recognizegroup/terraform/commit/b70b7689))
- **Breaking:** Remove module `azure/integration_service_environment` ([#263](https://github.com/recognizegroup/terraform/pull/263)) ([`016125f6`](https://github.com/recognizegroup/terraform/commit/016125f6)). Resource is deprecated ([source](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/integration_service_environment)).
- **Breaking:** `azure/subnet`: Remove variable `enforce_private_link_endpoint_network_policies`, replace with `private_endpoint_network_policies_enabled` ([#265](https://github.com/recognizegroup/terraform/pull/265)) ([`b26228b4`](https://github.com/recognizegroup/terraform/commit/b26228b4))
- **Breaking:** Remove module `azure/monitoring`, replace with `azure/azure/monitoring_action_group` and `azure/monitoring_log_analytics_alert` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1))

[3.0.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.0.0
