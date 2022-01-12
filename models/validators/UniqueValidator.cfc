/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This validator validates if a value is unique in a database
 */
component extends="BaseValidator" accessors="true" singleton {

	property name="name";
	property name="res"           inject="model:resourceService@cbi18n";
	property name="moduleService" inject="coldbox:moduleService";
	property name="wirebox"       inject="wirebox";

	/**
	 * Constructor
	 */
	UniqueValidator function init(){
		variables.name = "UniqueValidator";
		return this;
	}

	/**
	 * Will check if an incoming value validates
	 *
	 * @validationResult The result object of the validation
	 * @target           The target object to validate on
	 * @field            The field on the target object to validate on
	 * @targetValue      The target value to validate
	 * @validationData   The validation data the validator was created with
	 * @rules            The rules imposed on the currently validating field
	 */
	boolean function validate(
		required any validationResult,
		required any target,
		required string field,
		any targetValue,
		any validationData,
		struct rules
	){
		// uniqueness detection for non orm (orm has its own validator)
		// validationData.table (required)
		param validationData.column      = arguments.field;
		param validationData.keyProperty = "id";
		param validationData.keyColumn   = validationData.keyProperty;
		// validationData.dataSource optional
		// validationData.isLoaded to override isLoaded detection

		// return true if no data to check, type needs a data element to be checked.
		if ( isNull( arguments.targetValue ) || isNullOrEmpty( arguments.targetValue ) ) {
			return true;
		}

		var sql     = "Select 1 from #validationData.table# where #validationData.column# = :name";
		// prepare query params
		var params  = { name : arguments.targetValue };
		// add datasource property, or use default
		var options = arguments.validationdata.keyExists( "datasource" ) ? {
			datasource : arguments.validationdata.datasource
		} : {};
		// now get IDvalue or null if there's no ID value yet
		var IdValue  = invoke( target, "get#validationData.keyProperty#" );
		// isLoaded: if not present detect isLoaded by valid ID which has some length
		var isLoaded = !arguments.validationData.KeyExists( "isLoaded" ) ? !isNull( idValue ) && len( IdValue ) : arguments.validationData.isLoaded;
		// add datasource property, or use default
		if ( isLoaded ) {
			// add extra param and sql to exclude current record
			params.id = IdValue;
			sql &= " and #validationData.keyColumn# <> :id"
		}
		var result = queryExecute( sql, params, options )
		if ( !result.recordCount ) return true;

		// construction of your validation error messages
		var args = {
			message        : "The '#arguments.field#' value '#arguments.targetValue#' is not unique",
			field          : arguments.field,
			validationType : getName(),
			rejectedValue  : ( isSimpleValue( arguments.targetValue ) ? arguments.targetValue : "" ),
			validationData : arguments.validationData
		};
		validationResult.addError(
			validationResult
				.newError( argumentCollection = args )
				.setErrorMetadata( { UniqueValidator : arguments.validationData } )
		);
		return false;
	}

}
