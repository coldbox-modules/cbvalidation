/**
 * *******************************************************************************
 * *******************************************************************************
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.UDFValidator" {

	function setup(){
		super.setup();
		model.init();
	}

	function testValidate(){
		result = createMock( "cbvalidation.models.result.ValidationResult" ).init();

		// not empty
		r = model.validate(
			result,
			this,
			"test",
			"woot",
			variables.validate
		);
		assertEquals( false, r );

		// not empty
		r = model.validate( result, this, "test", 55, variables.validate2 );
		assertEquals( true, r );

		// null
		r = model.validate(
			result,
			this,
			"test",
			javacast( "null", "" ),
			variables.validate3
		);
		assertEquals( true, r );
	}

	private function validate( value, target ){
		return false;
	}

	private function validate2( value, target ){
		return arguments.value gt 4;
	}

	private function validate3( value, target ){
		return false;
	}

}
