/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator checks the database according to validation data for field uniqueness
 * - table : The table name to seek
 * - column : The column to evaluate for uniqueness or defaults to the name of the field
 */
component accessors="true" singleton {

	property name="name";

	/**
	 * Constructor
	 */
	UniqueValidator function init(){
		variables.name = "Unique";
		return this;
	}

	/**
	 * Will check if an incoming value validates
	 *
	 * @validationResult The result object of the validation
	 * @target The target object to validate on
	 * @field The field on the target object to validate on
	 * @targetValue The target value to validate
	 * @validationData The validation data the validator was created with
	 */
	boolean function validate(
		required any validationResult,
		required any target,
		required string field,
		any targetValue,
		any validationData
	){
		// Default the target column
		var targetColumn = ( isNull( arguments.validationData.column ) ? arguments.field : arguments.validationData.column );
		// Query it
		var exists       = queryExecute(
			"SELECT 1 FROM #arguments.validationData.table# WHERE #targetColumn# = ?",
			[ arguments.targetValue ]
		).recordCount > 0;

		if ( !exists ) {
			return true;
		}

		validationResult.addError(
			validationResult.newError(
				argumentCollection = {
					message        : "The #targetColumn# '#arguments.targetValue#' is already in use",
					field          : arguments.field,
					validationType : getName(),
					validationData : arguments.validationData
				}
			)
		);

		return false;
	}

	/**
	 * Get the name of the validator
	 */
	string function getName(){
		return "Unique";
	}

}
