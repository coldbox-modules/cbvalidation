/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 *
 * The ColdBox Validation Manager, all inspired by awesome Hyrule Validation Framework by Dan Vega.
 *
 * When using constraints you can use {} values for replacements:
 * - {now} = today
 * - {property:name} = A property value
 * - {udf:name} = Call a UDF provider
 *
 * Constraint Definition Sample:
 *
 * <pre>
 * constraints = {
 * propertyName = {
 * // required or not
 * required : boolean [false]
 * // type constraint
 * type  : (ssn,email,url,alpha,boolean,date,usdate,numeric,GUID,UUID,integer,[string],telephone,zipcode,ipaddress,creditcard,binary,component,query,struct,json,xml),
 * // size or length of the value (struct,string,array,query)
 * size  : numeric or range, eg: 10 or 6..8
 * // range is a range of values the property value should exist in
 * range : eg: 1..10 or 5..-5
 * // regex validation
 * regex : valid no case regex
 * // same as another property
 * sameAs : propertyName
 * // same as but with no case
 * sameAsNoCase : propertyName
 * // value in list
 * inList : list
 * // discrete math modifiers
 * discrete : (gt,gte,lt,lte,eq,neq):value
 * // UDF to use for validation, must return boolean accept the incoming value and target object, validate(value,target):boolean
 * udf : function,
 * // Validation method to use in the targt object must return boolean accept the incoming value and target object, validate(value,target):boolean
 * method : methodName
 * // Custom validator, must implement
 * validator : path or wirebox id: 'mypath.MyValidator' or 'id:MyValidator'
 * // min value
 * min : value
 * // max value
 * max : value
 * }
 * };
 *
 * vResults = validateModel(target=model);
 * </pre>
 *
 */
