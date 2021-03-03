/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.AcceptedValidator"  {

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
		xdescribe( "Accepted", function(){
			it( "can evaluate true when the value is 1,true,on and yes", function(){
				var result = createMock( "cbvalidation.models.result.ValidationResult" ).init();

				expect( model.validate( result, this, "testField", "1", "" ) ).toBeTrue();
				expect(
					model.validate(
						result,
						this,
						"testField",
						"true",
						""
					)
				).toBeTrue();
				expect( model.validate( result, this, "testField", "on", "" ) ).toBeTrue();
				expect( model.validate( result, this, "testField", "yes", "" ) ).toBeTrue();

				expect(
					model.validate(
						result,
						this,
						"testField",
						"false",
						""
					)
				).toBeFalse();
				expect( model.validate( result, this, "testField", "n", "" ) ).toBeFalse();
				expect( model.validate( result, this, "testField", "no", "" ) ).toBeFalse();
			} );
		} );
	}

}
