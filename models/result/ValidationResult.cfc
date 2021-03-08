/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * The ColdBox validation results
 */
component accessors="true" {

	/**
	 * A collection of error objects represented in this result object
	 */
	property name="errors" type="array";

	/**
	 * Extra metadata you can store in the results object
	 */
	property name="resultMetadata" type="struct";

	/**
	 * The locale this result validation is using
	 */
	property name="locale" type="string";

	/**
	 * The name of the target object
	 */
	property name="targetName" type="string";

	/**
	 * The constraints evaluated in the validation process
	 */
	property name="constraints" type="struct";

	/**
	 * The resource bundle object
	 */
	property name="resourceService";

	/**
	 * The profiles used in the validation
	 */
	property name="profiles" type="string";

    /**
     * The cbvalidation settings
     */
    property name="settings" type="struct"; 

	/**
	 * Constructor
	 */
	ValidationResult function init(
		string locale       = "",
		string targetName   = "",
		any resourceService = "",
		struct constraints  = structNew(),
		string profiles     = "",
        struct settings     = structNew()
	){
		variables.errors         = [];
		variables.resultMetadata = {};
		variables.errorTemplate  = new ValidationError();

		variables.locale          = arguments.locale;
		variables.targetName      = arguments.targetName;
		variables.resourceService = arguments.resourceService;
		variables.constraints     = arguments.constraints;
		variables.profiles        = arguments.profiles;
        variables.settings        = arguments.settings;
		return this;
	}

	/**
	 * Set the validation target object name
	 *
	 * @return IValidationResult
	 */
	any function setTargetName( required string name ){
		targetName = arguments.name;
		return this;
	}

	/**
	 * Get the name of the target object that got validated
	 */
	string function getTargetName(){
		return targetName;
	}

	/**
	 * Get the validation locale
	 */
	string function getValidationLocale(){
		return locale;
	}

	/**
	 * has locale information
	 */
    // TODO: not sure if we need this function, probably not
	boolean function hasLocale(){
		return ( len( locale ) GT 0 );
	}

	/**
	 * Set the validation locale
	 *
	 * @return IValidationResult
	 */
	any function setLocale( required string locale ){
		variables.locale = arguments.locale;
		return this;
	}

	/**
	 * Get a new error object pre poulated with the arguments it has been passed
	 *
	 * @return IValidationError
	 */
	any function newError(){
		return duplicate( errorTemplate ).configure( argumentCollection = arguments );
	}

	/**
	 * Add errors into the result object
	 *
	 * @error The validation error to add into the results object
	 * @error_generic IValidationError
	 *
	 * @return IValidationResult
	 */
	any function addError( required error ){
        var message = arguments.error.getMessage();
        // Verify Custom Messages via constraints, these take precedence
		if ( len( getCustomMessageFromConstraint( error ) ) ) {
            message = getCustomMessageFromConstraint( error );
        }
		// verify custom message from i18nResource 
		else if ( len( getCustomMessageFromI18nResource( error ) ) ) {
            // get i18n message from CUSTOM resource, if it exists
			message = getCustomMessageFromI18nResource( error );
        }
        // if message has no length yet we need a default message
        if ( !message.len() ) {
            message = getDefaultMessage( error );
        }
        globalReplacements( message, error	);
        // append error
		arrayAppend( errors, arguments.error );
		return this;
	}

	/**
	 * Replace global messages
	 *
	 * @message The message
	 * @error The validation error to add into the results object
	 * @error_generic IValidationError
	 */
	private void function globalReplacements( required message, required error ){
		// The rejected value
		arguments.message = replaceNoCase(
			arguments.message,
			"{rejectedValue}",
			arguments.error.getRejectedValue(),
			"all"
		);
		// The property or field value
        // find out if there is a {field} translation
        // check in constraints first
        var fieldLabel = getConstraintFieldLabel( arguments.error );
 
        // check in cbi18n customization next
        if ( !fieldLabel.len() ) {
            fieldLabel = getFieldLabelFromI18nResource( arguments.error );
        };
        if ( !fieldLabel.len() ) {
            fieldLabel = arguments.error.getField();
        };
        
		arguments.message = replaceNoCase(
			arguments.message,
			"{field}",
			fieldLabel,
			"all"
		);
        // Hyrule Compatibility for property
		arguments.message = replaceNoCase(
			arguments.message,
			"{property}",
			fieldLabel,
			"all"
		);
		// The validation type
		arguments.message = replaceNoCase(
			arguments.message,
			"{validationType}",
			arguments.error.getValidationType(),
			"all"
		);
		// The validation data, should be skipped if validationData is a struct
		if ( isSimpleValue( arguments.error.getValidationData()) ) {
			arguments.message = replaceNoCase(
				arguments.message,
				"{validationData}",
				arguments.error.getValidationData(),
				"all"
			);
		}
		// The target name of the object
		arguments.message = replaceNoCase(
			arguments.message,
			"{targetName}",
			getTargetName(),
			"all"
		);

		// process result metadata replacements
		var errorData = arguments.error.getErrorMetadata();
		for ( var key in errorData ) {
			arguments.message = replaceNoCase(
				arguments.message,
				"{#key#}",
				errorData[ key ],
				"all"
			);
		}
		// override message
		arguments.error.setMessage( arguments.message );
	}

	/**
	 * Determine if the results had error or not
	 *
	 * @field The field to count on (optional)
	 */
	boolean function hasErrors( string field ){
		return ( arrayLen( getAllErrors( argumentCollection = arguments ) ) gt 0 );
	}

	/**
	 * Get how many errors you have
	 *
	 * @field The field to count on (optional)
	 */
	numeric function getErrorCount( string field ){
		return arrayLen( getAllErrors( argumentCollection = arguments ) );
	}

	/**
	 * Get the Errors Array, which is an array of error messages (strings)
	 *
	 * @field The field to use to filter the error messages on (optional)
	 */
	array function getAllErrors( string field ){
		var errorTarget = errors;

		if ( structKeyExists( arguments, "field" ) ) {
			errorTarget = getFieldErrors( arguments.field );
		}

		var e = [];
		for ( var thisKey in errorTarget ) {
			arrayAppend( e, thisKey.getMessage() );
		}

		return e;
	}

	/**
	 * Get all errors as flat structure that can easily be used for UI display
	 */
	struct function getAllErrorsAsStruct( string field ){
		var errorTarget = errors;

		// filter by field?
		if ( structKeyExists( arguments, "field" ) ) {
			errorTarget = getFieldErrors( arguments.field );
		}

		var results = {};
		for ( var thisError in errorTarget ) {
			// check if field struct exists, else create it
			if ( !structKeyExists( results, thisError.getField() ) ) {
				results[ thisError.getField() ] = [];
			}
			// Add error Message
			arrayAppend(
				results[ thisError.getField() ],
				thisError.getMemento()
			);
		}

		return results;
	}

	/**
	 * Get all errors or by field as a JSON structure
	 */
	string function getAllErrorsAsJSON( string field ){
		var results = getAllErrorsAsStruct( argumentcollection = arguments );
		return serializeJSON( results );
	}

	/**
	 * Get an error object for a specific field that failed. Throws exception if the field does not exist
	 *
	 * @field The field to return error objects on
	 *
	 * @return IValidationError[]
	 */
	array function getFieldErrors( required string field ){
		var r = [];
		for ( var thisError in errors ) {
			if ( thisError.getField() eq arguments.field ) {
				arrayAppend( r, thisError );
			}
		}
		return r;
	}

	/**
	 * Clear All errors
	 *
	 * @return IValidationResult
	 */
	any function clearErrors(){
		arrayClear( errors );
		return this;
	}

	/**
	 * Get a collection of metadata about the validation results
	 */
	struct function getResultMetadata(){
		return resultMetadata;
	}

	/**
	 * Set a collection of metadata into the results object
	 *
	 * @return IValidationResult
	 */
	any function setResultMetadata( required struct data ){
		variables.resultMetadata = arguments.data;
		return this;
	}

    /**
     * detects if i18n resource is present
     * 
     * @return boolean
     */
    public boolean function hasI18nResource() {
        // if settings.i18nResource has lenght, there always is a valid custom resource (if not, module configure would fail)
        return variables.settings.i18nResource.len() > 0 ;
    }

    /**
     * returns custom message from constraints
     * 
 	 * @error The validation error to add into the results object
	 * @error_generic IValidationError
    * @return string empty if not found
     */
    private string function getCustomMessageFromConstraint( required error ){
        if ( structKeyExists( variables.constraints, "_messages" ) ){
            //check exact message for field plus type first
            var FieldPlusTypeKey = "#error.getField()#.#error.getValidationType()#";
            if ( structkeyExists(variables.constraints._messages, FieldPlusTypeKey )  ) {
                return structFind(variables.constraints._messages,FieldPlusTypeKey);
            }
            // check generic custom message for field
            if ( structkeyExists( variables.constraints._messages, error.getField() ) ) {
                return structfind( variables.constraints._messages, error.getField() );
            }
        }
        return "";
    }

    /**
     * returns custom field label from constraints
     * 
 	 * @error The validation error to add into the results object
     * @return string, empty if not found
     */
    private string function getConstraintFieldLabel( required error ){
        if ( structKeyExists( variables.constraints, "_fields") ){
            if ( structKeyExists( variables.constraints._fields, error.getField()  ) ) {
                return structfind( variables.constraints._fields, error.getField() );
            }
        }
        return "";
    }

    /**
     * returns custom message from i18n resource
     * 
 	 * @error The validation error to add into the results object
	 * @error_generic IValidationError
    * @return string and empty if not found
     */
    private string function getCustomMessageFromI18nResource( required error ){
        return hasI18nResource() ? 
            variables.resourceService.getResource(
                resource = "_messages.#arguments.error.getValidationType()#",
                default  = "",
                locale   = getValidationLocale(),
                bundle = variables.settings.CBVALIDATION_CUSTOM_RESOURCE
            ) : "";
    }

    /**
     * returns custom field label from i18n resource
     * 
 	 * @error The validation error to add into the results object
    * @return string and empty if not found
     */
    private string function getFieldLabelFromI18nResource( required error ){
        return hasI18nResource() ? 
            variables.resourceService.getResource(
                resource = "_fields.#arguments.error.getField()#",
                default  = "",
                locale   = getValidationLocale(),
                bundle = variables.settings.CBVALIDATION_CUSTOM_RESOURCE
            ) : "";
    }
    
    /**
     * return (localized) default message based on validationType from default resources
     * 
	 * @error The validation error to add into the results object
	 * @error_generic IValidationError
     * @return string
     * @throws MissingValidatorTranslation (should alwasy be there for default validator types)
     */
    private string function getDefaultMessage( required error ){
        var message = resourceService.getResource(
            resource = "_messages.#arguments.error.getValidationType()#",
            default = "",
            locale = getValidationLocale(),
            bundle = variables.settings.CBVALIDATION_DEFAULT_RESOURCE
        );
        if ( message.len() ) {
            return message;
        } else {
            throw(
				type         = "MissingValidatorTranslation",
				message      = "Missing translation for validatorType #arguments.error.getValidationType()#"
			);
        }
    }
}
