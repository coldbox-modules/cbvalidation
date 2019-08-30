/**
 * *******************************************************************************
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * *******************************************************************************
 * Great for when you want to validate a form that is not represented by an object.
 * A generic object that can simulate an object getters from a collection structure.
 */
component{

	/**
	 * Constructor
	 *
	 * @memento The struct to represent
	 */
	GenericObject function init( struct memento=structNew() ){
		variables.collection = arguments.memento;
		return this;
	}

	/**
	 * Retrieve the collection
	 */
	any function getMemento(){
		return variables.collection;
	}

	/**
	 * Process dynamic getters
	 *
	 * @missingMethodName
	 * @missingMethodArguments
	 */
	any function onMissingMethod( required string missingMethodName, required struct missingMethodArguments ){
		var key = replacenocase( arguments.missingMethodName, "get", "" );

		if( structKeyExists( variables.collection, key ) ){
			return variables.collection[ key ];
		}

		// Return null
	}
}