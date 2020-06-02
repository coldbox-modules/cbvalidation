/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates against a user defined regular expression
 */
component accessors="true" singleton {

	property name="name";

	/**
	 * Constructor
	 */
	RegexValidator function init(){
		variables.name = "Regex";
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
		// Verify we have a value, else skip
		if (
			isNull( arguments.targetValue ) || ( isSimpleValue( arguments.targetValue ) && !len( arguments.targetValue ) )
		) {
			return true;
		}

		// Validate Regex
		if (
			isValid(
				"regex",
				arguments.targetValue,
				arguments.validationData
			)
		) {
			return true;
		}

		var args = {
			message        : "The '#arguments.field#' value does not match the regular expression: #arguments.validationData#",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};
		var error = validationResult.newError( argumentCollection = args ).setErrorMetadata( { regex : arguments.validationData } );
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
