# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Common Changelog](https://common-changelog.org),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2023-01-12

### Changed

- **Breaking:** Bump provider `hashicorp/azurerm` from all different versions to latest `3.x` ([#13](https://github.com/recognizegroup/terraform/pull/13)) ([`3620b4bb`](https://github.com/recognizegroup/terraform/commit/3620b4bb))
- **Breaking:** `azure/storage_share`: Remove default of variable `quota` ([#13](https://github.com/recognizegroup/terraform/pull/13)) ([`84c2448b`](https://github.com/recognizegroup/terraform/commit/84c2448b))

### Added
- `azure/data_factory_http_to_blob`: Added new variable `data_factory_id` ([#13](https://github.com/recognizegroup/terraform/pull/13)) ([`84c2448b`](https://github.com/recognizegroup/terraform/commit/84c2448b))

### Removed
- **Breaking:** Remove module `azure/key_vault_cetificate`, replace with `azure/key_vault_certificate` ([#13](https://github.com/recognizegroup/terraform/pull/13)) ([`y`](https://github.com/recognizegroup/terraform/commit/y))
- **Breaking:** `azure/data_factory_http_to_blob`: Remove variable `data_factory_name`, replace with `data_factory_id` ([#13](https://github.com/recognizegroup/terraform/pull/13)) ([`84c2448b`](https://github.com/recognizegroup/terraform/commit/84c2448b))

---- 
modules/azure/data_factory_http_to_blob

_TODO: Add changelogs of the past._

[3.0.0]: https://github.com/recognizegroup/terraform/releases/tag/v3.0.0
