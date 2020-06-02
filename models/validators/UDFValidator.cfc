/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates against a UDF
 */
component accessors="true" singleton {

	property name="name";

	/**
	 * Constructor
	 */
	UDFValidator function init(){
		variables.name = "UDF";
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
		// Validate against the UDF/closure
		var passed = arguments.validationData(
			isNull( arguments.targetValue ) ? javacast( "null", "" ) : arguments.targetValue,
			arguments.target
		);

		if ( passed ) {
			return true;
		}

		var args = {
			message        : "The '#arguments.field#' value does not validate",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : !isNull( arguments.targetValue ) && isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "",
			validationData : arguments.validationData
		};

		validationResult.addError( validationResult.newError( argumentCollection = args ) );

		return false;
	}

	/**
	 * Get the name of the validator
	 */
	string function getName(){
		return variables.name;
	}

}
