/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * The ColdBox validation results interface, all inspired by awesome Hyrule Validation Framework by Dan Vega
 */
import cbvalidation.models.result.*;
interface {

	/**
	 * Add errors into the result object
	 *
	 * @error         The validation error to add into the results object
	 * @error_generic cbvalidation.interfaces.IValidationError
	 *
	 * @return cbvalidation.interfaces.IValidationResult
	 */
	any function addError( required error );

	/**
	 * Set the validation target object name
	 *
	 * @return cbvalidation.interfaces.IValidationResult
	 */
	any function setTargetName( required string name );

	/**
	 * Get the name of the target object that got validated
	 */
	string function getTargetName();

	/**
	 * Get the validation locale
	 */
	string function getValidationLocale();

	/**
	 * has locale information
	 */
	boolean function hasLocale();

	/**
	 * Set the validation locale
	 *
	 * @return cbvalidation.interfaces.IValidationResult
	 */
	any function setLocale( required string locale );


	/**
	 * Determine if the results had error or not
	 *
	 * @fieldThe field to count on (optional)
	 */
	boolean function hasErrors( string field );

	/**
	 * Clear All errors
	 *
	 * @return cbvalidation.interfaces.IValidationResult
	 */
	any function clearErrors();


	/**
	 * Get how many errors you have
	 *
	 * @fieldThe field to count on (optional)
	 */
	numeric function getErrorCount( string field );

	/**
	 * Get the Errors Array, which is an array of error messages (strings)
	 *
	 * @fieldThe field to use to filter the error messages on (optional)
	 */
	array function getAllErrors( string field );

	/**
	 * Get an error object for a specific field that failed. Throws exception if the field does not exist
	 *
	 * @fieldThe field to return error objects on
	 *
	 * @return cbvalidation.interfaces.IValidationError[]
	 */
	array function getFieldErrors( required string field );

	/**
	 * Get a collection of metadata about the validation results
	 */
	struct function getResultMetadata();

	/**
	 * Set a collection of metadata into the results object
	 *
	 * @return cbvalidation.interfaces.IValidationResult
	 */
	any function setResultMetadata( required struct data );

}
