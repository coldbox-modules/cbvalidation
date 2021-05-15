component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "Array validator", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				validator = getInstance( "ArrayItemValidator@cbValidation" );
			} );

			it( "can invalidate when you don't pass an array", function(){
				var vResult = createMock( "cbvalidation.models.result.ValidationResult" ).init();
				expect(
					validator.validate(
						validationResult: vResult,
						target          : this,
						field           : "testField",
						targetValue     : "I am a string",
						validationData  : {
							"name" : { required : true },
							"age"  : { required : true, range : "18..50" }
						},
						rules: {}
					)
				).toBeFalse();
			} );

			it( "can validate when all items pass the constraints", function(){
				var vResult = createMock( "cbvalidation.models.result.ValidationResult" ).init();
				expect(
					validator.validate(
						validationResult: vResult,
						target          : this,
						field           : "testField",
						targetValue     : [
							{ name : "luis", age : 44 },
							{ name : "joe", age : 19 }
						],
						validationData: {
							"name" : { required : true },
							"age"  : { required : true, range : "18..50" }
						},
						rules: {}
					)
				).toBeTrue();
			} );

			it( "can invalidate when 1+ items fail", function(){
				var vResult = createMock( "cbvalidation.models.result.ValidationResult" ).init();
				expect(
					validator.validate(
						validationResult: vResult,
						target          : this,
						field           : "testField",
						targetValue     : [
							{ name : "luis", age : 44 },
							{ name : "joe", age : 19 },
							{ name : "eric", age : 1 },
							{ name : "eric" }
						],
						validationData: {
							"name" : { required : true },
							"age"  : { required : true, range : "18..50" }
						},
						rules: {}
					)
				).toBeFalse();
				expect( vResult.getAllErrors() ).toHaveLength( 2 );
			} );
		} );
	}

}
