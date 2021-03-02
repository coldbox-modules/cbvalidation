/**
 *********************************************************************************
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.coldbox.org | www.luismajano.com | www.ortussolutions.com
 ********************************************************************************
 */
component {

	// Module Properties
	this.title                      = "validation";
	this.author                     = "Luis Majano";
	this.webURL                     = "http://www.ortussolutions.com";
	this.description                = "This module provides server-side validation to ColdBox applications";
	this.version                    = "@build.version@+@build.number@";

	// Model Namespace
	this.modelNamespace             = "cbvalidation";
	// CF Mapping
	this.cfmapping                  = "cbvalidation";
	// Helpers
	this.applicationHelper          = [ "helpers/Mixins.cfm" ];
    // Module Dependencies That Must Be Loaded First, use internal names or aliases
	this.dependencies               = [ "cbi18n" ];
	// ColdBox Static path to validation manager
	this.COLDBOX_VALIDATION_MANAGER = "cbvalidation.models.ValidationManager";
	this.CBVALIDATION_DEFAULT_RESOURCE = "cbvalidation";
	this.CBVALIDATION_CUSTOM_RESOURCE = "cbvalidationCustom";

	/**
	 * Configure module
	 */
	function configure(){

        settings = {
            manager = this.COLDBOX_VALIDATION_MANAGER,
            i18nResource = "",
            sharedConstraints = {
            }
        };
        cbi18n = {
            resourceBundles = {
                "#this.CBVALIDATION_DEFAULT_RESOURCE#" = "#moduleMapping#/includes/cbi18n/cbvalidation"
            }
        };
    }

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
        if (len( variables.settings.i18nResource )) {
            cbi18n.resourceBundles[this.CBVALIDATION_CUSTOM_RESOURCE] = variables.settings.i18nResource;
        }
        variables.settings["CBVALIDATION_DEFAULT_RESOURCE"] = this.CBVALIDATION_DEFAULT_RESOURCE;
        variables.settings["CBVALIDATION_CUSTOM_RESOURCE"] = this.CBVALIDATION_CUSTOM_RESOURCE;

        // Did you change the validation manager?
		if ( variables.settings.manager != this.COLDBOX_VALIDATION_MANAGER ) {
			binder
				.map(
					alias = "validationManager@cbvalidation",
					force = true
				)
				.to( variables.settings.manager )
				.asSingleton();
		}
		// setup shared constraints
		wirebox
			.getInstance( "validationManager@cbvalidation" )
			.setSharedConstraints( variables.settings.sharedConstraints );
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
    }
}
