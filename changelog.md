# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

----

## [2.3.0] => 2020-NOV-09

### Added

* New github latest changelog publish
* Quote all memento keys so they can preserve their casing
* Quote all metadata keys so they can preserve their casing

### Fixed

* Metadata for validations so the docs can be generated correctly

----

## [2.2.0] => 2020-JUN-02

### Added

* New formatting rules
* New automation standards
* Automatic github publishing

### Fixed

* Deleted rogue UDFValidator embedded in the `validators` path
* fix for BOX-63 and BOX-68	9393c30	wpdebruin <wil@site4u.nl> `validationData` cannot be converted to a string for UDF,RequiredUnless,RequiredIf,Unique so they are excluded from this message replacement

----

## [2.1.0] => 2020-FEB-04

### Added

* `feature` : Added `constraintProfiles` to allow you to define which fields to validate according to defined profiles: https://github.com/coldbox-modules/cbvalidation/issues/37
* `feature` : Updated `RequiredUnless` and `RequiredIf` to use struct literal notation instead of the weird parsing we did.
* `feature` : Added the `Unique` validator thanks to @elpete!
* `feature` : All validators now accept a `rules` argument, which is the struct of constraints for the specific field it's validating on
* `improvement` : Added `null` support for the `RequiredIf,RequiredUnless` validator values

----

## 2.0.0 => 2020-JAN-31

### Features

* No more manual discovery of validators, automated registration and lookup process, cleaned lots of code on this one!
* New Validator: `Accepted` - The field under validation must be yes, on, 1, or true. This is useful for validating "Terms of Service" acceptance.
* New Validator: `Alpha` - Only allows alphabetic characters
* New Validator: `RequiredUnless` with validation data as a struct literal `{ anotherField:value, ... }`  -  The field under validation must be present and not empty unless the `anotherfield` field is equal to the passed `value`.
* New Validator: `RequiredIf` with validation data as a struct literal `{ anotherField:value, ... }`  -  The field under validation must be present and not empty if the `anotherfield` field is equal to the passed `value`.
* Accelerated validation by removing type checks. ACF chokes on interface checks

### Improvements

* Consistency on all validators to ignore null or empty values except the `Required` validator
* Formatting consistencies
* Improve error messages to describe better validation
* Get away from `evaluate()` instead use `invoke()`

### Compat & Bugs

* `Bugs` : Fixed lots of wrong type exceptions
* `Compat` : Remove ACF11 support

----

## [1.5.2]

* `bug` : Added `float` to the type validator which was missing

----

## [1.5.1]

* `bug` : This version's mixin is causing errors because its looking for this.validate() and its looking in the handler, not in the mixin file itself.

----

## [1.5.0]

* `features` : `validateOrFail()` new method to validate and if it fails it will throw a `ValidationException`. Also if the target is an object, the object is returned. If the target is a struct, the struct is returned ONLY with the validated fields.
* `feature` : `validateModel()` is now deprecated in favor of `validate()`.  `validateModel()` is now marked for deprecation.
* `improvement` : Direct scoping for performance an avoidance of lookup bugs
* `improvement` : HTTPS protocol for everything
* `improvement` : Updated to testbox 3
* `bug` : Fix mapping declaration for apidocs`
* `bug` : Missing return on `addSharedConstraint()` function

----

## [1.4.1]

* Location protocol

----

## [1.4.0]

* Updated to new layout
* UDFValidator added rejectedValue to newError arguments: https://github.com/coldbox-modules/cbvalidation/pull/29/files
* Removed lucee 4.5 support
* Mixins missing comma on arguments
* Switching evaluate to `invoke` for security and performance
* Fix for passing arguments in `newError()` on the validation result object

----

## [1.3.0]

* Build updates and travis updates
* Unified Workbench
* `MaxValidator` The Max validator needs to better reflect that it can be less than or equal to the number to compare to <=
* `MinValidator` The explanation needs to better reflect the min validator which is >=
* Allow custom validators to be specified just by key and the payload to be passed in as validation data
* `GenericObject` Should return `null` on non-existent keys instead of an exception if not we cannot validate nullness
* You can now pass a list of fields to ONLY validate via `validate()` methods using the `includeFields` argument.

----

## [1.2.1]

* Dependency updates

----

## [1.2.0]

* Updated cbi18n dependency to latest
* Travis updates
* Type validator not countaing against 0 length values
* Size validator typos
* Migration to new github organization

----

## [1.1.0]

* Updated cbi18n dependency to version 1.2.0
* SizeValidator not evaluating correctly non-required fields
* Travis integration
* Build script updates
* Added array validation thanks to Sana Ullah

----

## [1.0.3]

* Exception on Lucee/Railo reporting wrong interface types when using imports
* Exception message was wrong on UDFValidator
* Ignore invalid validator keys, to allow for extra metadata and custom messages

----

## [1.0.2]

* production ignore lists
* Unloading of helpers

----

## [1.0.1]

* https://ortussolutions.atlassian.net/browse/CCM-21 Force the validation manager binder mapping
* https://ortussolutions.atlassian.net/browse/CCM-20 ValidationManager missing singleton persistance

----

## [1.0.0]

* Create first module version
