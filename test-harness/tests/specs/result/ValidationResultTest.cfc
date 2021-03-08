/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.result.ValidationResult" {

	function setup(){
		super.setup();
		model.init();
        prepareMock(model);
        model.setSettings( { i18nResource = "", CBVALIDATION_DEFAULT_RESOURCE ="cbvalidation", CBVALIDATION_CUSTOM_RESOURCE ="cbvalidationCustom" } );
        mockRB = getMockBox()
        .createEmptyMock( "cbi18n.models.ResourceService" )
        .$( "getResource" )
        .$results( "Some dummy message" );
        model.setResourceService( mockRB );
//        model.$("getDefaultMessage","dummy message");
	}

	function testLocale(){
		assertFalse( model.hasLocale() );
		model.setLocale( "en_US" );
		assertTrue( model.hasLocale() );
		assertEquals( "en_US", model.getValidationLocale() );
	}

	function testTargetName(){
		model.setTargetName( "User" );
		assertEquals( "User", model.getTargetName() );
	}

	function testResultsMetadata(){
		assertTrue( structIsEmpty( model.getResultMetadata() ) );
		mock = { name : "luis", value : "majano" };
		model.setResultMetadata( mock );
		assertEquals( mock, model.getResultMetadata() );
	}

	function testAddError(){
		mockError = createMock( "cbvalidation.models.result.ValidationError" ).init();

		mockError.configure(
			"unit test",
			"test",
			"45",
			"inList",
			"1,2,3"
		);
		assertTrue( arrayLen( model.getErrors() ) eq 0 );

		model.addError( mockError );
		assertTrue( arrayLen( model.getErrors() ) eq 1 );

		// with custom messages
		mockError = createMock( "cbvalidation.models.result.ValidationError" ).init();
		mockError.configure(
			"unit test",
			"test",
			"",
			"required",
			"true"
		);
		mockConstraints = {
			"test" : {
                required        : true
            },
            "_messages" : {
                "test.required" : "This stuff is required dude for the field: {field}!"
			}
		};
		model.init( constraints = mockConstraints );
        model.setSettings( { i18nResource = "", CBVALIDATION_DEFAULT_RESOURCE ="cbvalidation", CBVALIDATION_CUSTOM_RESOURCE ="cbvalidationCustom" } );
 		assertTrue( arrayLen( model.getErrors() ) eq 0 );
		// test the custom messages now
		model.addError( mockError );
		assertTrue( arrayLen( model.getErrors() ) eq 1 );
		r = model.getFieldErrors( "test" )[ 1 ];
		assertEquals(
			"This stuff is required dude for the field: test!",
			r.getMemento().message
		);

		// with i18n
		mockError = createMock( "cbvalidation.models.result.ValidationError" ).init();
		mockError.configure(
			"unit test",
			"test",
			"45",
			"inList",
			"1,2,3"
		);
		model.setLocale( "en_US" );
        model.setSettings( { i18nResource = "some/path", CBVALIDATION_DEFAULT_RESOURCE ="cbvalidation", CBVALIDATION_CUSTOM_RESOURCE ="cbvalidationCustom" } );
        
		mockRB = getMockBox()
			.createEmptyMock( "cbi18n.models.ResourceService" )
			.$( "getResource" )
			.$results( "Your stuff doesn't work {field} {validationType} {validationData}","" );
		model.setResourceService( mockRB );

		model.addError( mockError );
		debug( mockError.getmemento() );
        debug(model.getSettings().i18nResource);
        debug(model.hasI18nResource());
		assertEquals(
			"Your stuff doesn't work test inList 1,2,3",
			mockError.getMessage()
		);
	}

	function testHasErrors(){
		assertFalse( model.hasErrors() );
		mockError = getMockBox()
			.createMock( "cbvalidation.models.result.ValidationError" )
			.init()
			.configure( "unit test", "test" );
		model.addError( mockError );
		assertTrue( model.hasErrors() );

		model.clearErrors();

		// with fields
		assertFalse( model.hasErrors( "test" ) );
		mockError = getMockBox()
			.createMock( "cbvalidation.models.result.ValidationError" )
			.init()
			.configure( "unit test", "test" );
		model.addError( mockError );
		assertTrue( model.hasErrors( "test" ) );
	}

	function testErrorCounts(){
		assertEquals( 0, model.getErrorCount() );
		assertEquals( 0, model.getErrorCount( "test" ) );

		mockError = getMockBox()
			.createMock( "cbvalidation.models.result.ValidationError" )
			.init()
			.configure( "unit test", "test" );
		model.addError( mockError );

		assertEquals( 1, model.getErrorCount() );
		assertEquals( 1, model.getErrorCount( "test" ) );
	}

	function testGetErrorAsStruct(){
		mockError = createMock( "cbvalidation.models.result.ValidationError" ).init();
		mockError.configure(
			"unit test",
			"test",
			"45",
			"inList",
			"1,2,3"
		);
		model.addError( mockError );

		// with custom messages
		mockError = createMock( "cbvalidation.models.result.ValidationError" ).init();
		mockError.configure(
			"unit test",
			"fname",
			"",
			"required",
			"true"
		);
		mockConstraints = {
			"test" : {
				required        : true,
				requiredMessage : "This stuff is required dude!"
			}
		};
		// test the custom messages now
		model.addError( mockError );

		r = model.getAllErrorsAsStruct();
		debug( r );
	}

	function testGetErrorAsJSON(){
		mockError = createMock( "cbvalidation.models.result.ValidationError" ).init();
		mockError.configure(
			"unit test",
			"test",
			"45",
			"inList",
			"1,2,3"
		);
		model.addError( mockError );

		// with custom messages
		mockError = createMock( "cbvalidation.models.result.ValidationError" ).init();
		mockError.configure(
			"unit test",
			"fname",
			"",
			"required",
			"true"
		);
		mockConstraints = {
			"test" : {
				required        : true,
				requiredMessage : "This stuff is required dude!"
			}
		};
		// test the custom messages now
		model.addError( mockError );

		r = model.getAllErrorsAsJSON();
		debug( r );
		assertTrue( isJSON( r ) );
	}

}
