/**
 * *******************************************************************************
 * *******************************************************************************
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.MinValidator" {

	function setup(){
		super.setup();
		model.init();
	}

	function testValidateSimple(){
		result = createMock( "cbvalidation.models.result.ValidationResult" ).init();

		r = model.validate( result, this, "test", "1", "5" );
		assertEquals( false, r );

		r = model.validate( result, this, "test", "123", "5" );
		assertEquals( true, r );
	}

}
