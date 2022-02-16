/**
 * *******************************************************************************
 * *******************************************************************************
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.SameAsValidator" {

	function setup(){
		super.setup();
		model.init();
	}

	function testValidate(){
		result = createMock( "cbvalidation.models.result.ValidationResult" ).init();


		// not empty
		r = model.validate( result, this, "test", "LUIS", "luis" );
		assertEquals( false, r );

		// not empty
		r = model.validate( result, this, "test", "luis", "luis" );
		assertEquals( true, r );
	}

	function getLuis(){
		return "luis";
	}

}
