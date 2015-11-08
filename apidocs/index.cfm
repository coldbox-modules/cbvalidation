<cfparam name="url.version" default="0">
<cfparam name="url.path" 	default="#expandPath( "./CBValidation-APIDocs" )#">
<cfscript>
	docName = "CBValidation-APIDocs";
	base 	= expandPath( "/cbvalidation" );
	docbox 	= new docbox.DocBox( properties = {
		projectTitle 	= "CBValidation v#url.version#",
		outputDir 		= url.path
	} );
	docbox.generate( source=base, mapping="cbvalidation" );
</cfscript>

<!---
<cfzip action="zip" file="#expandPath('.')#/#docname#.zip" source="#expandPath( docName )#" overwrite="true" recurse="yes">
<cffile action="move" source="#expandPath('.')#/#docname#.zip" destination="#url.path#">
--->

<cfoutput>
<h1>Done!</h1>
<a href="#docName#/index.html">Go to Docs!</a>
</cfoutput>

