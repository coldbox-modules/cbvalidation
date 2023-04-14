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
	TypeValidator function init(){
		variables.name       = "Type";
		variables.validTypes = "alpha,array,binary,boolean,component,creditcard,date,email,eurodate,float,GUID,integer,ipaddress,json,numeric,query,ssn,string,struct,telephone,url,usdate,UUID,xml,zipcode";

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
		// check incoming type
		if ( !reFindNoCase( "^(#replace( variables.validTypes, ",", "|", "all" )#)$", arguments.validationData ) ) {
			throw(
				message = "The type you sent is invalid: #arguments.validationData#",
				detail  = "Valid types are #variables.validTypes#",
				type    = "TypeValidator.InvalidValidationData"
			);
		}

		// return true if no data to check, type needs a data element to be checked.
		if ( isNull( arguments.targetValue ) ) {
			return true;
		}

		var r = false;

		switch ( arguments.validationData ) {
			case "float": {
				r = isValid( "float", arguments.targetValue );
				break;
			}
			case "ssn": {
				r = isValid( "ssn", arguments.targetValue );
				break;
			}
			case "email": {
				r = isValid( "email", arguments.targetValue );
				break;
			}
			case "url": {
				r = isValid( "url", arguments.targetValue );
				break;
			}
			case "alpha": {
				r = ( reFindNoCase( "^[a-zA-Z\s]*$", arguments.targetValue ) gt 0 );
				break;
			}
			case "boolean": {
				r = isValid( "boolean", arguments.targetValue );
				break;
			}
			case "date": {
				r = isValid( "date", arguments.targetValue );
				break;
			}
			case "usdate": {
				r = isValid( "usdate", arguments.targetValue );
				break;
			}
			case "eurodate": {
				r = isValid( "eurodate", arguments.targetValue );
				break;
			}
			case "numeric": {
				r = isValid( "numeric", arguments.targetValue );
				break;
			}
			case "guid": {
				r = isValid( "guid", arguments.targetValue );
				break;
			}
			case "uuid": {
				r = isValid( "uuid", arguments.targetValue );
				break;
			}
			case "integer": {
				r = isValid( "integer", arguments.targetValue );
				break;
			}
			case "string": {
				r = isValid( "string", arguments.targetValue );
				break;
			}
			case "telephone": {
				r = isValid( "telephone", arguments.targetValue );
				break;
			}
			case "zipcode": {
				r = isValid( "zipcode", arguments.targetValue );
				break;
			}
			case "ipaddress": {
				r = (
					reFindNoCase(
						"\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b",
						arguments.targetvalue
					) gt 0
				);
				break;
			}
			case "creditcard": {
				r = isValid( "creditcard", arguments.targetValue );
				break;
			}
			case "component": {
				r = isValid( "component", arguments.targetValue );
				break;
			}
			case "query": {
				r = isValid( "query", arguments.targetValue );
				break;
			}
			case "struct": {
				r = isValid( "struct", arguments.targetValue );
				break;
			}
			case "array": {
				r = isValid( "array", arguments.targetValue );
				break;
			}
			case "json": {
				r = isJSON( arguments.targetValue );
				break;
			}
			case "xml": {
				r = isXML( arguments.targetValue );
				break;
			}
			case "binary": {
				r = isValid( "binary", arguments.targetValue );
				break;
			}
		}

		if ( !r ) {
			var args = {
				message        : "The '#arguments.field#' has an invalid type, expected type is #arguments.validationData#",
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
