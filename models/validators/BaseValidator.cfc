/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * All validators should inherit from this abstract utility object
 */
component accessors=true {

	// DI
	property name="ValidationManager" inject="ValidationManager@cbvalidation";

	/**
	 * The validator's unique human name
	 */
	property name="name";

	/**
	 * Check if a value is null or is a simple value and it's empty
	 *
	 * @targetValue the value to check for nullness/emptyness
	 *
	 * @return boolean
	 */
	boolean function isNullOrEmpty( any targetValue ){
		return isNull( arguments.targetValue ) || (
			isSimpleValue( arguments.targetValue ) && !len( arguments.targetValue )
		);
	}

	/**
	 * Verify if the target value has a value
	 * Checks for nullness or for length if it's a simple value, array, query, struct or object.
	 */
	boolean function hasValue( any targetValue ){
		// Null Tests
		if ( isNull( arguments.targetValue ) ) {
			return false;
		}
		// Simple Tests
		if ( isSimpleValue( arguments.targetValue ) AND len( trim( arguments.targetValue ) ) ) {
			return true;
		}
		// Array Tests
		if ( isArray( arguments.targetValue ) and arrayLen( arguments.targetValue ) ) {
			return true;
		}
		// Query Tests
		if ( isQuery( arguments.targetValue ) and arguments.targetValue.recordcount ) {
			return true;
		}
		// Struct Tests
		if ( isStruct( arguments.targetValue ) and structCount( arguments.targetValue ) ) {
			return true;
		}
		// Object
		if ( isObject( arguments.targetValue ) ) {
			return true;
		}
		return false;
	}

}
