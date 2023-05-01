/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	DiscreteValidator function init(){
		variables.name       = "Discrete";
		variables.validTypes = "eq,neq,lt,lte,gt,gte";
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
		if ( !find( ":", arguments.validationData ) OR listLen( arguments.validationData, ":" ) LT 2 ) {
			throw(
				message = "The validator data is invalid: #arguments.validationData#, it must follow the format 'operation:value', like eq:4, gt:4",
				type    = "DiscreteValidator.InvalidValidationData"
			);
		}

		var operation      = getToken( arguments.validationData, 1, ":" );
		var operationValue = getToken( arguments.validationData, 2, ":" );

		if ( !reFindNoCase( "^(#replace( variables.validTypes, ",", "|", "all" )#)$", operation ) ) {
			throw(
				message = "The validator data is invalid: #arguments.validationData#",
				detail  = "Valid discrete types are #variables.validTypes#",
				type    = "DiscreteValidator.InvalidValidationData"
			);
		}

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
				.setErrorMetadata( {
					"operation"      : operation,
					"operationValue" : operationValue
				} );
			validationResult.addError( error );
			return false;
		}

		var r = false;
		if ( !isNull( arguments.targetValue ) ) {
			switch ( operation ) {
				case "eq": {
					r = ( arguments.targetValue eq operationValue );
					break;
				}
				case "neq": {
					r = ( arguments.targetValue neq operationValue );
					break;
				}
				case "lt": {
					r = ( arguments.targetValue lt operationValue );
					break;
				}
				case "lte": {
					r = ( arguments.targetValue lte operationValue );
					break;
				}
				case "gt": {
					r = ( arguments.targetValue gt operationValue );
					break;
				}
				case "gte": {
					r = ( arguments.targetValue gte operationValue );
					break;
				}
			}
		}

		if ( !r ) {
			var args = {
				message        : "The '#arguments.field#' value is #operation# than #operationValue#",
				field          : arguments.field,
				validationType : getName(),
				rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
				validationData : arguments.validationData
			};
			var error = validationResult
				.newError( argumentCollection = args )
				.setErrorMetadata( {
					"operation"      : operation,
					"operationValue" : operationValue
				} );
			validationResult.addError( error );
		}

		return r;
	}

}
