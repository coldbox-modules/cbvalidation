component accessors="true" {

	property name="username" default="";
	property name="password" default="";
	property name="email"    default="";

	this.constraintProfiles = {
		new : "username,password,email",
		update :  "username,email"
	};
	this.constraints = {
		username : { required : true, size : "2..20" },
		password : { required : true, size : "2..20" },
		email    : { required : true, type : "email" }
	};

	function init(){
		return this;
	}

}
