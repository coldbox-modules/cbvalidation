/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator will validate array items according to the validation data passed.
 * All items must pass the validation in order for this validation to pass.
 */
component extends="BaseValidator" accessors="true" singleton {

	NestedConstraintsValidator function init(){
		variables.name = "NestedConstraintsValidator";
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
		if ( isNull( arguments.targetValue ) ) {
			return true;
		}

		// return false if the value is not a struct.
		if ( !isStruct( arguments.targetValue ) ) {
			var args = {
				message : "The '#arguments.field#' value '#(
					isSimpleValue( arguments.targetValue ) ? arguments.targetValue : serializeJSON(
						arguments.targetValue
					)
				)#' is not a Struct",
				field          : arguments.field,
				validationType : getName(),
				rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
				validationData : arguments.validationData
			};
			var error = validationResult
				.newError( argumentCollection = args )
				.setErrorMetadata( { "validationData" : arguments.validationData } );
			validationResult.addError( error );
			return false;
		}

		var vResult = variables.validationManager.validate(
			target      = arguments.targetValue,
			constraints = arguments.validationData
		);
		// Process errors into validation result
		vResult
			.getErrors()
			.each( function( error ){
				arguments.error.setField( "#field#.#arguments.error.getField()#" );
				validationResult.addError( arguments.error );
			} );

		return !vResult.hasErrors();
	}

	/**
	 * Get the name of the validator
	 */
	string function getName(){
		return variables.name;
	}

}
