/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator checks a struct of key-value pairs passed in the validation data.
 * If those key-value pairs are equal then the target field will be required
 */
component
	accessors="true"
	extends  ="RequiredValidator"
	singleton
{

	/**
	 * Constructor
	 */
	RequiredIfValidator function init(){
		variables.name = "RequiredIf";
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
		var isRequired = true;

		// If you passed in simple data, simply check that the target field has a value
		if ( isSimpleValue( arguments.validationData ) && len( arguments.validationData ) ) {
			var otherFieldValue = invoke( target, "get#arguments.validationData#" );
			isRequired          = !isNull( otherFieldValue ) && hasValue( otherFieldValue );
		} else if ( isStruct( arguments.validationData ) ) {
			// Inflate to array to test multiple properties
			isRequired = arguments.validationData
				.map( function( key, value ){
					// Get comparison values
					var comparePropertyValue = invoke( target, "get#arguments.key#" );
					// Null checks
					if ( isNull( comparePropertyValue ) ) {
						return isNull( arguments.value ) || !hasValue( arguments.value );
					}
					// Check if the compareValue is the same as the defined one
					return ( arguments.value == comparePropertyValue ? true : false );
				} )
				// AND them all for a single result
				.reduce( function( result, key, value ){
					return ( arguments.value && arguments.result );
				}, true );
		} else {
			validationResult.addError(
				validationResult.newError(
					message        = "The target for RequiredIf must be a simple field name or a struct of field to target value pairs.",
					field          = arguments.field,
					validationType = getName(),
					rejectedValue  = arguments.validationData,
					validationData = arguments.validationData
				)
			);
			return false;
		}

		if ( !isRequired ) {
			return true;
		}

		// Else target is required
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

}
