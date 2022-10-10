/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator verifies field type
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	InstanceOfValidator function init(){
		variables.name = "InstanceOf";
		return this;
	}

	/**
	 * Will check if an incoming instance type
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

		// value is valid if it is an object and of the correct type
		var r = (
			isObject( arguments.targetValue ) &&
			isInstanceOf( arguments.targetValue, arguments.validationData )
		);

		if ( !r ) {
			var args = {
				message        : "The '#arguments.field#' has an invalid instance type, expected type is #arguments.validationData#",
				field          : arguments.field,
				validationType : getName(),
				rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
				validationData : arguments.validationData
			};
			var error = validationResult
				.newError( argumentCollection = args )
				.setErrorMetadata( { "type" : arguments.validationData } );
			validationResult.addError( error );
		}

		return r;
	}

}
