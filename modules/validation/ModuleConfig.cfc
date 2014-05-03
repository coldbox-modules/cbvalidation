component {

	// Module Properties
	this.title 				= "validation";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "This module provides server-side validation to ColdBox applications";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "validation";
	// Model Namespace
	this.modelNamespace		= "validation";
	// CF Mapping
	this.cfmapping			= "cbvalidation";
	// ColdBox Static path to validation manager
	this.COLDBOX_VALIDATION_MANAGER = "cbvalidation.model.ValidationManager";

	function configure(){

		// Mixin our own methods on handlers, interceptors and views via the ColdBox UDF Library File setting
		arrayAppend( controller.getSetting( "UDFLibraryFile" ), "#moduleMapping#/model/Mixins.cfm" );

		// Validation Settings
		settings = {
			// Change if overriding
			manager = this.COLDBOX_VALIDATION_MANAGER,
			// Setup shared constraints below
			sharedConstraints = {
				name = {
					// field = { constraints here }
				}
			}
		};

		// Did you change the manager
		if( settings.manager != this.COLDBOX_VALIDATION_MANAGER ){
			map( "validationManager@validation" )
				.to( settings.manager )
				.asSingleton();
		}

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// setup shared constraints
		wirebox.getInstance( "validationManager@validation" )
			.setSharedConstraints( settings.sharedConstraints );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

}