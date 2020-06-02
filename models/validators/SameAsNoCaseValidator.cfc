/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates if a field is the same as another field with no case sensitivity
 */
component accessors="true" singleton {

	property name="name";

	/**
	 * Constructor
	 */
	SameAsNoCaseValidator function init(){
		variables.name = "SameAsNoCase";
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
		// get secondary value from property
		var compareValue = invoke(
			arguments.target,
			"get#arguments.validationData#"
		);

		// Check if both null values
		if ( isNull( arguments.targetValue ) && isNull( compareValue ) ) {
			return true;
		}

		// return true if no data to check, type needs a data element to be checked.
		if (
			isNull( arguments.targetValue ) || ( isSimpleValue( arguments.targetValue ) && !len( arguments.targetValue ) )
		) {
			return true;
		}

		// Evaluate now
		if ( compareNoCase( arguments.targetValue, compareValue ) EQ 0 ) {
			return true;
		}

		var args = {
			message        : "The '#arguments.field#' value is not the same as #compareValue.toString()#",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};
		var error = validationResult.newError( argumentCollection = args ).setErrorMetadata( { sameas : arguments.validationData } );
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
