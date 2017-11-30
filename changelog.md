CHANGELOG
=========

## 1.3.0
* Build updates and travis updates
* Unified Workbench
* `MaxValidator` The Max validator needs to better reflect that it can be less than or equal to the number to compare to <=
* `MinValidator` The explanation needs to better reflect the min validator which is >=
* Allow custom validators to be specified just by key and the payload to be passed in as validation data
* `GenericObject` Should return `null` on non-existent keys instead of an exception if not we cannot validate nullness
* You can now pass a list of fields to ONLY validate via `validate()` methods using the `includeFields` argument.

## 1.2.1
* Dependency updates

## 1.2.0
* Updated cbi18n dependency to latest
* Travis updates
* Type validator not countaing against 0 length values
* Size validator typos
* Migration to new github organization

## 1.1.0
* Updated cbi18n dependency to version 1.2.0
* SizeValidator not evaluating correctly non-required fields
* Travis integration
* Build script updates
* Added array validation thanks to Sana Ullah

## 1.0.3
* Exception on Lucee/Railo reporting wrong interface types when using imports
* Exception message was wrong on UDFValidator
* Ignore invalid validator keys, to allow for extra metadata and custom messages

## 1.0.2
* production ignore lists
* Unloading of helpers

## 1.0.1
* https://ortussolutions.atlassian.net/browse/CCM-21 Force the validation manager binder mapping
* https://ortussolutions.atlassian.net/browse/CCM-20 ValidationManager missing singleton persistance

## 1.0.0
* Create first module version
