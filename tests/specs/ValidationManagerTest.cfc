/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.ValidationManager"{

	function setup(){
		super.setup();
		mockRB = getMockBox().createEmptyMock("cbi18n.models.ResourceService");
		model.init();
		model.setWireBox( mockWireBox );
		model.setResourceService( mockRB );
	}

	function testProcessRules(){
		results = getMockBox().createMock( "cbvalidation.models.result.ValidationResult" ).init();
		//mockValidator = getMockBox().createMock("coldbox.test.specs.validation.resources.MockValidator");

		//model.$("getValidator", mockValidator);

		mockRules = {
			required = true,
			sameAs = "joe",
			udf = variables._validateit
		};

		getMockBox().prepareMock( this ).$( "getName","luis" ).$( "getJoe", "luis" );
		model.processRules( results=results, rules=mockRules, target=this, field="name" );

		assertEquals( 0, results.getErrorCount() );

	}

	function testIgnoresAllKeysEndingInMessage(){
		var results = getMockBox()
			.createMock( "cbvalidation.models.result.ValidationResult" )
			.init();

		var mockRule = {
			required = true,
			testMessage="Hello",
			uniqueMessage="Not Unique Man",
			udf = variables._validateit
		};

		var mock = createStub().$( "getName","luis" );
		model.processRules( results=results, rules=mockRule, target=mock, field="name" );

		assertEquals( 0, results.getErrorCount() );
	}

	function testProcessRulesLooksForWireBoxMappingOfKeyIfNotAValidValidator() {
		var results = getMockBox()
			.createMock( "cbvalidation.models.result.ValidationResult" )
			.init();

		var customValidatorMock = getMockBox()
			.createStub( implements = "cbvalidation.models.validators.IValidator" );
		customValidatorMock.$( "validate", true );

		var mockBinder = getMockBox()
			.createMock( "coldbox.system.ioc.config.Binder" );
		mockBinder.$( "mappingExists" )
			.$args( "customValidator" )
			.$results( true );

		mockWireBox.$( "getBinder", mockBinder );
		mockWireBox
			.$( "getInstance" )
			.$args( "customValidator" )
			.$results( customValidatorMock );

		var mockRule = {
			customValidator = {
				customField = "hi"
			}
		};

		var mock = createStub().$( "getName","luis" );
		model.processRules( results=results, rules=mockRule, target=mock, field="name" );

		assertTrue( customValidatorMock.$once( "validate" ), "[validate] should have been called on [customValidator]" );
		var args = customValidatorMock.$callLog().validate[ 1 ];
		assertEquals( args.validationData, { customField = "hi" }, "validationData was not passed through correctly to [customValidator]" );
	}

	function testGetConstraints(){
		assertTrue( structIsEmpty( model.getSharedConstraints() ) );
		data = { 'test' = {} };
		model.setSharedConstraints( data );
		debug( model.getSharedConstraints() );
		assertTrue( structIsEmpty( model.getSharedConstraints('test') ) );
	}

	function testGenericForm(){

		mockData = { name="luis", age="33" };
		mockConstraints = {
			name = {required=true}, age = {required=true, max="35"}
		};

		r = model.validate(target=mockData,constraints=mockConstraints);
		assertEquals( false, r.hasErrors() );

		mockData = { name="luis", age="55" };
		r = model.validate(target=mockData,constraints=mockConstraints);
		assertEquals( true, r.hasErrors() );
		debug( r.getAllErrors() );
	}

	function testWithFields(){
		mockData = { name="", age="" };
		mockConstraints = {
			name = {required=true}, age = {required=true, max="35"}
		};

		r = model.validate( target=mockData, fields="name", constraints=mockConstraints);
		assertEquals( true, r.hasErrors() );
		assertEquals( 0, arrayLen( r.getFieldErrors("age") ) );
		assertEquals( 1, arrayLen( r.getFieldErrors("name") ) );
	}

	function testWithExcludedFields(){
		mockData = { name="", age="" };
		mockConstraints = {
			name = {required=true}, age = {required=true, max="35"}
		};

		r = model.validate(target=mockData, constraints=mockConstraints, excludeFields="age");
		assertEquals( true, r.hasErrors() );
		assertEquals( 0, arrayLen( r.getFieldErrors("age") ) );
		assertEquals( 1, arrayLen( r.getFieldErrors("name") ) );
	}

	function testWithIncludeFields(){
		mockData = { name="", age="" };
		mockConstraints = {
			name = {required=true}, age = {required=true, max="35"}
		};

		r = model.validate(target={ age=30 }, constraints=mockConstraints, includeFields="age");
		assertEquals( false, r.hasErrors() );
	}


	private function _validateit( targetValue, target ){
		return true;
	}

}