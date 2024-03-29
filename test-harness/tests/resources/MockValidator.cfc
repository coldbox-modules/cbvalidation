component accessors="true" singleton {

	property name="name";

	MockValidator function init(){
		name = "Mock";
		return this;
	}

	/**
	 * Will check if an incoming value validates
	 *
	 * @validationResult.hint The result object of the validation
	 * @target.hint           The target object to validate on
	 * @field.hint            The field on the target object to validate on
	 * @targetValue.hint      The target value to validate
	 * @validationData.hint   The validation data the validator was created with
	 */
	boolean function validate(
		required any validationResult,
		required any target,
		required string field,
		any targetValue,
		any validationData
	){
		return true;
	}

	/**
	 * Get the name of the validator
	 */
	string function getName(){
		return name;
	}

}
