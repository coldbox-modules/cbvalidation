/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * The ColdBox validation error interface, all inspired by awesome Hyrule Validation Framework by Dan Vega
 */
import cbvalidation.models.result.*;
interface {

	/**
	 * Set the error message
	 *
	 * @messageThe error message
	 */
	cbvalidation.interfaces.IValidationError function setMessage( required string message );

	/**
	 * Set the field
	 *
	 * @messageThe error message
	 */
	cbvalidation.interfaces.IValidationError function setField( required string field );

	/**
	 * Set the rejected value
	 *
	 * @valueThe rejected value
	 */
	cbvalidation.interfaces.IValidationError function setRejectedValue( required any value );

	/**
	 * Set the validator type name that rejected
	 *
	 * @validationTypeThe name of the rejected validator
	 */
	cbvalidation.interfaces.IValidationError function setValidationType( required any validationType );

	/**
	 * Get the error validation type
	 */
	string function getValidationType();

	/**
	 * Set the validator data
	 *
	 * @dataThe data of the validator
	 */
	cbvalidation.interfaces.IValidationError function setValidationData( required any data );

	/**
	 * Get the error validation data
	 */
	string function getValidationData();

	/**
	 * Get the error message
	 */
	string function getMessage();

	/**
	 * Get the error field
	 */
	string function getField();

	/**
	 * Get the rejected value
	 */
	any function getRejectedValue();

}
