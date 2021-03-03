/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.RequiredUnlessValidator" {

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
		xdescribe( "RequiredUnless", function(){
			it( "can make targets required unless the properties passed have the right value", function(){
				var mock = createStub()
					.$( "getName", "luis" )
					.$( "getRole", "admin" )
					.$( "getMissing", javacast( "null", "" ) );
				var result = createMock( "cbvalidation.models.result.ValidationResult" ).init();


				// Empty string for validation data
				expect( model.validate( result, mock, "testField", "", "" ) ).toBeFalse();

				// Empty struct for validation data
				expect( model.validate( result, mock, "testField", "", {} ) ).toBeFalse();



				expect(
					model.validate(
						result,
						mock,
						"testField",
						"shouldPass",
						{ "name" : "luis", "role" : "admin" }
					)
				).toBeTrue();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						"",
						{ "name" : "luis", "role" : "admin" }
					)
				).toBeTrue();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						"",
						{ "name" : "luis" }
					)
				).toBeTrue();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						"",
						{ "name" : "luiss" }
					)
				).toBeFalse();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						javacast( "null", "" ),
						{ "name" : "luiss" }
					)
				).toBeFalse();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						javacast( "null", "" ),
						{ "name" : "luis" }
					)
				).toBeTrue();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						javacast( "null", "" ),
						{ missing : javacast( "null", "" ) }
					)
				).toBeTrue();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						"not null",
						{ missing : javacast( "null", "" ) }
					)
				).toBeTrue();
			} );
		} );
	}

}
