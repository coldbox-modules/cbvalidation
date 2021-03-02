/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * The field under validation must be yes, on, 1, or true. This is useful for validating "Terms of Service" acceptance.
 */
component accessors="true" singleton {

	property name="name";

    /**
     * check if field is NOT null and has length
     * 
     * @targetValue the value to check for nullness/emptyness
     * @return boolean
     */
    boolean function isNullOrEmpty(required any targetValue){
        return isNull( arguments.targetValue ) || (isSimpleValue( arguments.targetValue ) && !len( arguments.targetValue ));
    }

    /**
	 * Get the name of the validator
	 */
	string function getName(){
		return variables.name;
	}
}