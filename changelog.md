# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

* * *

## [Unreleased]

## [4.3.0] - 2023-05-05

## [4.2.0] - 2023-04-14

### Added

- New github action versions and consolidation of actions
- New [Contributing](CONTRIBUTING.md) guidelines
- New github support templates

### Changed

- The way custom validators are retrieved so they are ColdBox 7+ compatible
- `pr` github action now just does format checks to avoid issues with other repos.
- Consolidated Adobe 2021 scripts into the server scripts

### Fixed

- Fix for `tasks.json` file to include no recursion
- \#71 - ValidationManager errors when returning `validatedKeys` due to `sharedconstraint` name
- \#45 - `Type` validator needs to be able to validate against `any` type even if that is an empty string

## [4.1.0] => 2022-NOV-14

### Added

- New ColdBox 7 delegate: `Validatable@cbValidation` which can be used to make objects validatable
- New validators: `notSameAs, notSameAsNoCase`

### Changed

- All date comparison validators now validate as `false` when the comparison target dates values are NOT dates instead of throwing an exception.

## [4.0.0] => 2022-OCT-10

### Added

- Major bump of all dependencies
- New `InstanceOf` validator thanks to @homestar9 : <https://github.com/coldbox-modules/cbvalidation/pull/65>
- New virtual app testing and tuning

### Fixed

- Fix process result metadata replacements <https://github.com/coldbox-modules/cbvalidation/pull/64/files> thanks to @alessio-de-padova, when using full null support

### Changed

- Dropped ACF2016

## [3.4.0] => 2022-JUN-27

### Added

- `EmptyValidator` by @elpete. This validator is useful when a field is not required but if it exists it cannot be empty: <https://github.com/coldbox-modules/cbvalidation/pull/61>
- New module template updates and enhancements
- Update to use the new virtual app from ColdBox 6.7

## [3.3.0] => 2022-JAN-12

### Added

