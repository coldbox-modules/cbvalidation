/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates the size or length of the value of a field
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	SizeValidator function init(){
		variables.name = "Size";
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

		// check
		if (
			!isValid( "string", arguments.validationData ) ||
			!reFind( "(\-?\d)+(?:\.\.\-?\d+)?", arguments.validationData )
		) {
			throw(
				message = "The range you sent is invalid: #arguments.validationData#",
				detail  = "It must be in the format of {minNumber}..{maxNumber} or {minNumber}",
				type    = "SizeValidator.InvalidValidationData"
			);
		}

		var min = listFirst( arguments.validationData, ".." );
		var max = min;
		if ( find( "..", arguments.validationData ) ) {
			max = listLast( arguments.validationData, ".." );
		}

		// simple size evaluations?
		if ( !isNull( arguments.targetValue ) AND isSimpleValue( targetValue ) ) {
			if ( len( trim( targetValue ) ) >= min AND ( !len( max ) OR len( trim( targetValue ) ) <= max ) ) {
				return true;
			}
		}
		// complex objects
		else if ( !isNull( arguments.targetValue ) ) {
			// Arrays
			if (
				isArray( targetValue ) AND (
					arrayLen( targetValue ) >= min AND ( !len( max ) OR arrayLen( targetvalue ) <= max )
				)
			) {
				return true;
			}
			// query
			else if (
				isQuery( targetValue ) AND (
					targetValue.recordcount >= min AND ( !len( max ) OR targetvalue.recordcount <= max )
				)
			) {
				return true;
			}
			// structure
			else if (
				isStruct( targetValue ) AND (
					structCount( targetValue ) >= min AND ( !len( max ) OR structCount( targetvalue ) <= max )
				)
			) {
				return true;
			}
		}

		var args = {
			message        : "The '#arguments.field#' value is not in the required size range (#arguments.validationData#)",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};

		var error = validationResult
			.newError( argumentCollection = args )
			.setErrorMetadata( {
				"size" : arguments.validationData,
				"min"  : min,
				"max"  : max
			} );
		validationResult.addError( error );
		return false;
	}

}
