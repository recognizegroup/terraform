# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Common Changelog](https://common-changelog.org),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.3.0] - 2023-05-15

### Changed

- `azure/mysql_flexible_server`: Change default of variable `backup_retention_days` from `7` to `30` ([#313](https://github.com/recognizegroup/terraform/pull/313)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489))

### Added

- `azure/service_plan`: Add variable `scaling_rules` ([#309](https://github.com/recognizegroup/terraform/pull/309), [#312](https://github.com/recognizegroup/terraform/pull/312)) ([`fd0039e3`](https://github.com/recognizegroup/terraform/commit/fd0039e3), [`4fdb7698`](https://github.com/recognizegroup/terraform/commit/4fdb7698))
- `azure/storage_account_public`: Add variable `auto_delete_rules` ([#310](https://github.com/recognizegroup/terraform/pull/310)) ([`d0eb9139`](https://github.com/recognizegroup/terraform/commit/d0eb9139))
- `azure/api_management_api`: Add variable `custom_backend_policy` ([#311](https://github.com/recognizegroup/terraform/pull/311), [#314](https://github.com/recognizegroup/terraform/pull/314)) ([`37b46fd7`](https://github.com/recognizegroup/terraform/commit/37b46fd7), [`385a1af1`](https://github.com/recognizegroup/terraform/commit/385a1af1))
- Add module `azure/mysql_flexible_server_public` ([#313](https://github.com/recognizegroup/terraform/pull/313), [#320](https://github.com/recognizegroup/terraform/pull/320)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489), [`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d))
- Add module `azure/postgresql_public` ([#313](https://github.com/recognizegroup/terraform/pull/313), [#320](https://github.com/recognizegroup/terraform/pull/320)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489), [`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d))
- Add module `kubernetes/configmap` ([#313](https://github.com/recognizegroup/terraform/pull/313)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489))
- Add module `kubernetes/deployment_with_service` ([#313](https://github.com/recognizegroup/terraform/pull/313), [#321](https://github.com/recognizegroup/terraform/pull/321)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489), [`383bdda5`](https://github.com/recognizegroup/terraform/commit/383bdda5))
- Add module `kubernetes/ingress` ([#313](https://github.com/recognizegroup/terraform/pull/313)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489))
- Add module `kubernetes/pvc` ([#313](https://github.com/recognizegroup/terraform/pull/313)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489))
- Add module `kubernetes/secret` ([#313](https://github.com/recognizegroup/terraform/pull/313)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489))
- `azure/logic_app_standard`: Add variable `identity_ids` ([#317](https://github.com/recognizegroup/terraform/pull/317)) ([`ab4272ad`](https://github.com/recognizegroup/terraform/commit/ab4272ad), [`b6d06c84`](https://github.com/recognizegroup/terraform/commit/b6d06c84))
- `other/password_generator`: Add variables `min_lower`, `min_upper`, `min_numeric`, `min_special` ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d), [`bd78f656`](https://github.com/recognizegroup/terraform/commit/bd78f656))

### Fixed

- `azure/logic_app_standard`: Fix deployment bug caused by [hashicorp/terraform-provider-archive#40](https://github.com/hashicorp/terraform-provider-archive/issues/40) ([#316](https://github.com/recognizegroup/terraform/pull/316)) ([`cdae9fcb`](https://github.com/recognizegroup/terraform/commit/cdae9fcb))
- `azure/mssql`: Fix bug where random_password could generate a password with only one type of character be it lowercase, uppercase, numeric or special ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d))
- `azure/mysql`: Fix bug where random_password could generate a password with only one type of character be it lowercase, uppercase, numeric or special ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d))
- `azure/mysql_flexible_server`: Fix bug where random_password could generate a password with only one type of character be it lowercase, uppercase, numeric or special ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d))
- `azure/postgresql`: Fix bug where random_password could generate a password with only one type of character be it lowercase, uppercase, numeric or special ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d))
- `azure/synapse_workspace`: Fix bug where random_password could generate a password with only one type of character be it lowercase, uppercase, numeric or special ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d))

## [3.2.0] - 2023-04-11

### Changed

- `azure/service_bus_subscription`: Change default of variable `lock_duration` from `P0DT0H1M0S` to `PT1M` ([#304](https://github.com/recognizegroup/terraform/pull/304)) ([`3b50ca39`](https://github.com/recognizegroup/terraform/commit/3b50ca39))

### Added

- `azure/function_app_linux`: Add variable `use_32_bit_worker` ([#305](https://github.com/recognizegroup/terraform/pull/305)) ([`1cf8b62b`](https://github.com/recognizegroup/terraform/commit/1cf8b62b))
- `azure/function_app_linux_managed_identity`: Add variable `use_32_bit_worker` ([#305](https://github.com/recognizegroup/terraform/pull/305)) ([`1cf8b62b`](https://github.com/recognizegroup/terraform/commit/1cf8b62b))
- `azure/function_app_windows`: Add variable `use_32_bit_worker` ([#305](https://github.com/recognizegroup/terraform/pull/305)) ([`1cf8b62b`](https://github.com/recognizegroup/terraform/commit/1cf8b62b))

## [3.1.0] - 2023-04-05

### Added

- Add module `azure/application_performance_workbook` ([#300](https://github.com/recognizegroup/terraform/pull/300)) ([`7b0c705e`](https://github.com/recognizegroup/terraform/commit/7b0c705e))
- `azure/application_role_assignment`: Add variable `use_existing_service_principal` ([#299](https://github.com/recognizegroup/terraform/pull/299)) ([`4a0673f9`](https://github.com/recognizegroup/terraform/commit/4a0673f9))

## [3.0.0] - 2023-03-30

_If you are upgrading: please see [UPGRADE_3.0.md](UPGRADE_3.0.md)._

### Changed

- **Breaking:** Bump minimum version of terraform to `~> 1.3` ([#264](https://github.com/recognizegroup/terraform/pull/264)) ([`b01fac27`](https://github.com/recognizegroup/terraform/commit/b01fac27))
- **Breaking:** Bump provider `hashicorp/azurerm` from all different versions to `~> 3.48` ([#249](https://github.com/recognizegroup/terraform/pull/249), [#290](https://github.com/recognizegroup/terraform/pull/290)) ([`3620b4bb`](https://github.com/recognizegroup/terraform/commit/3620b4bb), [`d1e8281a`](https://github.com/recognizegroup/terraform/commit/d1e8281a))
- **Breaking:** Bump provider `cloudflare/cloudflare` from `~> 3.14.0` to `~> 4.0` ([#270](https://github.com/recognizegroup/terraform/pull/270)) ([`a643f228`](https://github.com/recognizegroup/terraform/commit/a643f228))
- **Breaking:** `azure/storage_share`: Remove default of variable `quota`, variable is now required ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`84c2448b`](https://github.com/recognizegroup/terraform/commit/84c2448b))
- **Breaking:** `azure/subnet`: Change type of variable `service_endpoints` from `list` to `set(string)` ([#257](https://github.com/recognizegroup/terraform/pull/257)) ([`f3e9d233`](https://github.com/recognizegroup/terraform/commit/f3e9d233))
- **Breaking:** `azure/api_connectors/service_bus_managed_identity`: Add required variable `location` ([#269](https://github.com/recognizegroup/terraform/pull/269)) ([`d9243eba`](https://github.com/recognizegroup/terraform/commit/d9243eba), [`123fbee4`](https://github.com/recognizegroup/terraform/commit/123fbee4), [`724a0910`](https://github.com/recognizegroup/terraform/commit/724a0910))
- **Breaking:** `azure/function_app_linux`: Rename variable from `app_service_plan_id` to `service_plan_id` ([#282](https://github.com/recognizegroup/terraform/pull/282)) ([`14e2c94`](https://github.com/recognizegroup/terraform/commit/14e2c94))
- **Breaking:** `azure/function_app_linux_managed_identity`: Rename variable from `app_service_plan_id` to `service_plan_id` ([#282](https://github.com/recognizegroup/terraform/pull/282)) ([`14e2c94`](https://github.com/recognizegroup/terraform/commit/14e2c94))
- **Breaking:** `azure/function_app_windows`: Rename variable from `app_service_plan_id` to `service_plan_id` ([#282](https://github.com/recognizegroup/terraform/pull/282)) ([`14e2c94`](https://github.com/recognizegroup/terraform/commit/14e2c94))
- **Breaking:** `azure/virtual_network`: Change type of variable `address_space` from `list` to `list(string)` ([#263](https://github.com/recognizegroup/terraform/pull/263)) ([`baf86211`](https://github.com/recognizegroup/terraform/commit/baf86211))
- **Breaking:** `azure/function_app_linux`: Rename variable from `ip_restriction` to `ip_restrictions` ([#296](https://github.com/recognizegroup/terraform/pull/296)) ([`e60e867a`](https://github.com/recognizegroup/terraform/commit/e60e867a))
- **Breaking:** `azure/function_app_linux_managed_identity`: Rename variable from `ip_restriction` to `ip_restrictions` ([#296](https://github.com/recognizegroup/terraform/pull/296)) ([`e60e867a`](https://github.com/recognizegroup/terraform/commit/e60e867a))
- **Breaking:** `azure/function_app_windows`: Rename variable from `ip_restriction` to `ip_restrictions` ([#296](https://github.com/recognizegroup/terraform/pull/296)) ([`e60e867a`](https://github.com/recognizegroup/terraform/commit/e60e867a))
- Bump provider `hashicorp/azuread` from `2.22.0` to `~> 2.36` ([#257](https://github.com/recognizegroup/terraform/pull/257), [#290](https://github.com/recognizegroup/terraform/pull/290)) ([`f3e9d233`](https://github.com/recognizegroup/terraform/commit/f3e9d233), [`d1e8281a`](https://github.com/recognizegroup/terraform/commit/d1e8281a))
- Bump provider `Azure/azapi` from `1.0.0` to `~> 1.4` ([#257](https://github.com/recognizegroup/terraform/pull/257), [#290](https://github.com/recognizegroup/terraform/pull/290)) ([`f3e9d233`](https://github.com/recognizegroup/terraform/commit/f3e9d233), [`d1e8281a`](https://github.com/recognizegroup/terraform/commit/d1e8281a))
- Bump provider `hashicorp/archive` from `2.2.0` to `~> 2.3` ([#285](https://github.com/recognizegroup/terraform/pull/285)) ([`eefff320`](https://github.com/recognizegroup/terraform/commit/eefff320))
- `azure/log_analytics_workspace`: Change default of variable `sku` from `pergb2018` to `PerGB2018` ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`84c2448b`](https://github.com/recognizegroup/terraform/commit/84c2448b))
- `azure/function_app_linux`: Change default of variable `runtime_version` from `~3` to `~4` ([#259](https://github.com/recognizegroup/terraform/pull/259)) ([`b3edd9e7`](https://github.com/recognizegroup/terraform/commit/b3edd9e7))
- `azure/function_app_linux_managed_identity`: Change default of variable `runtime_version` from `~3` to `~4` ([#259](https://github.com/recognizegroup/terraform/pull/259)) ([`b3edd9e7`](https://github.com/recognizegroup/terraform/commit/b3edd9e7))
- `azure/function_app_windows`: Change default of variable `runtime_version` from `~3` to `~4` ([#259](https://github.com/recognizegroup/terraform/pull/259)) ([`b3edd9e7`](https://github.com/recognizegroup/terraform/commit/b3edd9e7))
- `azure/api_management_custom_domains`: Add `default_ssl_binding` option to `custom_domains` variable ([#260](https://github.com/recognizegroup/terraform/pull/260)) ([`d44ab78d`](https://github.com/recognizegroup/terraform/commit/d44ab78d))
- `azure/service_bus_subscription`: Change default of variable `auto_delete_on_idle` from `P14D` to `P10675199DT2H48M5.4775807S` ([#286](https://github.com/recognizegroup/terraform/pull/286)) ([`0aed80dd`](https://github.com/recognizegroup/terraform/commit/0aed80dd))
- `azure/key_vault_secrets_put`: Add `expiration_date` option to `secrets` variable ([#294](https://github.com/recognizegroup/terraform/pull/294)) ([`ac9905ea`](https://github.com/recognizegroup/terraform/commit/ac9905ea))
- `azure/key_vault_secrets_put_once`: Add `expiration_date` option to `secrets` variable ([#294](https://github.com/recognizegroup/terraform/pull/294)) ([`ac9905ea`](https://github.com/recognizegroup/terraform/commit/ac9905ea))

### Added

- Add terraform linter ([#263](https://github.com/recognizegroup/terraform/pull/263)) ([`b70b7689`](https://github.com/recognizegroup/terraform/commit/b70b7689))
- Add module `azure/mysql_flexible_server` ([#258](https://github.com/recognizegroup/terraform/pull/258)) ([`46bcaf56`](https://github.com/recognizegroup/terraform/commit/46bcaf56), [`66c62906`](https://github.com/recognizegroup/terraform/commit/66c62906))
- Add module `azure/api_management_custom_domains_simple` ([#260](https://github.com/recognizegroup/terraform/pull/260)) ([`d44ab78d`](https://github.com/recognizegroup/terraform/commit/d44ab78d))
- Add module `azure/application_insights_workbook` ([#262](https://github.com/recognizegroup/terraform/pull/262), [#263](https://github.com/recognizegroup/terraform/pull/263)) ([`93b1f1d7`](https://github.com/recognizegroup/terraform/commit/93b1f1d7), [`b70b7689`](https://github.com/recognizegroup/terraform/commit/b70b7689))
- `azure/subnet`: Add variable `private_endpoint_network_policies_enabled` ([#265](https://github.com/recognizegroup/terraform/pull/265)) ([`b26228b4`](https://github.com/recognizegroup/terraform/commit/b26228b4))
- Add module `azure/service_plan` ([#261](https://github.com/recognizegroup/terraform/pull/261)) ([`0754b672`](https://github.com/recognizegroup/terraform/commit/0754b672))
- Add module `azure/web_app_linux` ([#261](https://github.com/recognizegroup/terraform/pull/261)) ([`8990f2e4`](https://github.com/recognizegroup/terraform/commit/8990f2e4))
- Add module `azure/web_app_windows` ([#261](https://github.com/recognizegroup/terraform/pull/261)) ([`8990f2e4`](https://github.com/recognizegroup/terraform/commit/8990f2e4))
- Add module `azure/monitoring_action_group` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1), [`a1e363a6`](https://github.com/recognizegroup/terraform/commit/a1e363a6))
- Add module `azure/monitoring_log_analytics_alert` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1))
- Add module `azure/monitoring_metric_alert` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1))
- Add module `azure/api_connectors/office365_set` ([#276](https://github.com/recognizegroup/terraform/pull/276)) ([`7a483886`](https://github.com/recognizegroup/terraform/commit/7a483886))
- Add module `azure/api_connectors/storage_blob` ([#276](https://github.com/recognizegroup/terraform/pull/276)) ([`7a483886`](https://github.com/recognizegroup/terraform/commit/7a483886))
- Add module `azure/api_connectors/storage_table` ([#276](https://github.com/recognizegroup/terraform/pull/276)) ([`7a483886`](https://github.com/recognizegroup/terraform/commit/7a483886))
- `azure/logic_app_standard`: Add variable `https_only` ([#283](https://github.com/recognizegroup/terraform/pull/283)) ([`a9fce065`](https://github.com/recognizegroup/terraform/commit/a9fce065))
- `azure/logic_app_standard`: Add variable `logic_app_version` ([#283](https://github.com/recognizegroup/terraform/pull/283), [#287](https://github.com/recognizegroup/terraform/pull/287)) ([`a9fce065`](https://github.com/recognizegroup/terraform/commit/a9fce065), [`76468a79`](https://github.com/recognizegroup/terraform/commit/76468a79))
- `azure/function_app_linux_managed_identity`: Add variable `authentication_settings` ([#284](https://github.com/recognizegroup/terraform/pull/284)) ([`833e1c4c`](https://github.com/recognizegroup/terraform/commit/833e1c4c), [`a40fc302`](https://github.com/recognizegroup/terraform/commit/a40fc302))
- `azure/resource_group`: Add variable `readonly` ([#295](https://github.com/recognizegroup/terraform/pull/295)) ([`97400ba2`](https://github.com/recognizegroup/terraform/commit/97400ba2))
- `azure/resource_group`: Add variable `cannotdelete` ([#295](https://github.com/recognizegroup/terraform/pull/295)) ([`97400ba2`](https://github.com/recognizegroup/terraform/commit/97400ba2))

### Removed

- **Breaking:** Remove deprecated module `azure/key_vault_cetificate`, replace with `azure/key_vault_certificate` ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`d1574f22`](https://github.com/recognizegroup/terraform/commit/d1574f22))
- **Breaking:** Remove module `azure/storage_container_nfsv3`, already exists as `azure/data_lake_filesystem` module ([#257](https://github.com/recognizegroup/terraform/pull/257)) ([`a1d585f3`](https://github.com/recognizegroup/terraform/commit/a1d585f3))
- **Breaking:** Remove module `azure/log_analytics_workbook`, replace with `azure/application_insights_workbook` ([#262](https://github.com/recognizegroup/terraform/pull/262), [#263](https://github.com/recognizegroup/terraform/pull/263)) ([`93b1f1d7`](https://github.com/recognizegroup/terraform/commit/93b1f1d7), [`b70b7689`](https://github.com/recognizegroup/terraform/commit/b70b7689))
- **Breaking:** Remove module `azure/integration_service_environment` ([#263](https://github.com/recognizegroup/terraform/pull/263)) ([`016125f6`](https://github.com/recognizegroup/terraform/commit/016125f6)). Resource is deprecated ([source](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/integration_service_environment)).
- **Breaking:** `azure/subnet`: Remove variable `enforce_private_link_endpoint_network_policies`, replace with `private_endpoint_network_policies_enabled` ([#265](https://github.com/recognizegroup/terraform/pull/265)) ([`b26228b4`](https://github.com/recognizegroup/terraform/commit/b26228b4))
- **Breaking:** Remove module `azure/app_service_plan`, replace with `azure/service_plan` ([#261](https://github.com/recognizegroup/terraform/pull/261)) ([`beaf338d`](https://github.com/recognizegroup/terraform/commit/beaf338d))
- **Breaking:** Remove module `azure/app_service`, replace with `azure/web_app_linux` and `azure/web_app_windows` ([#261](https://github.com/recognizegroup/terraform/pull/261)) ([`8990f2e4`](https://github.com/recognizegroup/terraform/commit/8990f2e4), [`1fb0c954`](https://github.com/recognizegroup/terraform/commit/1fb0c954))
- **Breaking:** Remove module `azure/monitoring`, replace with `azure/azure/monitoring_action_group` and `azure/monitoring_log_analytics_alert` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1))
- **Breaking:** Remove module `azure/api_connectors/storage_account`, replace with `azure/api_connectors/storage_blob` and `azure/api_connectors/storage_table` ([#276](https://github.com/recognizegroup/terraform/pull/276)) ([`7a483886`](https://github.com/recognizegroup/terraform/commit/7a483886))

[3.3.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.3.0
[3.2.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.2.0
[3.1.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.1.0
[3.0.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.0.0
