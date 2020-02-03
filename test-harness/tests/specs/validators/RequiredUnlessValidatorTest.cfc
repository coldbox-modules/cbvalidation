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
		describe( "RequiredUnless", function(){

			it( "can make targets required unless the properties passed have the right value", function(){
				var mock = createStub()
					.$( "getName", "luis" )
					.$( "getRole", "admin" );
				var result = createMock( "cbvalidation.models.result.ValidationResult" ).init();

				expect(
					model.validate( result, mock, "testField", "", "" )
				).toBeFalse();

				expect(
					model.validate( result, mock, "testField", "", "name:luis,role:admin" )
				).toBeTrue();

				expect(
					model.validate( result, mock, "testField", "shouldPass", "name:luis,role:admin" )
				).toBeTrue();

				expect(
					model.validate( result, mock, "testField", "", "name:luis,role:admin" )
				).toBeTrue();

				expect(
					model.validate( result, mock, "testField", "", "name:luis" )
				).toBeTrue();

				expect(
					model.validate( result, mock, "testField", "", "name:luiss" )
				).toBeFalse();

				expect(
					model.validate( result, mock, "testField", javaCast( "null", "" ), "name:luiss" )
				).toBeFalse();

				expect(
					model.validate( result, mock, "testField", javaCast( "null", "" ), "name:luis" )
				).toBeTrue();
				
				expect(
					model.validate( result, mock, "testField", javaCast( "null", "" ), "missing" )
				).toBeFalse();
				
				expect(
					model.validate( result, mock, "testField", "not null", "missing" )
				).toBeTrue();

			} );

		});
	}

}
