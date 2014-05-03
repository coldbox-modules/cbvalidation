/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.model.validators.SameAsValidator"{

	function setup(){
		super.setup();
		model.init();
	}
	
	function testValidate(){
		result = getMockBox().createMock("cbvalidation.model.result.ValidationResult").init();
		
		
		// not empty
		r = model.validate(result,this,'test',"LUIS","luis");
		assertEquals( false, r );
		
		// not empty
		r = model.validate(result,this,'test',"luis","luis");
		assertEquals( true, r );
		
	}
	
	function getLuis(){ return 'luis'; }
}