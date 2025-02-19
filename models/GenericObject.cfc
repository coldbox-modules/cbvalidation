/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Great for when you want to validate a form that is not represented by an object.
 * A generic object that can simulate an object getters from a collection structure.
 */
component {

	/**
	 * Constructor
	 *
	 * @memento The struct to represent
	 */
	GenericObject function init( struct memento = structNew() ){
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
	any function onMissingMethod( required string missingMethodName, required any missingMethodArguments ){
		if ( startsWith( arguments.missingMethodName, "set" ) ) {
			var key = mid(
				arguments.missingMethodName,
				4,
				len( arguments.missingMethodName ) - 3
			);
			variables.collection[ key ] = arguments.missingMethodArguments[ 1 ];
			return variables.collection[ key ];
		}

		if ( startsWith( arguments.missingMethodName, "get" ) ) {
			var key = mid(
				arguments.missingMethodName,
				4,
				len( arguments.missingMethodName ) - 3
			);
			if ( structKeyExists( variables.collection, key ) ) {
				return variables.collection[ key ];
			}
		}

		// Return null
		return javacast( "null", "" );
	}

	private boolean function startsWith( word, substring ){
		return left( word, len( substring ) ) == substring;
	}

}
