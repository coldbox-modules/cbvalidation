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

		// Query string
		var qryString = "SELECT 1 FROM #arguments.validationData.table# WHERE #targetColumn# = ?";
		var qryParams = [ arguments.targetValue ];

		// check If excludeKey check has been set
		if( !isNull(arguments.validationData.excludeKey )){
			//get excludeKey column name
			var excludeKeyColumn = 
				isNull( arguments.validationData.excludeKeyColumn ) 
				? arguments.validationData.excludeKey
				: arguments.validationData.excludeKeyColumn;
			
			//get excludeKey value
			var excludeKeyValue = invoke(arguments.target,"get#arguments.validationData.excludeKey#");

			//check if excludeKey is a valid sql value
			if(	!isNull(excludeKeyValue) 
				AND isSimpleValue(excludeKeyValue)
				AND excludeKeyValue != ''
			){
				//append to sql where clause
				qryString &= ' AND #excludeKeyColumn# != ?';
				qryParams.append( excludeKeyValue );
			}
		}
		
		// Query it
		var exists = queryExecute(qryString, qryParams).recordCount > 0;

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
