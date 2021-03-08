/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.RequiredValidator" {

	function setup(){
		super.setup();
		model.init();
	}

	function testValidate(){
		result = createMock( "cbvalidation.models.result.ValidationResult" ).init();
        mockRB = getMockBox()
            .createEmptyMock( "cbi18n.models.ResourceService" )
            .$( "getResource" )
            .$results( "Some dummy message" );
        result.setResourceService( mockRB );
        result.setSettings( { i18nResource = "", CBVALIDATION_DEFAULT_RESOURCE ="cbvalidation", CBVALIDATION_CUSTOM_RESOURCE ="cbvalidationCustom" } );
		// null
		r      = model.validate(
			result,
			this,
			"test",
			javacast( "null", "" ),
			"true"
		);
		assertEquals( false, r );
		// empty
		r = model.validate( result, this, "test", "", "true" );
		assertEquals( false, r );

		// not empty
		r = model.validate( result, this, "test", "woot", "true" );
		assertEquals( true, r );

		// not empty
		r = model.validate(
			result,
			this,
			"test",
			"woot",
			"false"
		);
		assertEquals( true, r );
	}

	function testValidateComplex(){
		result = createMock( "cbvalidation.models.result.ValidationResult" ).init();
		// array
		r      = model.validate(
			result,
			this,
			"test",
			[ 1, 2, 3 ],
			"true"
		);
		assertEquals( true, r );

		// query
		r = model.validate(
			result,
			this,
			"test",
			querySim(
				"id, name
		1 | Luis"
			),
			"true"
		);
		assertEquals( true, r );

		// struct
		r = model.validate(
			result,
			this,
			"test",
			{ name : "luis", awesome : true },
			"true"
		);
		assertEquals( true, r );

		// object
		r = model.validate( result, this, "test", this, "true" );
		assertEquals( true, r );
	}

}