import cbvalidation.models.*;
import cbvalidation.models.result.*;
component accessors="true" serialize="false" singleton {

	/**
	 * WireBox Object Factory
	 */
	property name="wirebox" inject="wirebox";

	/**
	 * A resource bundle plugin for i18n capabilities
	 */
	property name="resourceService" inject="ResourceService@cbi18n";

	/**
	 * Shared constraints that can be loaded into the validation manager
	 */
	property name="sharedConstraints" type="struct";

	/**
	 * The collection of registered validators on disk
	 */
	property name="registeredValidators" type="Struct";

	// Unique manager id
	this.id = createUUID();

	/**
	 * Constructor
	 *
	 * @sharedConstraints A structure of shared constraints
	 */
	ValidationManager function init( struct sharedConstraints = {} ){
		// valid validator registrations
		variables.validValidators      = "required,type,size,range,regex,sameAs,sameAsNoCase,inList,discrete,udf,method,validator,min,max";
		// store shared constraints if passed
		variables.sharedConstraints    = arguments.sharedConstraints;
		// Validators Path
		variables.validatorsPath       = getDirectoryFromPath( getMetadata( this ).path ) & "validators";
		// Register validators
		variables.registeredValidators = directoryList(
			variables.validatorsPath,
			false,
			"name",
			"*.cfc"
		)
			// don't do the interfaces
			.filter( function( item ){
				return ( item != "BaseValidator.cfc" );
			} )
			// Purge extension
			.map( function( item ){
				return listFirst( item, "." );
			} )
			// Build out wirebox map
			.reduce( function( result, item ){
				result[ item.replaceNoCase( "Validator", "" ) ] = "cbvalidation.models.validators.#item#";
				return result;
			}, {} );

		return this;
	}

	/**
	 * Validate an object using constraints
	 *
	 * @target        The target object to validate or a structure like a form or collection. If it is a collection, we will build a generic object for you so we can validate the structure of name-value pairs.
	 * @fields        One or more fields to validate on, by default it validates all fields in the constraints. This can be a simple list or an array.
	 * @constraints   An optional shared constraints name or an actual structure of constraints to validate on.
	 * @locale        An optional locale to use for i18n messages
	 * @excludeFields An optional list of fields to exclude from the validation.
	 * @IncludeFields An optional list of fields to include in the validation.
	 * @profiles      If passed, a list of profile names to use for validation constraints
	 *
	 * @return cbvalidation.interfaces.component extends="Basevalidator" a
	 */
	any function validate(
		required any target,
		string fields        = "*",
		any constraints      = "",
		string locale        = "",
		string excludeFields = "",
		string includeFields = "",
		string profiles      = ""
	){
		var targetName = "";

		// Do we have a real object or a structure?
		if ( !isObject( arguments.target ) ) {
			arguments.target = new GenericObject( arguments.target );
			if ( isSimpleValue( arguments.constraints ) and len( arguments.constraints ) ) {
				targetName = arguments.constraints;
			} else {
				targetName = "GenericForm";
			}
		} else {
			targetName = listLast( getMetadata( arguments.target ).name, "." );
		}

		// discover and determine constraints definition for an incoming target.
		var allConstraints = determineConstraintsDefinition( arguments.target, arguments.constraints );

		// create new result object
		var results = wirebox.getInstance(
			name          = "cbvalidation.models.result.ValidationResult",
			initArguments = {
				locale          : arguments.locale,
				targetName      : targetName,
				resourceService : variables.resourceService,
				constraints     : allConstraints,
				profiles        : arguments.profiles
			}
		);

		// Discover profiles, and update the includeFields list from it
		if ( len( arguments.profiles ) ) {
			arguments.includeFields = arguments.profiles
				.listToArray()
				// Check if profiles defined in target and iterated one exists
				.filter( function( profileKey ){
					return structKeyExists( target, "constraintProfiles" ) && structKeyExists(
						target.constraintProfiles,
						profileKey
					);
				} )
				// Incorporate fields from each profile
				.map( function( profileKey ){
					// iterate all declared profile fields and incorporate into the includeFields
					return target.constraintProfiles.find( arguments.profileKey ).listToArray();
				} )
				// Reduce all fields into a single hashset to do a distinct collection
				.reduce( function( result, item ){
					item.each( function( thisField ){
						result.add( thisField );
					} );
					return result;
				}, createObject( "java", "java.util.HashSet" ) )
				.toArray();
			arguments.includeFields = arrayToList( arguments.includeFields );
		}

		// iterate over constraints defined
		for ( var thisField in allConstraints ) {
			var validateField = true;
			if ( len( arguments.includeFields ) AND NOT listFindNoCase( arguments.includeFields, thisField ) ) {
				validateField = false;
			}
			// exclusions passed and field is in the excluded list just continue
			if ( len( arguments.excludeFields ) and listFindNoCase( arguments.excludeFields, thisField ) ) {
				validateField = false;
			}
			if ( validateField ) {
				// verify we can validate the field described in the constraint
				if ( arguments.fields == "*" || listFindNoCase( arguments.fields, thisField ) ) {
					// process the validation rules on the target field using the constraint validation data
					processRules(
						results = results,
						rules   = allConstraints[ thisField ],
						target  = arguments.target,
						field   = thisField,
						locale  = arguments.locale
					);
				}
			}
		}

		return results;
	}

	/**
	 * Validate an object using constraints and throw a `ValidationException` if the validation fails
	 *
	 * @target        The target object to validate or a structure like a form or collection. If it is a collection, we will build a generic object for you so we can validate the structure of name-value pairs.
	 * @fields        One or more fields to validate on, by default it validates all fields in the constraints. This can be a simple list or an array.
	 * @constraints   An optional shared constraints name or an actual structure of constraints to validate on.
	 * @locale        An optional locale to use for i18n messages
	 * @excludeFields An optional list of fields to exclude from the validation.
	 * @IncludeFields An optional list of fields to include in the validation.
	 * @profiles      If passed, a list of profile names to use for validation constraints
	 *
	 * @return {Object,struct}: The target object that was validated, or the structure fields that where validated ONLY
	 *
	 * @throws ValidationException
	 */
	function validateOrFail(
		required any target,
		string fields        = "*",
		any constraints      = "",
		string locale        = "",
		string excludeFields = "",
		string includeFields = "",
		string profiles      = ""
	){
		var vResults = this.validate( argumentCollection = arguments );

		// Verify errors
		if ( vResults.hasErrors() ) {
			throw(
				type         = "ValidationException",
				message      = "The target failed to pass validation",
				extendedInfo = vResults.getAllErrorsAsJson()
			);
		}

		// If object, return it
		if ( isObject( arguments.target ) ) {
			return arguments.target;
		}

		// Return validated keys
		return arguments.target.filter( ( key ) => vResults.getConstraints().keyExists( arguments.key ) );
	}

	/**
	 * Process validation rules on a target object and field
	 *
	 * @results         The validation result object
	 * @results_generic cbvalidation.interfaces.component extends="Basevalidator" a
	 * @rules           The structure containing validation rules
	 * @target          The target object to do validation on
	 * @field           The field to validate
	 */
	ValidationManager function processRules(
		required any results,
		required struct rules,
		required any target,
		required any field
	){
		// process the incoming rules
		for ( var key in arguments.rules ) {
			// if message validators, just ignore
			if ( reFindNoCase( "Message$", key ) ) {
				continue;
			}

			// had to use nasty evaluate until adobe cf get's their act together on invoke.
			getValidator( validatorType = key, validationData = arguments.rules[ key ] ).validate(
				validationResult = results,
				target           = arguments.target,
				field            = arguments.field,
				targetValue      = invoke( arguments.target, "get" & arguments.field ),
				validationData   = arguments.rules[ key ],
				rules            = arguments.rules
			);
		}
		return this;
	}

	/**
	 * Create validators according to types and validation data
	 *
	 * @validatorType  The type of validator to retrieve, either internal or class path or wirebox ID
	 * @validationData The validation data that is used for custom validators
	 *
	 * @return cbvalidation.interfaces.IValidator
	 *
	 * @throws ValidationManager.InvalidValidatorType
	 */
	any function getValidator( required string validatorType, required any validationData ){
		// Are we a core validator?
		if ( structKeyExists( variables.registeredValidators, arguments.validatorType ) ) {
			return wirebox.getInstance( variables.registeredValidators[ arguments.validatorType ] );
		}

		// Else switch checks
		switch ( arguments.validatorType ) {
			// Custom Validator
			case "validator": {
				if ( find( ":", arguments.validationData ) ) {
					return wirebox.getInstance( getToken( arguments.validationData, 2, ":" ) );
				}
				return wirebox.getInstance( arguments.validationData );
			}
			// See if it's a WireBox Mapping
			default: {
				if ( wirebox.getBinder().mappingExists( validatorType ) ) {
					return wirebox.getInstance( validatorType );
				}
				throw(
					message = "The validator you requested #arguments.validatorType# is not a valid validator",
					type    = "ValidationManager.InvalidValidatorType"
				);
			}
		}
	}

	/**
	 * Retrieve the shared constraints, all of them or by name
	 *
	 * @name Filter by name or not
	 */
	struct function getSharedConstraints( string name ){
		return (
			structKeyExists( arguments, "name" ) ? variables.sharedConstraints[ arguments.name ] : variables.sharedConstraints
		);
	}

	/**
	 * Check if a shared constraint exists by name
	 *
	 * @name The shared constraint to check
	 */
	boolean function sharedConstraintsExists( required string name ){
		return structKeyExists( variables.sharedConstraints, arguments.name );
	}


	/**
	 * Set the entire shared constraints structure
	 *
	 * @constraints Filter by name or not
	 *
	 * @return cbvalidation.interfaces.IValidationManager
	 */
	any function setSharedConstraints( struct constraints ){
		variables.sharedConstraints = arguments.constraints;
		return this;
	}

	/**
	 * Store a shared constraint
	 *
	 * @name       The name to store the constraint as
	 * @constraint The constraint structures to store.
	 *
	 * @return cbvalidation.interfaces.IValidationManager
	 */
	any function addSharedConstraint( required string name, required struct constraint ){
		variables.sharedConstraints[ arguments.name ] = arguments.constraints;
		return this;
	}

	/************************************** PRIVATE *********************************************/

	/**
	 * Determine from where to take the constraints from
	 *
	 * @target      The target object
	 * @constraints The constraints rules
	 *
	 * @throws ValidationManager.InvalidSharedConstraint
	 */
	private struct function determineConstraintsDefinition( required any target, any constraints = "" ){
		var thisConstraints = {};

		// if structure, just return it back
		if ( isStruct( arguments.constraints ) ) {
			return arguments.constraints;
		}

		// simple value means shared lookup
		if ( isSimpleValue( arguments.constraints ) AND len( arguments.constraints ) ) {
			if ( !sharedConstraintsExists( arguments.constraints ) ) {
				throw(
					message = "The shared constraint you requested (#arguments.constraints#) does not exist",
					detail  = "Valid constraints are: #structKeyList( sharedConstraints )#",
					type    = "ValidationManager.InvalidSharedConstraint"
				);
			}
			// retrieve the shared constraint and return, they are already processed.
			return getSharedConstraints( arguments.constraints );
		}

		// discover constraints from target object
		return discoverConstraints( arguments.target );
	}

	/**
	 * Get the constraints structure from target objects, if none, it returns an empty structure
	 *
	 * @target The target object
	 */
	private struct function discoverConstraints( required any target ){
		return ( structKeyExists( arguments.target, "constraints" ) ? arguments.target.constraints : {} );
	}

}
