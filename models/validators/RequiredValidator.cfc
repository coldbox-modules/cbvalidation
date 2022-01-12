/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator checks if a field has value and not null
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	RequiredValidator function init(){
		variables.name = "Required";
		return this;
	}

	/**
	 * Will check if an incoming value validates
	 *
	 * @validationResult The result object of the validation
	 * @target           The target object to validate on
	 * @field            The field on the target object to validate on
	 * @targetValue      The target value to validate
	 * @validationData   The validation data the validator was created with
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
		// check
		if ( !isBoolean( arguments.validationData ) ) {
			throw(
				message = "The Required validator data needs to be boolean and you sent in: #arguments.validationData#",
				type    = "RequiredValidator.InvalidValidationData"
			);
		}

		// return true if not required, nothing needed to check
		if ( !arguments.validationData ) {
			return true;
		}

		// Check For Value
		if ( !isNull( arguments.targetValue ) && hasValue( arguments.targetValue ) ) {
			return true;
		}

		// No data, fail it
		var args = {
			message        : "The '#arguments.field#' value is required",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : (
				isNull( arguments.targetValue ) ? "NULL" : isSimpleValue( arguments.targetValue ) ? arguments.targetValue : ""
			),
			validationData : arguments.validationData
		};

		validationResult.addError( validationResult.newError( argumentCollection = args ) );
		return false;
	}

}
