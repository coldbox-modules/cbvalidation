/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates if a field is NOT the same as another field with case sensitivity
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	NotSameAsValidator function init(){
		variables.name = "NotSameAs";
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

		// get secondary value from property
		var compareValue = invoke( arguments.target, "get#arguments.validationData#" );

		// Compare it now
		if ( compare( arguments.targetValue, compareValue ) NEQ 0 ) {
			return true;
		}
		var args = {
			message        : "The '#arguments.field#' value is the same as #compareValue.toString()#",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};
		var error = validationResult
			.newError( argumentCollection = args )
			.setErrorMetadata( { "notsameas" : arguments.validationData } );
		validationResult.addError( error );
		return false;
	}

}
