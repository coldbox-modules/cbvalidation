/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates against a unique method
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	MethodValidator function init(){
		variables.name = "Method";
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
		var errorMetadata = {};

		// return true if no data to check, type needs a data element to be checked.
		if ( isNull( arguments.targetValue ) || isNullOrEmpty( arguments.targetValue ) ) {
			return true;
		}

		// return true if no data to check, type needs a data element to be checked.
		if ( isNull( arguments.targetValue ) || isNullOrEmpty( arguments.targetValue ) ) {
			return true;
		}

		// Validate via method
		if (
			invoke(
				arguments.target,
				arguments.validationData,
				[ arguments.targetValue, errorMetadata ]
			)
		) {
			return true;
		}

		var args = {
			message        : "The '#arguments.field#' value does not validate",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};

		validationResult.addError(
			validationResult.newError( argumentCollection = args ).setErrorMetadata( errorMetadata )
		);
		return false;
	}

}
