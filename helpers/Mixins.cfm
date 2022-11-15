<cfscript>

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
function validate(){
	return getValidationManager().validate( argumentCollection=arguments );
}

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
function validateOrFail(){
	return getValidationManager().validateOrFail( argumentCollection=arguments );
}

/**
 * Retrieve the application's configured Validation Manager
 */
function getValidationManager(){
	return wirebox.getInstance( "ValidationManager@cbvalidation" );
}

/**
 * @deprecated
 *
 * Marked for deprecation, use `validate()` instead
 */
function validateModel(
	required any target,
	string fields="*",
	any constraints,
	string locale="",
	string excludeFields="",
	string includeFields=""
){
	return getValidationManager().validate( argumentCollection=arguments );
}

/**
 * Verify if the target value has a value
 * Checks for nullness or for length if it's a simple value, array, query, struct or object.
 */
boolean function validateHasValue( any targetValue ){
	return getValidationManager().getValidator( "Required", {} ).hasValue( argumentCollection = arguments );
}

/**
 * Check if a value is null or is a simple value and it's empty
 *
 * @targetValue the value to check for nullness/emptyness
 */
boolean function validateIsNullOrEmpty( any targetValue ){
	return !getValidationManager().getValidator( "Required", {} ).hasValue( argumentCollection = arguments );
}

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
boolean function assert( target, message="" ){
	if( !isNull( arguments.target ) && arguments.target ){
		return true;
	}
	throw(
		type : "AssertException",
		message : len( arguments.message ) ? arguments.message : "Assertion failed from #callStackGet()[2].toString()#"
	);
}
</cfscript>
