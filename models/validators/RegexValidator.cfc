/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates against a user defined regular expression
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	RegexValidator function init(){
		variables.name = "Regex";
		return this;
	}

	/**
	 * Will check if an incoming value validates
	 *
	 * @validationResult The result object of the validation
	 * @target           The target object to validate on
	 * @field            The field on the target object to validate on
	 * @targetValue      The target value to validate
	 * @rules            The rules imposed on the currently validating field
	 */
	boolean function validate(
		required any validationResult,
		required any target,
		required string field,
		any targetValue,
		any validationData,
		struct rules
	){
		// Verify we have a value, else skip
		if ( isNull( arguments.targetValue ) || isNullOrEmpty( arguments.targetValue ) ) {
			return true;
		}

		// Validate Regex
		if (
			isValid(
				"regex",
				arguments.targetValue,
				arguments.validationData
			)
		) {
			return true;
		}

		var args = {
			message        : "The '#arguments.field#' value does not match the regular expression: #arguments.validationData#",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};
		var error = validationResult
			.newError( argumentCollection = args )
			.setErrorMetadata( { "regex" : arguments.validationData } );
		validationResult.addError( error );
		return false;
	}

}
