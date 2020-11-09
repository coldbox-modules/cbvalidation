/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * The field under validation must be yes, on, 1, or true. This is useful for validating "Terms of Service" acceptance.
 */
component accessors="true" singleton {

	property name="name";

	/**
	 * Constructor
	 */
	AlphaValidator function init(){
		variables.name = "Alpha";
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
		// return true if no data to check, type needs a data element to be checked.
		if (
			isNull( arguments.targetValue ) || ( isSimpleValue( arguments.targetValue ) && !len( arguments.targetValue ) )
		) {
			return true;
		}

		// Alpha only
		if ( reFindNoCase( "^[A-Za-z]+$", arguments.targetValue ) ) {
			return true;
		}

		var args = {
			message        : "The '#arguments.field#' is not alpha only",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};
		var error = validationResult.newError( argumentCollection = args ).setErrorMetadata( { 'max' : arguments.validationData } );
		validationResult.addError( error );
		return false;
	}

	/**
	 * Get the name of the validator
	 */
	string function getName(){
		return variables.name;
	}

}
