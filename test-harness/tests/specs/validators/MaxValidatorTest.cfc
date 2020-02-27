/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.MaxValidator" {

	function setup(){
		super.setup();
		mockRB = createEmptyMock( "cbi18n.models.ResourceService" );
		mockRB.$( "getResource", "someErrorMessage" );
		model.init(mockRB);

	}

	function testValidateSimple(){
		result = createMock( "cbvalidation.models.result.ValidationResult" ).init();

		r = model.validate( result, this, "test", "66", "5" );
		assertEquals( false, r );

		r = model.validate( result, this, "test", "1", "5" );
		assertEquals( true, r );
	}

}
