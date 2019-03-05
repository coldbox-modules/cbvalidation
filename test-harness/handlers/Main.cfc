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
		var result = validateModel( target=rc, constraints=constraints );

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
		var result = validateModel( target=rc, constraints="sharedUser" );

		if( !result.hasErrors() ){
			flash.put( "User info validated!" );
			setNextEvent('main');
		} else {
			flash.put( "notice", result.getAllErrors().tostring() );
			return index(event,rc,prc);
		}
	}

	// Run on first init
	any function onAppInit( event, rc, prc ){

	}

}