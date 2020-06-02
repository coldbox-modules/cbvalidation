/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator checks if a field has value and not null
 */
component accessors="true" singleton {

	property name="name";

	/**
	 * Constructor
	 */
	RequiredValidator function init(){
		variables.name = "Required";
		return this;
	}

	/**
	 * Will check if an incoming value validates
	 * @validationResultThe result object of the validation
	 * @targetThe target object to validate on
	 * @fieldThe field on the target object to validate on
	 * @targetValueThe target value to validate
	 * @validationDataThe validation data the validator was created with
	 */
	boolean function validate(
		required any validationResult,
		required any target,
		required string field,
		any targetValue,
		any validationData
	){
		// check
		if ( !isBoolean( arguments.validationData ) ) {
			throw(
				message = "The Required validator data needs to be boolean and you sent in: #arguments.validationData#",
				type    = "RequiredValidator.InvalidValidationData"
			);
		}

		// return true if not required, nothing needed to check
		if ( !arguments.validationData ) {
			return true;
		}

		// Check For Value
		if ( !isNull( arguments.targetValue ) && hasValue( arguments.targetValue ) ) {
			return true;
		}

		// No data, fail it
		var args = {
			message        : "The '#arguments.field#' value is required",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : (
				isNull( arguments.targetValue ) ? "NULL" : isSimpleValue( arguments.targetValue ) ? arguments.targetValue : ""
			),
			validationData : arguments.validationData
		};

		validationResult.addError( validationResult.newError( argumentCollection = args ) );
		return false;
	}

	/**
	 * Verify if the target value has value
	 */
	boolean function hasValue( required targetValue ){
		// Simple Tests
		if ( isSimpleValue( arguments.targetValue ) AND len( trim( arguments.targetValue ) ) ) {
			return true;
		}
		// Array Tests
		if ( isArray( arguments.targetValue ) and arrayLen( arguments.targetValue ) ) {
			return true;
		}
		// Query Tests
		if ( isQuery( arguments.targetValue ) and arguments.targetValue.recordcount ) {
			return true;
		}
		// Struct Tests
		if ( isStruct( arguments.targetValue ) and structCount( arguments.targetValue ) ) {
			return true;
		}
		// Object
		if ( isObject( arguments.targetValue ) ) {
			return true;
		}

		return false;
	}

	/**
	 * Get the name of the validator
	 */
	string function getName(){
		return variables.name;
	}

}
