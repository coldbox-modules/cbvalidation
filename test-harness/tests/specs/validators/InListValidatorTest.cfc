/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.InListValidator" {

	function setup(){
		super.setup();
		mockRB = createEmptyMock( "cbi18n.models.ResourceService" );
		mockRB.$( "getResource", "someErrorMessage" );
		model.init(mockRB);
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
