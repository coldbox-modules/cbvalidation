component accessors="true"{

	property name="username" default="";
	property name="password" default="";

	this.constraints = {
		username = {required=true, size="2..20"},
		password = {required=true, size="2..20"}
	};

	function init(){
		return this;
	}

}