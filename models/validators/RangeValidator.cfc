/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates if an incoming value exists in a range of values
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	RangeValidator function init(){
		variables.name = "Range";
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

		// check
		if (
			!isValid( "string", arguments.validationData ) || !isValid(
				"regex",
				arguments.validationData,
				"(\-?\d)+\.\.\-?\d+"
			)
		) {
			throw(
				message = "The range you sent is invalid: #arguments.validationData#",
				detail  = "It must be in the format of {minNumber}..{maxNumber}",
				type    = "RangeValidator.InvalidValidationData"
			);
		}

		var min = listFirst( arguments.validationData, ".." );
		var max = "";
		if ( find( "..", arguments.validationData ) ) {
			max = listLast( arguments.validationData, ".." );
		}

		// simple value range evaluations?
		if ( !isNull( arguments.targetValue ) AND targetValue >= min AND ( !len( max ) OR targetValue <= max ) ) {
			return true;
		}
		var args = {
			message        : "The '#arguments.field#' value is not the value field range (#arguments.validationData#)",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};
		var error = validationResult
			.newError( argumentCollection = args )
			.setErrorMetadata( {
				"range" : arguments.validationData,
				"min"   : min,
				"max"   : max
			} );
		validationResult.addError( error );
		return false;
	}

}
