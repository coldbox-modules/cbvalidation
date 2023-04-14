/**
 * *******************************************************************************
 * *******************************************************************************
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.InstanceOfValidator" {

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
		describe( "InstanceOf", function(){
			beforeEach( function( currentSpec ){
				result = createMock( "cbvalidation.models.result.ValidationResult" ).init();
			} );

			it( "validates true when expecting a User and receives a User", function(){
				var user = createMock( "root.models.User" ).init();

				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : user,
						validationData  : "user",
						rules           : {}
					)
				).toBeTrue();
			} );

			it( "validates false when expecting a Car and receives a User", function(){
				var user = createMock( "root.models.User" ).init();

				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : user,
						validationData  : "car",
						rules           : {}
					)
				).toBeFalse();
			} );

			it( "validates true when passed nothing", function(){
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : "",
						validationData  : "car",
						rules           : {}
					)
				).toBeTrue();
			} );

			it( "validates false when passed a non-object", function(){
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : "not an object", // not an object
						validationData  : "car",
						rules           : {}
					)
				).toBeFalse();
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : { "name" : "not an object" }, // not an object
						validationData  : "car",
						rules           : {}
					)
				).toBeFalse();
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : [ 1, 2, 3 ], // not an object
						validationData  : "car",
						rules           : {}
					)
				).toBeFalse();
			} );
		} );
	}

}
