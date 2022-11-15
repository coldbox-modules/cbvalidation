/**
 * Copyright since 2016 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This delegate helps models validate themselves
 */
component accessors="true" {

	// DI
	property name="validationManager" inject="ValidationManager@cbvalidation";

	// Properties
	property name="validationResults";

	/**
	 * Validate the $parent and stores a validation result in the delegate
	 *
	 * @fields        One or more fields to validate on, by default it validates all fields in the constraints. This can be a simple list or an array.
	 * @constraints   An optional shared constraints name or an actual structure of constraints to validate on.
	 * @locale        An optional locale to use for i18n messages
	 * @excludeFields An optional list of fields to exclude from the validation.
	 * @IncludeFields An optional list of fields to include in the validation.
	 * @profiles      If passed, a list of profile names to use for validation constraints
	 */
	boolean function isValid(
		string fields        = "*",
		any constraints      = "",
		string locale        = "",
		string excludeFields = "",
		string includeFields = "",
		string profiles      = ""
	){
		// validate and save results in private scope
		variables.validationResults = validate( argumentCollection = arguments );

		// return it
		return ( !variables.validationResults.hasErrors() );
	}

	/**
	 * Get the validation results object.  This will be an empty validation object if isValid() has not being called yet.
	 *
	 * @return cbvalidation.models.result.IValidationResult
	 */
	any function getValidationResults(){
		if ( !isNull( variables.validationResults ) && isObject( variables.validationResults ) ) {
			return variables.validationResults;
		}
		return new cbvalidation.models.result.ValidationResult();
	}

	/**
	 * Validate the parent delegate
	 *
	 * @fields        The fields to validate on the target. By default, it validates on all fields
	 * @constraints   A structure of constraint rules or the name of the shared constraint rules to use for validation
	 * @locale        The i18n locale to use for validation messages
	 * @excludeFields The fields to exclude from the validation
	 * @includeFields The fields to include in the validation
	 * @profiles      If passed, a list of profile names to use for validation constraints
	 *
	 * @return cbvalidation.model.result.IValidationResult
	 */
	function validate(){
		arguments.target = $parent;
		return variables.validationManager.validate( argumentCollection = arguments );
	}

	/**
	 * Validate an object or structure according to the constraints rules and throw an exception if the validation fails.
	 * The validation errors will be contained in the `extendedInfo` of the exception in JSON format
	 *
	 * @fields        The fields to validate on the target. By default, it validates on all fields
	 * @constraints   A structure of constraint rules or the name of the shared constraint rules to use for validation
	 * @locale        The i18n locale to use for validation messages
	 * @excludeFields The fields to exclude from the validation
	 * @includeFields The fields to include in the validation
	 * @profiles      If passed, a list of profile names to use for validation constraints
	 *
	 * @return The validated object or the structure fields that where validated
	 *
	 * @throws ValidationException
	 */
	function validateOrFail(){
		arguments.target = $parent;
		return variables.validationManager.validateOrFail( argumentCollection = arguments );
	}

	/**
	 * Verify if the target value has a value
	 * Checks for nullness or for length if it's a simple value, array, query, struct or object.
	 */
	boolean function validateHasValue( any targetValue ){
		return variables.validationManager
			.getValidator( "Required", {} )
			.hasValue( argumentCollection = arguments );
	}

	/**
	 * Check if a value is null or is a simple value and it's empty
	 *
	 * @targetValue the value to check for nullness/emptyness
	 */
	boolean function validateIsNullOrEmpty( any targetValue ){
		return !variables.validationManager
			.getValidator( "Required", {} )
			.hasValue( argumentCollection = arguments );
	}

	/**
	 * This method mimics the Java assert() function, where it evaluates the target to a boolean value and it must be true
	 * to pass and return a true to you, or throw an `AssertException`
	 *
	 * @target  The tareget to evaluate for being true
	 * @message The message to send in the exception
	 *
	 * @return True, if the target is a non-null value. If false, then it will throw the `AssertError` exception
	 *
	 * @throws AssertException if the target is a false or null value
	 */
	boolean function assert( target, message = "" ){
		if ( !isNull( arguments.target ) && arguments.target ) {
			return true;
		}
		throw(
			type   : "AssertException",
			message: len( arguments.message ) ? arguments.message : "Assertion failed from #callStackGet()[ 2 ].toString()#"
		);
	}

}
