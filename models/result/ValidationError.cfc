/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * The ColdBox validation error, all inspired by awesome Hyrule Validation Framework by Dan Vega
 */
component accessors="true" {

	// constructor
	ValidationError function init(){
		variables.message        = "";
		variables.field          = "";
		variables.rejectedValue  = "";
		variables.validationType = "";
		variables.validationData = "";
		variables.errorMetadata  = {};
		return this;
	}

	/**
	 * Set error metadata that can be used in i18n message replacements or in views
	 *
	 * @data The name-value pairs of data to store in this error.
	 *
	 * @return cbvalidation.interfaces.IValidationError
	 */
	any function setErrorMetadata( required any data ){
		variables.errorMetadata = arguments.data;
		return this;
	}

	/**
	 * Get the error metadata
	 */
	struct function getErrorMetadata(){
		return variables.errorMetadata ?: {};
	}

	/**
	 * Set the validator data
	 *
	 * @data The data of the validator
	 *
	 * @return cbvalidation.interfaces.IValidationError
	 */
	any function setValidationData( required any data ){
		variables.validationData = arguments.data;
		return this;
	}

	/**
	 * Get the error validation data
	 *
	 * @return any (string or sometimes struct for newer validators)
	 */
	any function getValidationData(){
		return variables.validationData;
	}


	/**
	 * Set the error message
	 *
	 * @message The error message
	 *
	 * @return cbvalidation.interfaces.IValidationError
	 */
	any function setMessage( required string message ){
		variables.message = arguments.message;
		return this;
	}

	/**
	 * Set the field
	 *
	 * @message The error message
	 *
	 * @return cbvalidation.interfaces.IValidationError
	 */
	any function setField( required string field ){
		variables.field = arguments.field;
		return this;
	}

	/**
	 * Set the rejected value
	 *
	 * @value The rejected value
	 *
	 * @return cbvalidation.interfaces.IValidationError
	 */
	any function setRejectedValue( required any value ){
		variables.rejectedValue = arguments.value;
		return this;
	}

	/**
	 * Set the validator type name that rejected
	 *
	 * @validationType The name of the rejected validator
	 *
	 * @return cbvalidation.interfaces.IValidationError
	 */
	any function setValidationType( required any validationType ){
		variables.validationType = arguments.validationType;
		return this;
	}

	/**
	 * Get the error validation type
	 */
	string function getValidationType(){
		return variables.validationType;
	}

	/**
	 * Get the error message
	 */
	string function getMessage(){
		return variables.message;
	}

	/**
	 * Get the error field
	 */
	string function getField(){
		return variables.field;
	}

	/**
	 * Get the rejected value
	 */
	any function getRejectedValue(){
		return variables.rejectedValue;
	}

	/**
	 * Get the error representation
	 */
	struct function getMemento(){
		return {
			"message"        : variables.message,
			"field"          : variables.field,
			"rejectedValue"  : variables.rejectedValue,
			"validationType" : variables.validationType,
			"validationData" : variables.validationData,
			"errorMetadata"  : variables.errorMetadata
		};
	}


	/**
	 * Configure method, which can do setters for all required error params
	 *
	 * @message        The required error message
	 * @field          The required field that case the exception
	 * @rejectedValue  The optional rejected value
	 * @validationType The name of the rejected validator
	 * @errorMetadata  The error metadata if any
	 *
	 * @return cbvalidation.interfaces.IValidationError
	 */
	any function configure(
		required string message,
		required string field,
		string rejectedValue,
		string validationType,
		any validationData,
		struct errorMetadata
	){
		for ( var key in arguments ) {
			if ( structKeyExists( arguments, key ) ) {
				variables[ key ] = arguments[ key ];
			}
		}
		return this;
	}

}
