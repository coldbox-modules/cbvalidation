/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator checks a struct of key-value pairs passed in the validation data.
 * If those key-value pairs are equal then the target field will NOT be required
 */
component
	accessors="true"
	extends  ="RequiredValidator"
	singleton
{

	property name="name";

	/**
	 * Constructor
	 */
	RequiredUnlessValidator function init(){
		variables.name = "RequiredUnless";
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
		// If you passed in simple data, conver it to a struct, simple values are not evaluated
		if ( isSimpleValue( arguments.validationData ) ) {
			arguments.validationData = {};
		}

		// Test the data
		var isOptional = arguments.validationData
			.map( function( key, value ){
				// Get comparison values
				var comparePropertyValue = invoke( target, "get#key#" );
				// Null checks
				if ( isNull( comparePropertyValue ) ) {
					return isNull( arguments.value );
				}
				// Check if the compareValue is the same as the defined one
				return ( arguments.value == comparePropertyValue ? true : false );
			} )
			// AND them all for a single result
			.reduce( function( result, key, value ){
				return ( arguments.value && arguments.result );
			}, true );

		// If we have data, then test the optional
		if ( arguments.validationData.count() && isOptional ) {
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
