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

	function testProcessRulesIgnoresInvalidValidators(){
		results = getMockBox().createMock( "cbvalidation.models.result.ValidationResult" ).init();

		mockRule = {
			required = true,
			testMessage="Hello",
			uniqueMessage="Not Unique Man",
			udf = variables._validateit
		};

		var mock = createStub().$( "getName","luis" );
		model.processRules( results=results, rules=mockRule, target=mock, field="name" );

		assertEquals( 0, results.getErrorCount() );

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


	private function _validateit( targetValue, target ){
		return true;
	}

}