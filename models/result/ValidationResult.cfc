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
	 * Constructor
	 */
	ValidationResult function init(
		string locale       = "",
		string targetName   = "",
		any resourceService = "",
		struct constraints  = {},
		string profiles     = ""
	){
		variables.errors          = [];
		variables.resultMetadata  = {};
		variables.errorTemplate   = new ValidationError();
		variables.locale          = arguments.locale;
		variables.targetName      = arguments.targetName;
		variables.resourceService = arguments.resourceService;
		variables.constraints     = arguments.constraints;
		variables.profiles        = arguments.profiles;
		return this;
	}

	/**
	 * Set the validation target object name
	 *
	 * @return cbvalidation.interfaces.IValidationResult
	 */
	any function setTargetName( required string name ){
		variables.targetName = arguments.name;
		return this;
	}

	/**
	 * Get the name of the target object that got validated
	 */
	string function getTargetName(){
		return variables.targetName;
	}

	/**
	 * Get the validation locale
	 */
	string function getValidationLocale(){
		return variables.locale;
	}

	/**
	 * has locale information
	 */
	boolean function hasLocale(){
		return ( len( variables.locale ) GT 0 );
	}

	/**
	 * Set the validation locale
	 *
	 * @return cbvalidation.interfaces.IValidationResult
	 */
	any function setLocale( required string locale ){
		variables.locale = arguments.locale;
		return this;
	}

	/**
	 * Get a new error object pre poulated with the arguments it has been passed
	 *
	 * @return cbvalidation.interfaces.IValidationError
	 */
	any function newError(){
		return duplicate( errorTemplate ).configure( argumentCollection = arguments );
	}

	/**
	 * Add errors into the result object
	 *
	 * @error         The validation error to add into the results object
	 * @error_generic cbvalidation.interfaces.IValidationError
	 *
	 * @return cbvalidation.interfaces.IValidationResult
	 */
	any function addError( required error ){
		// Verify Custom Messages via constraints, these take precedence
		if (
			structKeyExists( variables.constraints, arguments.error.getField() ) AND structKeyExists(
				variables.constraints[ arguments.error.getField() ],
				"#arguments.error.getValidationType()#Message"
			)
		) {
			// override message with custom constraint
			// process global replacements
			globalReplacements(
				variables.constraints[ arguments.error.getField() ][ "#arguments.error.getValidationType()#Message" ],
				error
			);
		}
		// Validate localization?
		else if ( hasLocale() ) {
			// get i18n message, if it exists
			var message = variables.resourceService.getResource(
				resource = "#variables.targetName#.#arguments.error.getField()#.#arguments.error.getValidationType()#",
				default  = "",
				locale   = getValidationLocale()
			);
			// Override with localized message
			if ( len( message ) ) {
				// process global replacements
				globalReplacements( message, error );
			}
		}
		// append error
		arrayAppend( variables.errors, arguments.error );
		return this;
	}

	/**
	 * Replace global messages
	 *
	 * @message The message
	 * @error   cbvalidation.interfaces.IvalidationError
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
		arguments.message = replaceNoCase(
			arguments.message,
			"{field}",
			arguments.error.getField(),
			"all"
		);
		// Hyrule Compatibility for property
		arguments.message = replaceNoCase(
			arguments.message,
			"{property}",
			arguments.error.getField(),
			"all"
		);
		// The validation type
		arguments.message = replaceNoCase(
			arguments.message,
			"{validationType}",
			arguments.error.getValidationType(),
			"all"
		);
		// Validation data that is SIMPLE ONLY!
		if ( isSimpleValue( arguments.error.getValidationData() ) ) {
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
		var errorTarget = variables.errors;

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
		var errorTarget = variables.errors;

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
			arrayAppend( results[ thisError.getField() ], thisError.getMemento() );
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
	 * @return cbvalidation.interfaces.IValidationError[]
	 */
	array function getFieldErrors( required string field ){
		var r = [];
		for ( var thisError in variables.errors ) {
			if ( thisError.getField() eq arguments.field ) {
				arrayAppend( r, thisError );
			}
		}
		return r;
	}

	/**
	 * Call back that will be executed if the validation results had errors in them.
	 * The consumer receives the results instance: `(results) => {}, function( results ){}`
	 *
	 * @consumer Block to be executed if the result of the validation had errors.
	 *
	 * @return Same instance
	 */
	function onError( required consumer ){
		if ( this.hasErrors() ) {
			arguments.consumer( this );
		}
		return this;
	}

	/**
	 * Call back that will be executed if the validation results had NO errors in them.
	 * The consumer receives the results instance: `(results) => {}, function( results ){}`
	 *
	 * @consumer Block to be executed if the result of the validation had NO errors.
	 *
	 * @return Same instance
	 */
	function onSuccess( required consumer ){
		if ( !this.hasErrors() ) {
			arguments.consumer( this );
		}
		return this;
	}

	/**
	 * Clear All errors
	 *
	 * @return cbvalidation.interfaces.IValidationResult
	 */
	any function clearErrors(){
		arrayClear( variables.errors );
		return this;
	}

	/**
	 * Get a collection of metadata about the validation results
	 */
	struct function getResultMetadata(){
		return variables.resultMetadata;
	}

	/**
	 * Set a collection of metadata into the results object
	 *
	 * @return cbvalidation.interfaces.IValidationResult
	 */
	any function setResultMetadata( required struct data ){
		variables.resultMetadata = arguments.data;
		return this;
	}

}
