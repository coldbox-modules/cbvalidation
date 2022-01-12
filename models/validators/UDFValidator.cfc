/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates against a UDF
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	UDFValidator function init(){
		variables.name = "UDF";
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
		var errorMetadata = {};

		// Validate against the UDF/closure
		var passed = arguments.validationData(
			isNull( arguments.targetValue ) ? javacast( "null", "" ) : arguments.targetValue,
			arguments.target,
			errorMetadata
		);

		if ( passed ) {
			return true;
		}

		var args = {
			message        : "The '#arguments.field#' value does not validate",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : !isNull( arguments.targetValue ) && isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "",
			validationData : arguments.validationData
		};

		validationResult.addError(
			validationResult.newError( argumentCollection = args ).setErrorMetadata( errorMetadata )
		);

		return false;
	}

}
