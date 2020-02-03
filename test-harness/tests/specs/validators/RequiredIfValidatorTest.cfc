/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.RequiredIfValidator" {

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

			it( "can make targets required if the properties passed have the right value", function(){
				var mock = createStub()
					.$( "getName", "luis" )
                    .$( "getRole", "admin" )
                    .$( "getMissing", javacast( "null", "" ) );
				var result = createMock( "cbvalidation.models.result.ValidationResult" ).init();

				expect(
					model.validate( result, mock, "testField", "", "name:luis" )
				).toBeFalse();

				expect(
					model.validate( result, mock, "testField", "", "name:luis,role:admin" )
				).toBeFalse();
				expect(
					model.validate( result, mock, "testField", "test", "name:luis,role:admin" )
				).toBeTrue();

				expect(
					model.validate( result, mock, "testField", "shouldPass", "name:luis,role:admin" )
				).toBeTrue();

				expect(
					model.validate( result, mock, "testField", "", "name:luis" )
				).toBeFalse();

				expect(
				    model.validate( result, mock, "testField", javacast( "null", "" ), "missing" )
				).toBeFalse();

				expect(
				    model.validate( result, mock, "testField", "shouldPass", "missing" )
				).toBeTrue();
			} );

		});
	}

	}
