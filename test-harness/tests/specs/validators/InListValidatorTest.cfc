/**
 * *******************************************************************************
 * *******************************************************************************
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.InListValidator" {

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
			"nancy",
			"luis,joe,alexia,vero"
		);
		assertEquals( false, r );

		// not empty
		r = model.validate(
			result,
			this,
			"test",
			"alexia",
			"luis,joe,alexia,vero"
		);
		assertEquals( true, r );
	}

	function getLuis(){
		return "luis";
	}

}
