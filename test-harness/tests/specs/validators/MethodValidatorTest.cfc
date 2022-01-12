/**
* *******************************************************************************
* *******************************************************************************
*/
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.MethodValidator" {

	function setup(){
		super.setup();
		model.init();
	}

	function testValidate(){
		var result = createMock( "cbvalidation.models.result.ValidationResult" ).init();
		var mock   = createStub().$( "validate", false ).$( "coolValidate", true );


		// call coolvalidate
		var r = model.validate( result, mock, "test", 55, "coolValidate" );
		assertEquals( true, r );

		// call validate = false
		var r = model.validate( result, mock, "test", "woot", "validate" );
		assertEquals( false, r );
	}

}
