# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Common Changelog](https://common-changelog.org),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2023-01-12

### Changed

- **Breaking:** Bump provider `hashicorp/azurerm` from all different versions to latest `3.x` ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`3620b4bb`](https://github.com/recognizegroup/terraform/commit/3620b4bb))
- **Breaking:** `azure/storage_share`: Remove default of variable `quota`, variable is now required ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`84c2448b`](https://github.com/recognizegroup/terraform/commit/84c2448b))
- **Breaking:** `azure/subnet`: Change type of variable `service_endpoints` from `list` to `set(string)` ([#](https://github.com/recognizegroup/terraform/pull/)) ([`f3e9d233`](https://github.com/recognizegroup/terraform/commit/f3e9d233))
- `azure/log_analytics_workspace`: Change default of variable `sku` from `pergb2018` to `PerGB2018` ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`84c2448b`](https://github.com/recognizegroup/terraform/commit/84c2448b))

### Removed

- **Breaking:** Remove deprecated module `azure/key_vault_cetificate`, replace with `azure/key_vault_certificate` ([#249](https://github.com/recognizegroup/terraform/pull/249)) ([`d1574f22`](https://github.com/recognizegroup/terraform/commit/d1574f22))
- **Breaking:** Remove module `azure/storage_container_nfsv3`, already exists as `data_lake_filesystem module` ([#](https://github.com/recognizegroup/terraform/pull/)) ([``](https://github.com/recognizegroup/terraform/commit/))

[3.0.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.0.0
