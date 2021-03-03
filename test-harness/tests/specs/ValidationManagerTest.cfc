/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.ValidationManager" {

	function setup(){
		super.setup();
		mockRB = createEmptyMock( "cbi18n.models.ResourceService" );
        mockRB.$("getResource","someString");
		model.init();
		model.setWireBox( mockWireBox );
		model.setResourceService( mockRB );
        model.setSettings( { i18nResource = "", CBVALIDATION_DEFAULT_RESOURCE ="cbvalidation", CBVALIDATION_CUSTOM_RESOURCE ="cbvalidationCustom" } );
	}

	function testProcessRules(){
		results = createMock( "cbvalidation.models.result.ValidationResult" ).init();
		// mockValidator = createMock("coldbox.test.specs.validation.resources.MockValidator");

		// model.$("getValidator", mockValidator);

		mockRules = {
			required : true,
			sameAs   : "joe",
			udf      : variables._validateit
		};

		prepareMock( this ).$( "getName", "luis" ).$( "getJoe", "luis" );
		model.processRules(
			results = results,
			rules   = mockRules,
			target  = this,
			field   = "name"
		);

		assertEquals( 0, results.getErrorCount() );
	}

	function testIgnoresAllKeysEndingInMessage(){
		var results = createMock( "cbvalidation.models.result.ValidationResult" ).init();

		var mockRule = {
			required      : true,
			testMessage   : "Hello",
			uniqueMessage : "Not Unique Man",
			udf           : variables._validateit
		};

		var mock = createStub().$( "getName", "luis" );
		model.processRules(
			results = results,
			rules   = mockRule,
			target  = mock,
			field   = "name"
		);

		assertEquals( 0, results.getErrorCount() );
	}

	function testProcessRulesLooksForWireBoxMappingOfKeyIfNotAValidValidator(){
		var results = createMock( "cbvalidation.models.result.ValidationResult" ).init();

		var customValidatorMock = createMock( "cbvalidation.models.validators.RequiredValidator" );
		customValidatorMock.$( "validate", true );

		var mockBinder = createMock( "coldbox.system.ioc.config.Binder" );
		mockBinder
			.$( "mappingExists" )
			.$args( "customValidator" )
			.$results( true );


		mockWireBox.setBinder( mockBinder );
		mockWireBox
			.$( "getInstance" )
			.$args( "customValidator" )
			.$results( customValidatorMock );

		var mockRule = { customValidator : { customField : "hi" } };
		var mock     = createStub().$( "getName", "luis" );
		model.processRules(
			results = results,
			rules   = mockRule,
			target  = mock,
			field   = "name"
		);

		assertTrue(
			customValidatorMock.$once( "validate" ),
			"[validate] should have been called on [customValidator]"
		);
		var args = customValidatorMock.$callLog().validate[ 1 ];
		assertEquals(
			args.validationData,
			{ customField : "hi" },
			"validationData was not passed through correctly to [customValidator]"
		);
	}

	function testGetConstraints(){
		assertTrue( structIsEmpty( model.getSharedConstraints() ) );
		data = { "test" : {} };
		model.setSharedConstraints( data );
		debug( model.getSharedConstraints() );
		assertTrue( structIsEmpty( model.getSharedConstraints( "test" ) ) );
	}

	function testGenericForm(){
		mockData        = { name : "luis", age : "33" };
		mockConstraints = {
			name : { required : true },
			age  : { required : true, max : "35" }
		};

		r = model.validate(
			target      = mockData,
			constraints = mockConstraints
		);
		assertEquals( false, r.hasErrors() );

		mockData = { name : "luis", age : "55" };
		r        = model.validate(
			target      = mockData,
			constraints = mockConstraints
		);
		assertEquals( true, r.hasErrors() );
		debug( r.getAllErrors() );
	}

	function testWithFields(){
		mockData        = { name : "", age : "" };
		mockConstraints = {
			name : { required : true },
			age  : { required : true, max : "35" }
		};

		r = model.validate(
			target      = mockData,
			fields      = "name",
			constraints = mockConstraints
		);
		assertEquals( true, r.hasErrors() );
		assertEquals(
			0,
			arrayLen( r.getFieldErrors( "age" ) )
		);
		assertEquals(
			1,
			arrayLen( r.getFieldErrors( "name" ) )
		);
	}

	function testWithExcludedFields(){
		mockData        = { name : "", age : "" };
		mockConstraints = {
			name : { required : true },
			age  : { required : true, max : "35" }
		};

		r = model.validate(
			target        = mockData,
			constraints   = mockConstraints,
			excludeFields = "age"
		);
		assertEquals( true, r.hasErrors() );
		assertEquals(
			0,
			arrayLen( r.getFieldErrors( "age" ) )
		);
		assertEquals(
			1,
			arrayLen( r.getFieldErrors( "name" ) )
		);
	}

	function testWithIncludeFields(){
		mockData        = { name : "", age : "" };
		mockConstraints = {
			name : { required : true },
			age  : { required : true, max : "35" }
		};

		r = model.validate(
			target        = { age : 30 },
			constraints   = mockConstraints,
			includeFields = "age"
		);
		assertEquals( false, r.hasErrors() );
	}


	private function _validateit( targetValue, target ){
		return true;
	}

}
