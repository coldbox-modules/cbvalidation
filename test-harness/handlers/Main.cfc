/**
* My Event Handler Hint
*/
component{

	// Index
	any function index( event, rc, prc ){
		event.setView( "main/index" );
	}

	any function save( event, rc, prc){
		var constraints = {
			username = {required=true, size="6..20"},
			password = {required=true, size="6..20"}
		};
		// validation
		var result = validate( target=rc, constraints=constraints );

		if( !result.hasErrors() ){
			flash.put( "User info validated!" );
			setNextEvent('main');
		} else {
			flash.put( "notice", result.getAllErrors().tostring() );
			return index(event,rc,prc);
		}

	}

	any function saveShared( event, rc, prc){
		// validation
		var result = validate( target=rc, constraints="sharedUser" );

		if( !result.hasErrors() ){
			flash.put( "User info validated!" );
			setNextEvent('main');
		} else {
			flash.put( "notice", result.getAllErrors().tostring() );
			return index(event,rc,prc);
		}
	}


	/**
	* validateOrFailWithKeys
	*/
	function validateOrFailWithKeys( event, rc, prc ){

		var constraints = {
			username = {required=true, size="2..20"},
			password = {required=true, size="2..20"}
		};

		// validate
		prc.keys = validateOrFail( target=rc, constraints=constraints );

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
		prc.object = validateOrFail( target=oModel, profiles=rc._profiles );

		return "Validated";
    }
    
    
    /**
	 * validateOnly
	 */
    function validateOnly( event, rc, prc){
        
        var oModel = populateModel( "User" );

		// validate
        prc.result = validate( oModel );

		return "Validated";

	}


	// Run on first init
	any function onAppInit( event, rc, prc ){

    }
    

}