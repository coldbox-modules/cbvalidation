/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Evaluates if the target date is before or equal the validation date
 */
component extends="BaseValidator" accessors="true" singleton {

	/**
	 * Constructor
	 */
	BeforeOrEqualValidator function init(){
		variables.name = "BeforeOrEqual";
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
	 *
	 * @throws InvalidValidationData If the passed target value is not a date
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
		if ( isNull( arguments.targetValue ) || isNullOrEmpty( arguments.targetValue ) ) {
			return true;
		}
		// If not a date, throw it
		if ( !isDate( arguments.targetValue ) ) {
			validationResult.addError(
				validationResult.newError(
					argumentCollection = {
						message        : "The '#arguments.targetValue#' is not a valid date, so we cannot compare them.",
						field          : arguments.field,
						validationType : getName(),
						rejectedValue  : ( arguments.targetValue ),
						validationData : arguments.validationData,
						errorMetadata  : { "afterOrEqual" : arguments.targetValue }
					}
				)
			);
			return false;
		}

		// The compare value is set or it can be another field
		var compareValue = arguments.validationData;
		if ( !isDate( compareValue ) ) {
			compareValue = invoke( arguments.target, "get#arguments.validationData#" );
		}

		// return true if no value to compare against
		if ( isNull( compareValue ) || isNullOrEmpty( compareValue ) ) {
			return true;
		}

		/**
		 * -1 if date1 is before than date2
		 * 0 if date1 is equal to date2
		 * 1 if date1 is after than date2
		 */
		if ( dateCompare( arguments.targetValue, compareValue ) <= 0 ) {
			return true;
		}

		validationResult.addError(
			validationResult.newError(
				argumentCollection = {
					message        : "The '#arguments.field#' is not before or equal the validation date of [#compareValue#]",
					field          : arguments.field,
					validationType : getName(),
					rejectedValue  : ( arguments.targetValue ),
					validationData : arguments.validationData,
					errorMetadata  : { "beforeOrEqual" : compareValue }
				}
			)
		);

		return false;
	}

}
