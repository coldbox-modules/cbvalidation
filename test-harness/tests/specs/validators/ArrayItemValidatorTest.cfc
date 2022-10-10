component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	this.unLoadColdBox = false;

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
						field           : "luckyNumbers",
						targetValue     : [ 7, 11, 21, 111 ],
						validationData  : { "required" : true, "type" : "numeric" },
						rules           : {}
					)
				).toBeTrue();
			} );

			it( "can fail appropriately using simple values", function(){
				var vResult = createMock( "cbvalidation.models.result.ValidationResult" ).init();
				expect(
					validator.validate(
						validationResult: vResult,
						target          : this,
						field           : "luckyNumbers",
						targetValue     : [ 7, 11, "not a number", 111 ],
						validationData  : { "required" : true, "type" : "numeric" },
						rules           : {}
					)
				).toBeFalse();
				expect( vResult.getAllErrors( "luckyNumbers[3]" ) ).toHaveLength( 1 );
				expect( vResult.getAllErrors( "luckyNumbers[3]" )[ 1 ] ).toBe(
					"The 'item' has an invalid type, expected type is numeric"
				);
			} );

			it( "can validate nested structs", function(){
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
							"constraints" : {
								"name" : { required : true },
								"age"  : { required : true, range : "18..50" }
							}
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
							"constraints" : {
								"name" : { required : true },
								"age"  : { required : true, range : "18..50" }
							}
						},
						rules: {}
					)
				).toBeFalse();
				expect( vResult.getAllErrors( "testField[3].age" ) ).toHaveLength( 1 );
				expect( vResult.getAllErrors( "testField[3].age" )[ 1 ] ).toBe(
					"The 'age' value is not the value field range (18..50)"
				);
				expect( vResult.getAllErrors( "testField[4].age" ) ).toHaveLength( 1 );
				expect( vResult.getAllErrors( "testField[4].age" )[ 1 ] ).toBe( "The 'age' value is required" );
			} );
		} );
	}

}
