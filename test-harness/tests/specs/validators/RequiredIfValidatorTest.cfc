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
					model.validate(
						result,
						mock,
						"testField",
						javacast( "null", "" ),
						{ missing : javacast( "null", "" ) }
					)
				).toBeFalse();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						"",
						{ name : "luis" }
					)
				).toBeFalse();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						"",
						{ name : "luis", role : "admin" }
					)
				).toBeFalse();
				expect(
					model.validate(
						result,
						mock,
						"testField",
						"test",
						{ name : "luis", role : "admin" }
					)
				).toBeTrue();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						"shouldPass",
						{ name : "luis", role : "admin" }
					)
				).toBeTrue();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						"",
						{ name : "luis" }
					)
				).toBeFalse();

				expect(
					model.validate(
						result,
						mock,
						"testField",
						"shouldPass",
						{ missing : javacast( "null", "" ) }
					)
				).toBeTrue();
			} );

			it( "simply checks for existence when passing in a simple value", function(){
				var mock = createStub()
					.$( "getName", "luis" )
					.$( "getRole", "admin" )
					.$( "getMissing", javacast( "null", "" ) );
				var result = createMock( "cbvalidation.models.result.ValidationResult" ).init();

				expect( model.validate( result, mock, "testField", "", "name" ) ).toBeFalse();

				expect(
                    model.validate(
                        result,
                        mock,
                        "testField",
                        "",
                        "missing"
                    )
				).toBeTrue();
			} );
            it( "can accept a closure as validationData", function(){
				var mock = createStub()
					.$( "getName", "luis" )
					.$( "getRole", "admin" )
					.$( "getMissing", javacast( "null", "" ) );
				var result = createMock( "cbvalidation.models.result.ValidationResult" ).init();

				expect( 
                    model.validate( 
                        result, 
                        mock, 
                        "testField", 
                        "", 
                        isRequired1 
                    ) ).toBeFalse();

				expect(
                    model.validate(
                        result,
                        mock,
                        "testField",
                        "",
                        isRequired2
                    )
				).toBeTrue();
			} );
            it( "can use custom error metadata", function(){
				var mock = createStub()
					.$( "getName", "luis" )
					.$( "getRole", "admin" )
					.$( "getMissing", javacast( "null", "" ) );
				var result = createMock( "cbvalidation.models.result.ValidationResult" ).init();

				expect( 
                    model.validate( 
                        result, 
                        mock, 
                        "testField", 
                        "", 
                        isRequired3 
                    ) ).toBeFalse();

                var errorMetadata = result.getErrors()[ 1 ].getErrorMetadata();

                expect( errorMetaData ).toHaveKey( "customMessage" );
                expect( errorMetaData.customMessage ).toBe( "This is custom data" );
                
			} );
		} );
	}

    private function isRequired1( value, target, errorMetadata ){
		return true;
	}

    private function isRequired2( value, target, errorMetadata ){
		return false;
	}

    private function isRequired3( value, target, errorMetadata ){
		arguments.errorMetadata[ "customMessage" ] = "This is custom data";
        return true;
	}

}
