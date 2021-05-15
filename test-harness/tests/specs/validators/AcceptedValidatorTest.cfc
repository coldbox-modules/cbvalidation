component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.AcceptedValidator" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.setup();
		model.init();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "Accepted", function(){
			beforeEach( function( currentSpec ){
				result = createMock( "cbvalidation.models.result.ValidationResult" ).init();
			} );

			it( "can evaluate true when the value is 1,true,on and yes", function(){
				expect( model.validate( result, this, "testField", "1", "" ) ).toBeTrue();
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : "true",
						validationData  : "",
						rules           : {}
					)
				).toBeTrue();
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : "on",
						validationData  : "",
						rules           : {}
					)
				).toBeTrue();
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : "yes",
						validationData  : "",
						rules           : {}
					)
				).toBeTrue();
			} );

			it( "can evaluate false when the value is false, n or no", function(){
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : "false",
						validationData  : "",
						rules           : {}
					)
				).toBeFalse( "using false" );
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : "n",
						validationData  : "",
						rules           : {}
					)
				).toBeFalse( "using n" );
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : "no",
						validationData  : "",
						rules           : {}
					)
				).toBeFalse( "using no" );
			} );
		} );
	}

}