- Allow UDF and Method Validators to Utilize Error Metadata by @homestar9 (<https://github.com/coldbox-modules/cbvalidation/pull/48>)

### Fixed

- Date Comparisons Fail if Compare field is empty #58 thanks to @nockhigan: <https://github.com/coldbox-modules/cbvalidation/pull/58>

## [3.2.0] => 2021-NOV-12

### Added

- Migrations to github actions
- ACF2021 Support and automated testing

### Fixed

- Binary Type validator was not working by @nockhigan

### Changed

- Formatting goodness by andreas.eppinger@webwaysag.ch

## [3.1.1] => 2021-MAY-17

### Fixed

- Regression when doing global replacements for `validationData`. It was changed to a `!isStruct()` but in reality, it has to be simple ONLY for replacements.

## [3.1.0] => 2021-MAY-15

### Added

- New validator: `DateEquals` which can help you validate that a target value is a date and is the same date as the validation date or other field
- New validator: `After` which can help you validate that a target value is a date and is after the validation date
- New validator: `AfterOrEqual` which can help you validate that a target value is a date and is after or equal the validation date
- New validator: `Before` which can help you validate that a target value is a date and is before the validation date
- New validator: `BeforeOrEqual` which can help you validate that a target value is a date and is before or equal the validation date
- New `onError( closure ), onSuccess( closure )` callbacks that can be used to validate results using the `validate()` method and concatenate the callbacks.
- New `assert()` helper that can assit you in validating truthful expressions or throwing exceptions
- Two new helpers: `validateIsNullorEmpty()` and `validateHasValue` so you can do simple validations not only on objects and constraints.
- `RequiredIf, RequiredUnless` can now be declared with a simple value pointing to a field. Basically testing if `anotherField` exists, or unless `anotherField` exists.
- New `BaseValidator` for usage by all validators to bring uniformity, global di, and helpers.

### Changed

- The `IValidator` removes the `getName()` since that comes from the `BaseValidator` now.
- The `UniqueValidator` now supports both creationg and update checks with new constraints.
- Removed hard interface requirements to avoid lots of issues across CFML engines. Moved them to the `interfaces` folder so we can continue to document them and use them without direct compilation.

### Fixed

- Metadata for arguments did not have the right spacing for tosn of validators.
- Added the missing `rules` struct argument to several validators that missed it.

## [3.0.0] => 2021-JAN-20

### Added

- Migration to cbi18n 2.x series. This will require for you to update your cbi18n settings in your ColdBox configuration file and the modules that leverage cbi18n.  Please see <https://coldbox-i18n.ortusbooks.com/intro/release-history/whats-new-with-2.0.0#compatibility-updates> on how to upgrade your application easily in about 5 minutes.

## [2.3.0] => 2020-NOV-09

### Added

- New github latest changelog publish
- Quote all memento keys so they can preserve their casing
- Quote all metadata keys so they can preserve their casing

### Fixed

- Metadata for validations so the docs can be generated correctly

## [2.2.0] => 2020-JUN-02

### Added

- New formatting rules
- New automation standards
- Automatic github publishing

### Fixed

- Deleted rogue UDFValidator embedded in the `validators` path
- fix for BOX-63 and BOX-68	9393c30	wpdebruin [wil@site4u.nl](mailto:wil@site4u.nl) `validationData` cannot be converted to a string for UDF,RequiredUnless,RequiredIf,Unique so they are excluded from this message replacement

## [2.1.0] => 2020-FEB-04

### Added

- `feature` : Added `constraintProfiles` to allow you to define which fields to validate according to defined profiles: <https://github.com/coldbox-modules/cbvalidation/issues/37>
- `feature` : Updated `RequiredUnless` and `RequiredIf` to use struct literal notation instead of the weird parsing we did.
- `feature` : Added the `Unique` validator thanks to @elpete!
- `feature` : All validators now accept a `rules` argument, which is the struct of constraints for the specific field it's validating on
- `improvement` : Added `null` support for the `RequiredIf,RequiredUnless` validator values

## 2.0.0 => 2020-JAN-31

### Features

- No more manual discovery of validators, automated registration and lookup process, cleaned lots of code on this one!
- New Validator: `Accepted` - The field under validation must be yes, on, 1, or true. This is useful for validating "Terms of Service" acceptance.
- New Validator: `Alpha` - Only allows alphabetic characters
- New Validator: `RequiredUnless` with validation data as a struct literal `{ anotherField:value, ... }`  -  The field under validation must be present and not empty unless the `anotherfield` field is equal to the passed `value`.
- New Validator: `RequiredIf` with validation data as a struct literal `{ anotherField:value, ... }`  -  The field under validation must be present and not empty if the `anotherfield` field is equal to the passed `value`.
- Accelerated validation by removing type checks. ACF chokes on interface checks

### Improvements

- Consistency on all validators to ignore null or empty values except the `Required` validator
- Formatting consistencies
- Improve error messages to describe better validation
- Get away from `evaluate()` instead use `invoke()`

### Compat & Bugs

- `Bugs` : Fixed lots of wrong type exceptions
- `Compat` : Remove ACF11 support

## [1.5.2]

- `bug` : Added `float` to the type validator which was missing

## [1.5.1]

- `bug` : This version's mixin is causing errors because its looking for this.validate() and its looking in the handler, not in the mixin file itself.

## [1.5.0]

- `features` : `validateOrFail()` new method to validate and if it fails it will throw a `ValidationException`. Also if the target is an object, the object is returned. If the target is a struct, the struct is returned ONLY with the validated fields.
- `feature` : `validateModel()` is now deprecated in favor of `validate()`.  `validateModel()` is now marked for deprecation.
- `improvement` : Direct scoping for performance an avoidance of lookup bugs
- `improvement` : HTTPS protocol for everything
- `improvement` : Updated to testbox 3
- `bug` : Fix mapping declaration for apidocs\`
- `bug` : Missing return on `addSharedConstraint()` function

## [1.4.1]

- Location protocol

## [1.4.0]

- Updated to new layout
- UDFValidator added rejectedValue to newError arguments: <https://github.com/coldbox-modules/cbvalidation/pull/29/files>
- Removed lucee 4.5 support
- Mixins missing comma on arguments
- Switching evaluate to `invoke` for security and performance
- Fix for passing arguments in `newError()` on the validation result object

## [1.3.0]

- Build updates and travis updates
- Unified Workbench
- `MaxValidator` The Max validator needs to better reflect that it can be less than or equal to the number to compare to &lt;=
- `MinValidator` The explanation needs to better reflect the min validator which is >=
- Allow custom validators to be specified just by key and the payload to be passed in as validation data
- `GenericObject` Should return `null` on non-existent keys instead of an exception if not we cannot validate nullness
- You can now pass a list of fields to ONLY validate via `validate()` methods using the `includeFields` argument.

## [1.2.1]

- Dependency updates

## [1.2.0]

- Updated cbi18n dependency to latest
- Travis updates
- Type validator not countaing against 0 length values
- Size validator typos
- Migration to new github organization

## [1.1.0]

- Updated cbi18n dependency to version 1.2.0
- SizeValidator not evaluating correctly non-required fields
- Travis integration
- Build script updates
- Added array validation thanks to Sana Ullah

## [1.0.3]

- Exception on Lucee/Railo reporting wrong interface types when using imports
- Exception message was wrong on UDFValidator
- Ignore invalid validator keys, to allow for extra metadata and custom messages

## [1.0.2]

- production ignore lists
- Unloading of helpers

## [1.0.1]

- <https://ortussolutions.atlassian.net/browse/CCM-21> Force the validation manager binder mapping
- <https://ortussolutions.atlassian.net/browse/CCM-20> ValidationManager missing singleton persistance

## [1.0.0]

- Create first module version

[Unreleased]: https://github.com/coldbox-modules/cbvalidation/compare/v4.3.0...HEAD

[4.3.0]: https://github.com/coldbox-modules/cbvalidation/compare/v4.2.0...v4.3.0

[4.2.0]: https://github.com/coldbox-modules/cbvalidation/compare/v4.2.0...v4.2.0
