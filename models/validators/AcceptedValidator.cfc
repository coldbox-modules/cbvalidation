/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * The field under validation must be yes, on, 1, or true. This is useful for validating "Terms of Service" acceptance.
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	AcceptedValidator function init(){
		variables.name = "Accepted";
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
		// return true if no data to check, type needs a data element to be checked.
		if ( isNull( arguments.targetValue ) || isNullOrEmpty( arguments.targetValue ) ) {
			return true;
		}

		if ( listFindNoCase( "1,yes,true,on", arguments.targetValue ) ) {
			return true;
		}

		var args = {
			message        : "The '#arguments.field#' is not a 1, yes, true or on",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};
		var error = validationResult
			.newError( argumentCollection = args )
			.setErrorMetadata( { "max" : arguments.validationData } );
		validationResult.addError( error );
		return false;
	}

}
