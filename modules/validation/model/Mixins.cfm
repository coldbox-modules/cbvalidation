<!--- validateModel --->
<cffunction name="validateModel" output="false" access="public" returntype="any" hint="Validate a target object">
	<cfargument name="target" 		type="any" 		required="true" hint="The target object to validate or a structure of name-value paris to validate."/>
	<cfargument name="fields" 		type="string" 	required="false" default="*" hint="Validate on all or one or a list of fields (properties) on the target, by default we validate all fields declared in its constraints"/>
	<cfargument name="constraints" 	type="any" 		required="false" hint="The shared constraint name to use, or an actual constraints structure"/>
	<cfargument name="locale"		type="string" 	required="false" default="" hint="The locale to validate in"/>
	<cfargument name="excludeFields" type="string" 	required="false" default="" hint="The fields to exclude in the validation"/>
	<cfreturn getValidationManager().validate( argumentCollection=arguments )>
</cffunction>

<!--- Retrieve the applications Validation Manager --->
<cffunction name="getValidationManager" access="public" returntype="any" output="false" hint="Retrieve the application's configured Validation Manager">
	<cfreturn wirebox.getInstance( "ValidationManager@validation" )>
</cffunction>