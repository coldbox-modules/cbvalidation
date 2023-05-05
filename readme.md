<p align="center">
	<img src="https://www.ortussolutions.com/__media/coldbox-185-logo.png">
	<br>
	<img src="https://www.ortussolutions.com/__media/wirebox-185.png" height="125">
	<img src="https://www.ortussolutions.com/__media/cachebox-185.png" height="125" >
	<img src="https://www.ortussolutions.com/__media/logbox-185.png"  height="125">
</p>

<p align="center">
	Copyright Since 2005 ColdBox Platform by Luis Majano and Ortus Solutions, Corp
	<br>
	<a href="https://www.coldbox.org">www.coldbox.org</a> |
	<a href="https://www.ortussolutions.com">www.ortussolutions.com</a>
</p>

----

# WELCOME TO THE COLDBOX VALIDATION MODULE

This module is a server side rules validation engine that can provide you with a unified approach to object, struct and form validation.  You can construct validation constraint rules and then tell the engine to validate them accordingly.

## LICENSE

Apache License, Version 2.0.

## IMPORTANT LINKS

- https://github.com/coldbox-modules/cbvalidation
- https://coldbox-validation.ortusbooks.com
- https://forgebox.io/view/cbvalidation

## SYSTEM REQUIREMENTS

- Lucee 5.x+
- Adobe ColdFusion 2018+

## Installation

Leverage CommandBox to install:

`box install cbvalidation`

The module will register several objects into WireBox using the `@cbvalidation` namespace.  The validation manager is registered as `ValidationManager@cbvalidation`.  It will also register several helper methods that can be used throughout the ColdBox application: `validate(), validateOrFail(), getValidationManager()`

## Mixins

The module will also register several methods in your handlers/interceptors/layouts/views

```js
/**
 * Validate an object or structure according to the constraints rules.
 *
 * @target An object or structure to validate
 * @fields The fields to validate on the target. By default, it validates on all fields
 * @constraints A structure of constraint rules or the name of the shared constraint rules to use for validation
 * @locale The i18n locale to use for validation messages
 * @excludeFields The fields to exclude from the validation
 * @includeFields The fields to include in the validation
 * @profiles If passed, a list of profile names to use for validation constraints
 *
 * @return cbvalidation.model.result.IValidationResult
 */
function validate()

/**
 * Validate an object or structure according to the constraints rules and throw an exception if the validation fails.
 * The validation errors will be contained in the `extendedInfo` of the exception in JSON format
 *
 * @target An object or structure to validate
 * @fields The fields to validate on the target. By default, it validates on all fields
 * @constraints A structure of constraint rules or the name of the shared constraint rules to use for validation
 * @locale The i18n locale to use for validation messages
 * @excludeFields The fields to exclude from the validation
 * @includeFields The fields to include in the validation
 * @profiles If passed, a list of profile names to use for validation constraints
 *
 * @return The validated object or the structure fields that where validated
 * @throws ValidationException
 */
function validateOrFail()

/**
 * Retrieve the application's configured Validation Manager
 */
function getValidationManager()

/**
 * Verify if the target value has a value
 * Checks for nullness or for length if it's a simple value, array, query, struct or object.
 */
boolean function validateHasValue( any targetValue )

/**
 * Check if a value is null or is a simple value and it's empty
 *
 * @targetValue the value to check for nullness/emptyness
 */
boolean function validateIsNullOrEmpty( any targetValue )

/**
 * This method mimics the Java assert() function, where it evaluates the target to a boolean value and it must be true
 * to pass and return a true to you, or throw an `AssertException`
 *
 * @target The tareget to evaluate for being true
 * @message The message to send in the exception
 *
 * @throws AssertException if the target is a false or null value
 * @return True, if the target is a non-null value. If false, then it will throw the `AssertError` exception
 */
boolean function assert( target, message="" )
```

## Settings

Here are the module settings you can place in your `ColdBox.cfc` by using the `cbvalidation` settings structure in the `modulesettings`

