/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.AlphaValidator" {

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
			it( "can evaluate true when alpha", function(){
				var result = createMock( "cbvalidation.models.result.ValidationResult" ).init();

				expect(
					model.validate(
						result,
						this,
						"testField",
						"alpha",
						""
					)
				).toBeTrue();
				expect(
					model.validate(
						result,
						this,
						"testField",
						"asdf22",
						""
					)
				).toBeFalse();
				expect(
					model.validate(
						result,
						this,
						"testField",
						"234--$",
						""
					)
				).toBeFalse();
			} );
		} );
	}

}
