Versioning
==============

This document summarizes the versioning policy of releases in this github repository and is a variant of [Semantic Versioning](https://semver.org/). Within the core developer team, we have emphasized several times that it is important to keep releases backwards
compatible. But this is an ideal plan. In the real world it is hard to achieve 100% backward compatibility.

## Version policy

Version numbers are in the format of `x.y.z` for releases and `x.y.z-beta` for pre-releases.

### `X.y.z`: major releases

Backwards compatibility breaking releases, which contain major features and changes that may break usage of modules. Upgrading from earlier versions may not always be neccesary.

* Release cycle is around 12 months, which can be deviated from when needed.
* A major release is created when the repository and a significant proportion of its modules are not backwards compatible (i.e. have breaking changes). This happens, for example, when module paths change or breaking changes are applied to many modules.

### `x.Y.z`: minor releases

Ideally, minor releases contain only changes that do not affect backwards compatibility. Which means that modules within a release should be backwards compatible. In the event of an exception, this should be clearly noted in the release notes.

* Release cycle is variable, and heavily dependent on the number of new modules created.
* Mainly contain new modules, features and bug fixes.
* Should not contain breaking changes in modules.

### `x.y.Z`: patch releases

Patch releases are done when there are new changes because of a bug or small feature enhancements in modules. These releases should aim to be fully backwards compatible.

* Release cycle is variable, and heavily dependent on the modules under current development.
* Containing bug fixes and small feature-enhancements in existing modules.

## Branching policy

* The `main` branch is branch for the current stable release.
* The `develop` branch is branch for the current pre-release.
* New modules and features are developed in `feature/*` branches.
* Bug fixes are done in `bug/*` branches.
* Both feature and bug branches should contain at least a ticket number for internal tracking (e.g. feature/TD-999).

## Release policy

After a bug or feature branch has been merged to `develop`, one should make a new release according to the version policy. Pull requests to `main` and consequent releases from the `main` branch are done automatically.