/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.model.validators.MethodValidator"{

	function setup(){
		super.setup();
		model.init();
	}
	
	function testValidate(){
		result = getMockBox().createMock("cbvalidation.model.result.ValidationResult").init();
		
		mock = getMockBox().createStub()
			.$("validate",false)
			.$("coolValidate",true);
		
		// call coolvalidate
		r = model.validate(result,mock,'test', 55, "coolValidate");
		assertEquals( true, r );
		
		// call validate = false
		r = model.validate(result,mock,'test',"woot","validate");
		assertEquals( false, r );
		
		// call with null value
		r = model.validate(result,mock,'test', javaCast("null","") ,"validate");
		assertEquals( false, r );
		
	}
	
}