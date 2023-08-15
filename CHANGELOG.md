# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Common Changelog](https://common-changelog.org),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

[//]: # (TODO: update date)
## [4.0.0] - (unreleased)

### Removed

- **Breaking:** Remove backend declaration from modules ([`44c65ee8`](https://github.com/recognizegroup/terraform/commit/44c65ee8)) ([@bartwesselink](https://github.com/bartwesselink))

## [3.8.0] - 2023-08-15

### Added

- `azure/storage_account_public`: Add variable `static_website` ([#345](https://github.com/recognizegroup/terraform/pull/345)) ([`fa6cc9b2`](https://github.com/recognizegroup/terraform/commit/fa6cc9b2)) ([@bartwesselink](https://github.com/bartwesselink))
- `azure/storage_account_public`: Add variable `custom_domain` ([#346](https://github.com/recognizegroup/terraform/pull/346)) ([`54c6931e`](https://github.com/recognizegroup/terraform/commit/54c6931e)) ([@bartwesselink](https://github.com/bartwesselink))
- `azure/storage_account_private`: Add output `primary_connection_string` ([#348](https://github.com/recognizegroup/terraform/pull/348)) ([`ba78e538`](https://github.com/recognizegroup/terraform/commit/ba78e538)) ([@tom-reinders](https://github.com/tom-reinders))
- `azure/storage_account_public`: Add output `primary_connection_string` ([#348](https://github.com/recognizegroup/terraform/pull/348)) ([`ba78e538`](https://github.com/recognizegroup/terraform/commit/ba78e538)) ([@tom-reinders](https://github.com/tom-reinders))

## [3.7.0] - 2023-07-14

### Added

- `azure/storage_account_public`: Add variable `cors_rules` ([#343](https://github.com/recognizegroup/terraform/pull/343)) ([`242a7de0`](https://github.com/recognizegroup/terraform/commit/242a7de0)) ([@tom-reinders](https://github.com/tom-reinders))

## [3.6.0] - 2023-07-13

### Added

- Add module `azure/application_insights_smart_detection_rule` ([#339](https://github.com/recognizegroup/terraform/pull/339)) ([`b5ba2c58`](https://github.com/recognizegroup/terraform/commit/b5ba2c58)) ([@tom-reinders](https://github.com/tom-reinders))
- `azure/logic_app`: Add variable `trigger_oauth_policy_claims` ([#340](https://github.com/recognizegroup/terraform/pull/340)) ([`e2381256`](https://github.com/recognizegroup/terraform/commit/e2381256)) ([@mkostalrecognize](https://github.com/mkostalrecognize))
- `azure/logic_app`: Add variable `trigger_ip_address_range` ([#340](https://github.com/recognizegroup/terraform/pull/340)) ([`31477279`](https://github.com/recognizegroup/terraform/commit/31477279)) ([@mkostalrecognize](https://github.com/mkostalrecognize))

## [3.5.0] - 2023-06-23

### Changed

- Update getting started example in README.md ([#334](https://github.com/recognizegroup/terraform/pull/334)) ([`8a1fea64`](https://github.com/recognizegroup/terraform/commit/8a1fea64)) ([@wslaghekke](https://github.com/wslaghekke))

### Added

- `azure/event_grid_topic_subscription`: Add variable `advanced_filter` ([#331](https://github.com/recognizegroup/terraform/pull/331)) ([`71e1a5a0`](https://github.com/recognizegroup/terraform/commit/71e1a5a0)) ([@patrik-pa4k](https://github.com/patrik-pa4k))
- `kubernetes/cron_job`: Add variable `timezone` ([#335](https://github.com/recognizegroup/terraform/pull/335)) ([`dcd4faa0`](https://github.com/recognizegroup/terraform/commit/dcd4faa0)) ([@tom-reinders](https://github.com/tom-reinders))

### Fixed

- `kubernetes/deployment_with_service`: Fix duplicate volume ([#332](https://github.com/recognizegroup/terraform/pull/332)) ([`da211366`](https://github.com/recognizegroup/terraform/commit/da211366)) ([@tom-reinders](https://github.com/tom-reinders))
- `kubernetes/cron_job`: Fix variable description ([#332](https://github.com/recognizegroup/terraform/pull/332)) ([`da211366`](https://github.com/recognizegroup/terraform/commit/da211366)) ([@tom-reinders](https://github.com/tom-reinders))
- `kubernetes/deployment_with_service`: Fix bug where the http-scaler used the wrong port ([#333](https://github.com/recognizegroup/terraform/pull/333)) ([`270e3947`](https://github.com/recognizegroup/terraform/commit/270e3947)) ([@tom-reinders](https://github.com/tom-reinders))

## [3.4.0] - 2023-05-30

### Added

- `kubernetes/pvc`: Add output `name` ([#327](https://github.com/recognizegroup/terraform/pull/327)) ([`92853cfc`](https://github.com/recognizegroup/terraform/commit/92853cfc)) ([@tom-reinders](https://github.com/tom-reinders))
- `kubernetes/deployment_with_service`: Add variable `image_pull_policy` ([#324](https://github.com/recognizegroup/terraform/pull/324)) ([`b86adcae`](https://github.com/recognizegroup/terraform/commit/b86adcae)) ([@tom-reinders](https://github.com/tom-reinders))
- Add module `kubernetes/cron_job` ([#324](https://github.com/recognizegroup/terraform/pull/324), [#325](https://github.com/recognizegroup/terraform/pull/325), [#326](https://github.com/recognizegroup/terraform/pull/326)) ([`b86adcae`](https://github.com/recognizegroup/terraform/commit/b86adcae), [`9684d822`](https://github.com/recognizegroup/terraform/commit/9684d822), [`da333fbb`](https://github.com/recognizegroup/terraform/commit/da333fbb)) ([@tom-reinders](https://github.com/tom-reinders))
- Add module `other/vm_with_power_automate_desktop` ([#323](https://github.com/recognizegroup/terraform/pull/323)) ([`dafadeef`](https://github.com/recognizegroup/terraform/commit/dafadeef)) ([@bartwesselink](https://github.com/bartwesselink))

## [3.3.0] - 2023-05-15

### Changed

- `azure/mysql_flexible_server`: Change default of variable `backup_retention_days` from `7` to `30` ([#313](https://github.com/recognizegroup/terraform/pull/313)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489)) ([@bartwesselink](https://github.com/bartwesselink))

### Added

- `azure/service_plan`: Add variable `scaling_rules` ([#309](https://github.com/recognizegroup/terraform/pull/309), [#312](https://github.com/recognizegroup/terraform/pull/312)) ([`fd0039e3`](https://github.com/recognizegroup/terraform/commit/fd0039e3), [`4fdb7698`](https://github.com/recognizegroup/terraform/commit/4fdb7698)) ([@ArtiomMatiom](https://github.com/ArtiomMatiom))
- `azure/storage_account_public`: Add variable `auto_delete_rules` ([#310](https://github.com/recognizegroup/terraform/pull/310)) ([`d0eb9139`](https://github.com/recognizegroup/terraform/commit/d0eb9139)) ([@ArtiomMatiom](https://github.com/ArtiomMatiom))
- `azure/api_management_api`: Add variable `custom_backend_policy` ([#311](https://github.com/recognizegroup/terraform/pull/311), [#314](https://github.com/recognizegroup/terraform/pull/314)) ([`37b46fd7`](https://github.com/recognizegroup/terraform/commit/37b46fd7), [`385a1af1`](https://github.com/recognizegroup/terraform/commit/385a1af1)) ([@pipalmic](https://github.com/pipalmic))
- Add module `azure/mysql_flexible_server_public` ([#313](https://github.com/recognizegroup/terraform/pull/313), [#320](https://github.com/recognizegroup/terraform/pull/320)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489), [`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d)) ([@bartwesselink](https://github.com/bartwesselink), [@tom-reinders](https://github.com/tom-reinders))
- Add module `azure/postgresql_public` ([#313](https://github.com/recognizegroup/terraform/pull/313), [#320](https://github.com/recognizegroup/terraform/pull/320)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489), [`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d)) ([@bartwesselink](https://github.com/bartwesselink), [@tom-reinders](https://github.com/tom-reinders))
- Add module `kubernetes/configmap` ([#313](https://github.com/recognizegroup/terraform/pull/313)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489)) ([@bartwesselink](https://github.com/bartwesselink))
- Add module `kubernetes/deployment_with_service` ([#313](https://github.com/recognizegroup/terraform/pull/313), [#321](https://github.com/recognizegroup/terraform/pull/321)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489), [`383bdda5`](https://github.com/recognizegroup/terraform/commit/383bdda5)) ([@bartwesselink](https://github.com/bartwesselink), [@tom-reinders](https://github.com/tom-reinders))
- Add module `kubernetes/ingress` ([#313](https://github.com/recognizegroup/terraform/pull/313)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489)) ([@bartwesselink](https://github.com/bartwesselink))
- Add module `kubernetes/pvc` ([#313](https://github.com/recognizegroup/terraform/pull/313)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489)) ([@bartwesselink](https://github.com/bartwesselink))
- Add module `kubernetes/secret` ([#313](https://github.com/recognizegroup/terraform/pull/313)) ([`06870489`](https://github.com/recognizegroup/terraform/commit/06870489)) ([@bartwesselink](https://github.com/bartwesselink))
- `azure/logic_app_standard`: Add variable `identity_ids` ([#317](https://github.com/recognizegroup/terraform/pull/317)) ([`ab4272ad`](https://github.com/recognizegroup/terraform/commit/ab4272ad), [`b6d06c84`](https://github.com/recognizegroup/terraform/commit/b6d06c84)) ([@tjezek](https://github.com/tjezek))
- `other/password_generator`: Add variables `min_lower`, `min_upper`, `min_numeric`, `min_special` ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d), [`bd78f656`](https://github.com/recognizegroup/terraform/commit/bd78f656)) ([@tom-reinders](https://github.com/tom-reinders))

### Fixed

- `azure/logic_app_standard`: Fix deployment bug caused by [hashicorp/terraform-provider-archive#40](https://github.com/hashicorp/terraform-provider-archive/issues/40) ([#316](https://github.com/recognizegroup/terraform/pull/316)) ([`cdae9fcb`](https://github.com/recognizegroup/terraform/commit/cdae9fcb)) ([@tjezek](https://github.com/tjezek))
- `azure/mssql`: Fix bug where random_password could generate a password with only one type of character be it lowercase, uppercase, numeric or special ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d)) ([@tom-reinders](https://github.com/tom-reinders))
- `azure/mysql`: Fix bug where random_password could generate a password with only one type of character be it lowercase, uppercase, numeric or special ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d)) ([@tom-reinders](https://github.com/tom-reinders))
- `azure/mysql_flexible_server`: Fix bug where random_password could generate a password with only one type of character be it lowercase, uppercase, numeric or special ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d)) ([@tom-reinders](https://github.com/tom-reinders))
- `azure/postgresql`: Fix bug where random_password could generate a password with only one type of character be it lowercase, uppercase, numeric or special ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d)) ([@tom-reinders](https://github.com/tom-reinders))
- `azure/synapse_workspace`: Fix bug where random_password could generate a password with only one type of character be it lowercase, uppercase, numeric or special ([#320](https://github.com/recognizegroup/terraform/pull/320)) ([`cd6ca71d`](https://github.com/recognizegroup/terraform/commit/cd6ca71d)) ([@tom-reinders](https://github.com/tom-reinders))

## [3.2.0] - 2023-04-11

### Changed

- `azure/service_bus_subscription`: Change default of variable `lock_duration` from `P0DT0H1M0S` to `PT1M` ([#304](https://github.com/recognizegroup/terraform/pull/304)) ([`3b50ca39`](https://github.com/recognizegroup/terraform/commit/3b50ca39)) ([@tjezek](https://github.com/tjezek))

### Added

- `azure/function_app_linux`: Add variable `use_32_bit_worker` ([#305](https://github.com/recognizegroup/terraform/pull/305)) ([`1cf8b62b`](https://github.com/recognizegroup/terraform/commit/1cf8b62b)) ([@tjezek](https://github.com/tjezek))
- `azure/function_app_linux_managed_identity`: Add variable `use_32_bit_worker` ([#305](https://github.com/recognizegroup/terraform/pull/305)) ([`1cf8b62b`](https://github.com/recognizegroup/terraform/commit/1cf8b62b)) ([@tjezek](https://github.com/tjezek))
- `azure/function_app_windows`: Add variable `use_32_bit_worker` ([#305](https://github.com/recognizegroup/terraform/pull/305)) ([`1cf8b62b`](https://github.com/recognizegroup/terraform/commit/1cf8b62b)) ([@tjezek](https://github.com/tjezek))

## [3.1.0] - 2023-04-05

### Added

- Add module `azure/application_performance_workbook` ([#300](https://github.com/recognizegroup/terraform/pull/300)) ([`7b0c705e`](https://github.com/recognizegroup/terraform/commit/7b0c705e)) ([@bartwesselink](https://github.com/bartwesselink))
- `azure/application_role_assignment`: Add variable `use_existing_service_principal` ([#299](https://github.com/recognizegroup/terraform/pull/299)) ([`4a0673f9`](https://github.com/recognizegroup/terraform/commit/4a0673f9)) ([@tjezek](https://github.com/tjezek))

## [3.0.0] - 2023-03-30

_If you are upgrading: please see [UPGRADE_3.0.md](UPGRADE_3.0.md)._

### Changed

- **Breaking:** Bump minimum version of terraform to `~> 1.3` ([#264](https://github.com/recognizegroup/terraform/pull/264)) ([`b01fac27`](https://github.com/recognizegroup/terraform/commit/b01fac27)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** Bump provider `hashicorp/azurerm` from all different versions to `~> 3.48` ([#249](https://github.com/recognizegroup/terraform/pull/249), [#290](https://github.com/recognizegroup/terraform/pull/290)) ([`3620b4bb`](https://github.com/recognizegroup/terraform/commit/3620b4bb), [`d1e8281a`](https://github.com/recognizegroup/terraform/commit/d1e8281a)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** Bump provider `cloudflare/cloudflare` from `~> 3.14.0` to `~> 4.0` ([#270](https://github.com/recognizegroup/terraform/pull/270)) ([`a643f228`](https://github.com/recognizegroup/terraform/commit/a643f228)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** `azure/storage_share`: Remove default of variable `quota`, variable is now required ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`84c2448b`](https://github.com/recognizegroup/terraform/commit/84c2448b)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** `azure/subnet`: Change type of variable `service_endpoints` from `list` to `set(string)` ([#257](https://github.com/recognizegroup/terraform/pull/257)) ([`f3e9d233`](https://github.com/recognizegroup/terraform/commit/f3e9d233)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** `azure/api_connectors/service_bus_managed_identity`: Add required variable `location` ([#269](https://github.com/recognizegroup/terraform/pull/269)) ([`d9243eba`](https://github.com/recognizegroup/terraform/commit/d9243eba), [`123fbee4`](https://github.com/recognizegroup/terraform/commit/123fbee4), [`724a0910`](https://github.com/recognizegroup/terraform/commit/724a0910)) ([@JeffreyVWT](https://github.com/JeffreyVWT))
- **Breaking:** `azure/function_app_linux`: Rename variable from `app_service_plan_id` to `service_plan_id` ([#282](https://github.com/recognizegroup/terraform/pull/282)) ([`14e2c94`](https://github.com/recognizegroup/terraform/commit/14e2c94)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** `azure/function_app_linux_managed_identity`: Rename variable from `app_service_plan_id` to `service_plan_id` ([#282](https://github.com/recognizegroup/terraform/pull/282)) ([`14e2c94`](https://github.com/recognizegroup/terraform/commit/14e2c94)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** `azure/function_app_windows`: Rename variable from `app_service_plan_id` to `service_plan_id` ([#282](https://github.com/recognizegroup/terraform/pull/282)) ([`14e2c94`](https://github.com/recognizegroup/terraform/commit/14e2c94)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** `azure/virtual_network`: Change type of variable `address_space` from `list` to `list(string)` ([#263](https://github.com/recognizegroup/terraform/pull/263)) ([`baf86211`](https://github.com/recognizegroup/terraform/commit/baf86211)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** `azure/function_app_linux`: Rename variable from `ip_restriction` to `ip_restrictions` ([#296](https://github.com/recognizegroup/terraform/pull/296)) ([`e60e867a`](https://github.com/recognizegroup/terraform/commit/e60e867a)) ([@corjanZee](https://github.com/corjanZee))
- **Breaking:** `azure/function_app_linux_managed_identity`: Rename variable from `ip_restriction` to `ip_restrictions` ([#296](https://github.com/recognizegroup/terraform/pull/296)) ([`e60e867a`](https://github.com/recognizegroup/terraform/commit/e60e867a)) ([@corjanZee](https://github.com/corjanZee))
- **Breaking:** `azure/function_app_windows`: Rename variable from `ip_restriction` to `ip_restrictions` ([#296](https://github.com/recognizegroup/terraform/pull/296)) ([`e60e867a`](https://github.com/recognizegroup/terraform/commit/e60e867a)) ([@corjanZee](https://github.com/corjanZee))
- Bump provider `hashicorp/azuread` from `2.22.0` to `~> 2.36` ([#257](https://github.com/recognizegroup/terraform/pull/257), [#290](https://github.com/recognizegroup/terraform/pull/290)) ([`f3e9d233`](https://github.com/recognizegroup/terraform/commit/f3e9d233), [`d1e8281a`](https://github.com/recognizegroup/terraform/commit/d1e8281a)) ([@tom-reinders](https://github.com/tom-reinders))
- Bump provider `Azure/azapi` from `1.0.0` to `~> 1.4` ([#257](https://github.com/recognizegroup/terraform/pull/257), [#290](https://github.com/recognizegroup/terraform/pull/290)) ([`f3e9d233`](https://github.com/recognizegroup/terraform/commit/f3e9d233), [`d1e8281a`](https://github.com/recognizegroup/terraform/commit/d1e8281a)) ([@tom-reinders](https://github.com/tom-reinders))
- Bump provider `hashicorp/archive` from `2.2.0` to `~> 2.3` ([#285](https://github.com/recognizegroup/terraform/pull/285)) ([`eefff320`](https://github.com/recognizegroup/terraform/commit/eefff320)) ([@tom-reinders](https://github.com/tom-reinders))
- `azure/log_analytics_workspace`: Change default of variable `sku` from `pergb2018` to `PerGB2018` ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`84c2448b`](https://github.com/recognizegroup/terraform/commit/84c2448b)) ([@tom-reinders](https://github.com/tom-reinders))
- `azure/function_app_linux`: Change default of variable `runtime_version` from `~3` to `~4` ([#259](https://github.com/recognizegroup/terraform/pull/259)) ([`b3edd9e7`](https://github.com/recognizegroup/terraform/commit/b3edd9e7)) ([@MartinPronk67](https://github.com/MartinPronk67))
- `azure/function_app_linux_managed_identity`: Change default of variable `runtime_version` from `~3` to `~4` ([#259](https://github.com/recognizegroup/terraform/pull/259)) ([`b3edd9e7`](https://github.com/recognizegroup/terraform/commit/b3edd9e7)) ([@MartinPronk67](https://github.com/MartinPronk67))
- `azure/function_app_windows`: Change default of variable `runtime_version` from `~3` to `~4` ([#259](https://github.com/recognizegroup/terraform/pull/259)) ([`b3edd9e7`](https://github.com/recognizegroup/terraform/commit/b3edd9e7)) ([@MartinPronk67](https://github.com/MartinPronk67))
- `azure/api_management_custom_domains`: Add `default_ssl_binding` option to `custom_domains` variable ([#260](https://github.com/recognizegroup/terraform/pull/260)) ([`d44ab78d`](https://github.com/recognizegroup/terraform/commit/d44ab78d)) ([@corjanZee](https://github.com/corjanZee))
- `azure/service_bus_subscription`: Change default of variable `auto_delete_on_idle` from `P14D` to `P10675199DT2H48M5.4775807S` ([#286](https://github.com/recognizegroup/terraform/pull/286)) ([`0aed80dd`](https://github.com/recognizegroup/terraform/commit/0aed80dd)) ([@corjanZee](https://github.com/corjanZee))
- `azure/key_vault_secrets_put`: Add `expiration_date` option to `secrets` variable ([#294](https://github.com/recognizegroup/terraform/pull/294)) ([`ac9905ea`](https://github.com/recognizegroup/terraform/commit/ac9905ea)) ([@corjanZee](https://github.com/corjanZee))
- `azure/key_vault_secrets_put_once`: Add `expiration_date` option to `secrets` variable ([#294](https://github.com/recognizegroup/terraform/pull/294)) ([`ac9905ea`](https://github.com/recognizegroup/terraform/commit/ac9905ea)) ([@corjanZee](https://github.com/corjanZee))

### Added

- Add terraform linter ([#263](https://github.com/recognizegroup/terraform/pull/263)) ([`b70b7689`](https://github.com/recognizegroup/terraform/commit/b70b7689)) ([@tom-reinders](https://github.com/tom-reinders))
- Add module `azure/mysql_flexible_server` ([#258](https://github.com/recognizegroup/terraform/pull/258)) ([`46bcaf56`](https://github.com/recognizegroup/terraform/commit/46bcaf56), [`66c62906`](https://github.com/recognizegroup/terraform/commit/66c62906)) ([@wouter-b](https://github.com/wouter-b))
- Add module `azure/api_management_custom_domains_simple` ([#260](https://github.com/recognizegroup/terraform/pull/260)) ([`d44ab78d`](https://github.com/recognizegroup/terraform/commit/d44ab78d)) ([@corjanZee](https://github.com/corjanZee))
- Add module `azure/application_insights_workbook` ([#262](https://github.com/recognizegroup/terraform/pull/262), [#263](https://github.com/recognizegroup/terraform/pull/263)) ([`93b1f1d7`](https://github.com/recognizegroup/terraform/commit/93b1f1d7), [`b70b7689`](https://github.com/recognizegroup/terraform/commit/b70b7689)) ([@ArtiomMatiom](https://github.com/ArtiomMatiom), [@tom-reinders](https://github.com/tom-reinders))
- `azure/subnet`: Add variable `private_endpoint_network_policies_enabled` ([#265](https://github.com/recognizegroup/terraform/pull/265)) ([`b26228b4`](https://github.com/recognizegroup/terraform/commit/b26228b4)) ([@tom-reinders](https://github.com/tom-reinders))
- Add module `azure/service_plan` ([#261](https://github.com/recognizegroup/terraform/pull/261)) ([`0754b672`](https://github.com/recognizegroup/terraform/commit/0754b672)) ([@tom-reinders](https://github.com/tom-reinders))
- Add module `azure/web_app_linux` ([#261](https://github.com/recognizegroup/terraform/pull/261)) ([`8990f2e4`](https://github.com/recognizegroup/terraform/commit/8990f2e4)) ([@tom-reinders](https://github.com/tom-reinders))
- Add module `azure/web_app_windows` ([#261](https://github.com/recognizegroup/terraform/pull/261)) ([`8990f2e4`](https://github.com/recognizegroup/terraform/commit/8990f2e4)) ([@tom-reinders](https://github.com/tom-reinders))
- Add module `azure/monitoring_action_group` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1), [`a1e363a6`](https://github.com/recognizegroup/terraform/commit/a1e363a6)) ([@pipalmic](https://github.com/pipalmic))
- Add module `azure/monitoring_log_analytics_alert` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1)) ([@pipalmic](https://github.com/pipalmic))
- Add module `azure/monitoring_metric_alert` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1)) ([@pipalmic](https://github.com/pipalmic))
- Add module `azure/api_connectors/office365_set` ([#276](https://github.com/recognizegroup/terraform/pull/276)) ([`7a483886`](https://github.com/recognizegroup/terraform/commit/7a483886)) ([@pipalmic](https://github.com/pipalmic))
- Add module `azure/api_connectors/storage_blob` ([#276](https://github.com/recognizegroup/terraform/pull/276)) ([`7a483886`](https://github.com/recognizegroup/terraform/commit/7a483886)) ([@pipalmic](https://github.com/pipalmic))
- Add module `azure/api_connectors/storage_table` ([#276](https://github.com/recognizegroup/terraform/pull/276)) ([`7a483886`](https://github.com/recognizegroup/terraform/commit/7a483886)) ([@pipalmic](https://github.com/pipalmic))
- `azure/logic_app_standard`: Add variable `https_only` ([#283](https://github.com/recognizegroup/terraform/pull/283)) ([`a9fce065`](https://github.com/recognizegroup/terraform/commit/a9fce065)) ([@tjezek](https://github.com/tjezek))
- `azure/logic_app_standard`: Add variable `logic_app_version` ([#283](https://github.com/recognizegroup/terraform/pull/283), [#287](https://github.com/recognizegroup/terraform/pull/287)) ([`a9fce065`](https://github.com/recognizegroup/terraform/commit/a9fce065), [`76468a79`](https://github.com/recognizegroup/terraform/commit/76468a79)) ([@tjezek](https://github.com/tjezek), [@tom-reinders](https://github.com/tom-reinders))
- `azure/function_app_linux_managed_identity`: Add variable `authentication_settings` ([#284](https://github.com/recognizegroup/terraform/pull/284)) ([`833e1c4c`](https://github.com/recognizegroup/terraform/commit/833e1c4c), [`a40fc302`](https://github.com/recognizegroup/terraform/commit/a40fc302)) ([@ArtiomMatiom](https://github.com/ArtiomMatiom))
- `azure/resource_group`: Add variable `readonly` ([#295](https://github.com/recognizegroup/terraform/pull/295)) ([`97400ba2`](https://github.com/recognizegroup/terraform/commit/97400ba2)) ([@JeffreyVWT](https://github.com/JeffreyVWT))
- `azure/resource_group`: Add variable `cannotdelete` ([#295](https://github.com/recognizegroup/terraform/pull/295)) ([`97400ba2`](https://github.com/recognizegroup/terraform/commit/97400ba2)) ([@JeffreyVWT](https://github.com/JeffreyVWT))

### Removed

- **Breaking:** Remove deprecated module `azure/key_vault_cetificate`, replace with `azure/key_vault_certificate` ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`d1574f22`](https://github.com/recognizegroup/terraform/commit/d1574f22)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** Remove module `azure/storage_container_nfsv3`, already exists as `azure/data_lake_filesystem` module ([#257](https://github.com/recognizegroup/terraform/pull/257)) ([`a1d585f3`](https://github.com/recognizegroup/terraform/commit/a1d585f3)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** Remove module `azure/log_analytics_workbook`, replace with `azure/application_insights_workbook` ([#262](https://github.com/recognizegroup/terraform/pull/262), [#263](https://github.com/recognizegroup/terraform/pull/263)) ([`93b1f1d7`](https://github.com/recognizegroup/terraform/commit/93b1f1d7), [`b70b7689`](https://github.com/recognizegroup/terraform/commit/b70b7689)) ([@ArtiomMatiom](https://github.com/ArtiomMatiom), [@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** Remove module `azure/integration_service_environment` ([#263](https://github.com/recognizegroup/terraform/pull/263)) ([`016125f6`](https://github.com/recognizegroup/terraform/commit/016125f6)) ([@tom-reinders](https://github.com/tom-reinders)). Resource is deprecated ([source](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/integration_service_environment)).
- **Breaking:** `azure/subnet`: Remove variable `enforce_private_link_endpoint_network_policies`, replace with `private_endpoint_network_policies_enabled` ([#265](https://github.com/recognizegroup/terraform/pull/265)) ([`b26228b4`](https://github.com/recognizegroup/terraform/commit/b26228b4)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** Remove module `azure/app_service_plan`, replace with `azure/service_plan` ([#261](https://github.com/recognizegroup/terraform/pull/261)) ([`beaf338d`](https://github.com/recognizegroup/terraform/commit/beaf338d)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** Remove module `azure/app_service`, replace with `azure/web_app_linux` and `azure/web_app_windows` ([#261](https://github.com/recognizegroup/terraform/pull/261)) ([`8990f2e4`](https://github.com/recognizegroup/terraform/commit/8990f2e4), [`1fb0c954`](https://github.com/recognizegroup/terraform/commit/1fb0c954)) ([@tom-reinders](https://github.com/tom-reinders))
- **Breaking:** Remove module `azure/monitoring`, replace with `azure/azure/monitoring_action_group` and `azure/monitoring_log_analytics_alert` ([#268](https://github.com/recognizegroup/terraform/pull/268)) ([`5bd013c1`](https://github.com/recognizegroup/terraform/commit/5bd013c1)) ([@pipalmic](https://github.com/pipalmic))
- **Breaking:** Remove module `azure/api_connectors/storage_account`, replace with `azure/api_connectors/storage_blob` and `azure/api_connectors/storage_table` ([#276](https://github.com/recognizegroup/terraform/pull/276)) ([`7a483886`](https://github.com/recognizegroup/terraform/commit/7a483886)) ([@pipalmic](https://github.com/pipalmic))

[3.8.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.8.0
[3.7.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.7.0
[3.6.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.6.0
[3.5.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.5.0
[3.4.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.4.0
[3.3.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.3.0
[3.2.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.2.0
[3.1.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.1.0
[3.0.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.0.0
