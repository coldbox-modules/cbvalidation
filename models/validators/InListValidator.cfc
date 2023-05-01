/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates if an incoming value exists in a certain list
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	InListValidator function init(){
		variables.name = "InList";
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

		// check data element value and return error if it is not simple value.
		if ( !isSimpleValue( arguments.targetValue ) ) {
			var args = {
				message        : "The '#arguments.field#' value is not a Simple value",
				field          : arguments.field,
				validationType : getName(),
				rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
				validationData : arguments.validationData
			};
			var error = validationResult
				.newError( argumentCollection = args )
				.setErrorMetadata( { "inlist" : arguments.validationData } );
			validationResult.addError( error );
			return false;
		}

		// Now check
		if ( listFindNoCase( arguments.validationData, arguments.targetValue ) ) {
			return true;
		}

		var args = {
			message        : "The '#arguments.field#' value is not in the constraint list: #arguments.validationData#",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};

		var error = validationResult
			.newError( argumentCollection = args )
			.setErrorMetadata( { "inlist" : arguments.validationData } );

		validationResult.addError( error );
		return false;
	}

}
