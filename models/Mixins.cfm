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

</cfscript>
