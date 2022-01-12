/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * The ColdBox validation manager interface, all inspired by awesome Hyrule Validation Framework by Dan Vega
 */
import cbvalidation.models.*;
import cbvalidation.models.result.*;
interface {

	/**
	 * Validate an object
	 *
	 * @targetThe       target object to validate
	 * @fieldsOne       or more fields to validate on, by default it validates all fields in the constraints. This can be a simple list or an array.
	 * @constraintsAn   optional shared constraints name or an actual structure of constraints to validate on.
	 * @localeAn        optional locale to use for i18n messages
	 * @excludeFieldsAn optional list of fields to exclude from the validation.
	 * @includeFieldsAn optional list of fields to include in the validation.
	 *
	 * @return cbvalidation.interfaces.IValidationResult
	 */
	any function validate(
		required any target,
		string fields,
		any constraints,
		string locale        = "",
		string excludeFields = "",
		string includeFields = ""
	);

	/**
	 * Retrieve the shared constraints
	 *
	 * @nameFilter by name or not
	 */
	struct function getSharedConstraints( string name );

	/**
	 * Check if a shared constraint exists by name
	 *
	 * @nameThe shared constraint to check
	 */
	boolean function sharedConstraintsExists( required string name );

	/**
	 * Set the shared constraints into the validation manager, usually these are described in the ColdBox configuraiton file
	 *
	 * @constraintsFilter by name or not
	 *
	 * @return cbvalidation.interfaces.IValidationManager
	 */
	any function setSharedConstraints( struct constraints );

	/**
	 * Store a shared constraint
	 *
	 * @nameFilter    by name or not
	 * @constraintThe constraint to store.
	 *
	 * @return cbvalidation.interfaces.IValidationManager
	 */
	any function addSharedConstraint( required string name, required struct constraint );

}
