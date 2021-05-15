component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.RangeValidator" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.setup();
		model.init();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "Accepted", function(){
			beforeEach( function( currentSpec ){
				result = createMock( "cbvalidation.models.result.ValidationResult" ).init();
			} );

			it( "can validate different range values", function(){
				r = model.validate(
					validationResult: result,
					target          : this,
					field           : "test",
					targetValue     : "10",
					validationData  : "1..10",
					rules           : {}
				);
				assertEquals( true, r );

				r = model.validate(
					validationResult: result,
					target          : this,
					field           : "test",
					targetValue     : "3",
					validationData  : "3..20",
					rules           : {}
				);
				assertEquals( true, r );

				r = model.validate(
					validationResult: result,
					target          : this,
					field           : "test",
					targetValue     : "123",
					validationData  : "5..9",
					rules           : {}
				);
				assertEquals( false, r );
			} );
		} );
	}

}
