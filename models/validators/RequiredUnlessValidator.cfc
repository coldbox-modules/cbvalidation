/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator checks if a field has value and not null
 */
component accessors="true" extends="RequiredValidator" singleton {

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
		// Validation Data Format: property:value,...
		var validationArray = arguments.validationData.listToArray();
		// Inflate to array to test multiple properties
		var isOptional = validationArray
			.map( function( item ){
				// Get comparison values
				var compareProperty 		= getToken( arguments.item, 1, ":" );
				var compareValue 			= getToken( arguments.item, 2, ":" );
				var comparePropertyValue 	= invoke( target, "get#compareProperty#" );
				// Check if the compareValue is the same as the defined one
                if ( isNull( compareValue ) || isNull( comparePropertyValue ) ) {
                    return isNull( compareValue ) == isNull( comparePropertyValue );
                }
				return compareValue == comparePropertyValue;
			} )
			// AND them all for a single result
			.reduce( function( result, item ){
				return ( arguments.item && arguments.result );
			}, true );

		if( validationArray.len() && isOptional ){
			return true;
		}

		// Else target is required
		// Check For Value
		if( !isNull( arguments.targetValue ) && hasValue( arguments.targetValue ) ){
			return true;
		}

		// No data, fail it
		var args = {
			message        : "The '#arguments.field#' value is required",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isNull( arguments.targetValue ) ? "NULL" : isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};

		validationResult.addError( validationResult.newError( argumentCollection = args ) );
		return false;
	}

}
