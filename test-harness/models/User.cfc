component accessors="true" {

	property name="username" default="";
	property name="password" default="";
    property name="email"    default="";
    property name="status"   default="";
    property name="type"     default="1";

	this.constraintProfiles = {
		new : "username,password,email",
		update :  "username,email"
	};
	this.constraints = {
		username : { required : true, size : "2..20" },
		password : { required : true, size : "2..20" },
        email    : { required : true, type : "email" },
        status   : { 
            required : false, 
            udf : function( value, target, metadata ) {
                metadata[ "custom" ] = "this is some custom udf metadata";
                metadata[ "customMessage" ] = "This is a custom error message from within the udf";
                return listFind( "1,2,3", value );
            }, 
            udfMessage : "{customMessage}"
        },
        type    : { 
            required : false, 
            method : "isUserValid",
            methodMessage : "{customMessage}" 
        }
	};

	function init(){
		return this;
    }
    
    function isUserValid( value, metadata ) {
        metadata[ "custom" ] = "this is some custom method metadata";
        metadata[ "customMessage" ] = "This is a custom error message from within the method";
        return listFind( "1,2,3", value );
    }

}
