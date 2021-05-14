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
	 * check if field is NOT null and has length
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

}
