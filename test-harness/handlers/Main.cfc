/**
 * My Event Handler Hint
 */
component {

	// Index
	any function index( event, rc, prc ){
		// Test Mixins
		log.info( "validateHasValue #validateHasValue( "true" )# has passed!" );
		log.info( "validateIsNullOrEmpty #validateIsNullOrEmpty( "true" )# has passed!" );
		assert( true );
		try {
			assert( false, "bogus line" );
		} catch ( AssertException e ) {
		} catch ( any e ) {
			rethrow;
		}

		event.setView( "main/index" );
	}

	any function save( event, rc, prc ){
		var constraints = {
			username : { required : true, size : "6..20" },
			password : { required : true, size : "6..20" }
		};
		// validation
		validate( target = rc, constraints = constraints )
			.onError( function( results ){
				flash.put( "notice", arguments.results.getAllErrors().tostring() );
				return index( event, rc, prc );
			} )
			.onSuccess( function( results ){
				flash.put( "notice", "User info validated!" );
				relocate( "main" );
			} )
		;
	}

	any function saveShared( event, rc, prc ){
		// validation
		validate( target = rc, constraints = "sharedUser" )
			.onError( function( results ){
				flash.put( "notice", results.getAllErrors().tostring() );
				return index( event, rc, prc );
			} )
			.onSuccess( function( results ){
				flash.put( "User info validated!" );
				setNextEvent( "main" );
			} );
	}

	/**
	 * validateOrFailWithKeys
	 */
	function validateOrFailWithKeys( event, rc, prc ){
		var constraints = {
			username : { required : true, size : "2..20" },
			password : { required : true, size : "2..20" }
		};

		// validate
		prc.keys = validateOrFail( target = rc, constraints = constraints );

		return prc.keys;
	}

	/**
	 * validateOrFailWithNestedKeys
	 */
	function validateOrFailWithNestedKeys( event, rc, prc ){
		var constraints = {
			"keep0"       : { "required" : true, "type" : "string" },
			"keepNested0" : {
				"required"    : true,
				"type"        : "struct",
				"constraints" : {
					"keepNested1" : {
						"required"    : true,
						"type"        : "struct",
						"constraints" : { "keep2" : { "required" : true, "type" : "string" } }
					},
					"keepArray1" : {
						"required" : true,
						"type"     : "array",
						"items"    : {
							"type"        : "struct",
							"constraints" : { "keepNested3" : { "required" : true, "type" : "string" } }
						}
					},
					"keepArray1B" : {
						"required" : true,
						"type"     : "array",
						"items"    : { "type" : "array", "arrayItem" : { "type" : "string" } }
					}
				}
			},
			"keepNested0B.keep1B" : { "required" : true, "type" : "string" }
		};

		// validate
		prc.keys = validateOrFail( target = rc, constraints = constraints );

		return prc.keys;
	}

	/**
	 * validateOrFailWithObject
	 */
	function validateOrFailWithObject( event, rc, prc ){
		var oModel = populateModel( "User" );

		// validate
		prc.object = validateOrFail( oModel );

		return "Validated";
	}

	/**
	 * validateOrFailWithObjectProfiles
	 */
	function validateOrFailWithProfiles( event, rc, prc ){
		var oModel = populateModel( "User" );

		// validate
		prc.object = validateOrFail( target = oModel, profiles = rc._profiles );

		return "Validated";
	}


	/**
	 * validateOnly
	 */
	function validateOnly( event, rc, prc ){
		var oModel = populateModel( "User" );

		// validate
		prc.result = validate( oModel );

		return "Validated";
	}


	// Run on first init
	any function onAppInit( event, rc, prc ){
	}

}