```js
modulesettings = {
	cbValidation = {
		// The third-party validation manager to use, by default it uses CBValidation.
		manager = "class path",

		// You can store global constraint rules here with unique names
		sharedConstraints = {
			name = {
				field = { constraints here }
			}
		}
	}
}
```

You can read more about ColdBox Validation here: - https://coldbox-validation.ortusbooks.com/

## Constraints

Please check out the docs for the latest on constraints: https://coldbox-validation.ortusbooks.com/overview/valid-constraints.  Constraints rely on rules you apply to incoming fields of data. They can be created on objects or stored wherever you like, as long as you pass them to the validation methods.

Each property can have one or more constraints attached to it.  In an object you can create a `this.constraints` and declare them by the fields you like:

```js
this.constraints = {

	propertyName = {
        // The field under validation must be yes, on, 1, or true. This is useful for validating "Terms of Service" acceptance.
        accepted : any value

        // The field under validation must be a date after the set targetDate
        after : targetDate

        // The field under validation must be a date after or equal the set targetDate
        afterOrEqual : targetDate

        // The field must be alphanumeric ONLY
        alpha : any value

        // The field under validation is an array and all items must pass this validation as well
        arrayItem : {
            // All the constraints to validate the items with
        }

        // The field under validation must be a date before the set targetDate
        before : targetDate

        // The field under validation must be a date before or equal the set targetDate
        beforeOrEqual : targetDate

        // The field under validation must be a date that is equal the set targetDate
        dateEquals : targetDate

        // discrete math modifiers
        discrete : (gt,gte,lt,lte,eq,neq):value

        // value in list
        inList : list

        // max value
        max : value

        // Validation method to use in the target object must return boolean accept the incoming value and target object
        method : methodName

        // min value
        min : value

        // range is a range of values the property value should exist in
        range : eg: 1..10 or 5..-5

        // regex validation
        regex : valid no case regex

        // required field or not, includes null values
        required : boolean [false]

        // The field under validation must be present and not empty if the `anotherfield` field is equal to the passed `value`.
        requiredIf : {
            anotherfield:value, anotherfield:value
        }

        // The field under validation must be present and not empty unless the `anotherfield` field is equal to the passed
        requiredUnless : {
            anotherfield:value, anotherfield:value
        }

        // same as but with no case
        sameAsNoCase : propertyName

        // same as another property
        sameAs : propertyName

        // size or length of the value which can be a (struct,string,array,query)
        size  : numeric or range, eg: 10 or 6..8

        // specific type constraint, one in the list.
        type  : (alpha,array,binary,boolean,component,creditcard,date,email,eurodate,float,GUID,integer,ipaddress,json,numeric,query,ssn,string,struct,telephone,url,usdate,UUID,xml,zipcode),

        // UDF to use for validation, must return boolean accept the incoming value and target object, validate(value,target):boolean
        udf = variables.UDF or this.UDF or a closure.

        // Check if a column is unique in the database
        unique = {
            table : The table name,
            column : The column to check, defaults to the property field in check
        }

        // Custom validator, must implement coldbox.system.validation.validators.IValidator
        validator : path or wirebox id, example: 'mypath.MyValidator' or 'id:MyValidator'
	}

}
```

## Constraint Profiles

You can also create profiles or selections of fields that will be targeted for validation if you are defining the constraints in objects.  All you do is create a key called: `this.constraintProfiles` which contains a struct of defined fields:

```js
this.constraintProfiles = {
	new = "fname,lname,email,password",
	update = "fname,lname,email",
	passUpdate = "password,confirmpassword"
}
```

Each key is the name of the profile like `new, update passUpdate`.  The value of the profile is a list of fields to validate within that selected profile.  In order to use it, just pass in one or more profile names into the `validate() or validateOrFail()` methods.

```js
var results = validateModel( target=model, profiles="update" )
var results = validateModel( target=model, profiles="update,passUpdate" )
```

```
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
```

### HONOR GOES TO GOD ABOVE ALL

Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the Holy Ghost which is given unto us. ." Romans 5:5

### THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
