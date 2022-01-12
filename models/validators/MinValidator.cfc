/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates if a value is is greater than a minimum number
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	MinValidator function init(){
		variables.name = "Min";
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
		// return true if no data to check, type needs a data element to be checked.
		if ( isNull( arguments.targetValue ) || isNullOrEmpty( arguments.targetValue ) ) {
			return true;
		}

		// Min Tests
		if ( arguments.targetValue >= arguments.validationData ) {
			return true;
		}

		var args = {
			message        : "The '#arguments.field#' value is not greater than or equal to #arguments.validationData#",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};
		var error = validationResult
			.newError( argumentCollection = args )
			.setErrorMetadata( { "min" : arguments.validationData } );
		validationResult.addError( error );
		return false;
	}

}
