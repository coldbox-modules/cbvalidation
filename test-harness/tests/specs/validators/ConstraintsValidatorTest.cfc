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
		describe( "Nested constraints validator", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				validator = getInstance( "ConstraintsValidator@cbValidation" );
			} );

			it( "can invalidate when you don't pass a struct", function(){
				var vResult = createMock( "cbvalidation.models.result.ValidationResult" ).init();
				expect(
					validator.validate(
						validationResult: vResult,
						target          : this,
						field           : "address",
						targetValue     : "I am a string",
						validationData  : {
							"streetOne" : { required : true, type : "string" },
							"streetTwo" : { required : false, type : "string" },
							"city"      : { required : true, type : "string" },
							"state"     : {
								required : true,
								type     : "string",
								size     : 2
							},
							"zip" : {
								required : true,
								type     : "numeric",
								size     : 5
							}
						},
						rules: {}
					)
				).toBeFalse();
				expect( vResult.getAllErrors() ).toBeArray();
				expect( vResult.getAllErrors() ).toHaveLength( 1 );
				expect( vResult.getAllErrors()[ 1 ] ).toBe( "The 'address' value 'I am a string' is not a Struct" );
			} );

			it( "can validate when all nested constraints pass", function(){
				var vResult = createMock( "cbvalidation.models.result.ValidationResult" ).init();
				expect(
					validator.validate(
						validationResult: vResult,
						target          : this,
						field           : "address",
						targetValue     : {
							"streetOne" : "123 Elm Street",
							"streetTwo" : "",
							"city"      : "Anytown",
							"state"     : "IL",
							"zip"       : "60606"
						},
						validationData: {
							"streetOne" : { required : true, type : "string" },
							"streetTwo" : { required : false, type : "string" },
							"city"      : { required : true, type : "string" },
							"state"     : {
								required : true,
								type     : "string",
								size     : 2
							},
							"zip" : {
								required : true,
								type     : "numeric",
								size     : 5
							}
						},
						rules: {}
					)
				).toBeTrue();
				expect( vResult.getAllErrors() ).toBeEmpty();
			} );

			it( "shows the nested field name when a nested constraint fails", function(){
				var vResult = createMock( "cbvalidation.models.result.ValidationResult" ).init();
				expect(
					validator.validate(
						validationResult: vResult,
						target          : this,
						field           : "address",
						targetValue     : {
							"streetOne" : "123 Elm Street",
							"streetTwo" : "",
							"city"      : "Anytown",
							"state"     : "",
							"zip"       : "60606"
						},
						validationData: {
							"streetOne" : { required : true, type : "string" },
							"streetTwo" : { required : false, type : "string" },
							"city"      : { required : true, type : "string" },
							"state"     : {
								required : true,
								type     : "string",
								size     : 2
							},
							"zip" : {
								required : true,
								type     : "numeric",
								size     : 5
							}
						},
						rules: {}
					)
				).toBeFalse();
				expect( vResult.getAllErrors() ).toBeArray();
				expect( vResult.getAllErrors() ).toHaveLength( 1 );
				expect( vResult.getAllErrors()[ 1 ] ).toBe(
					"Validation failed for [address.state]: The 'state' value is required"
				);
			} );

			it( "can nest more than one level", function(){
				var vResult = createMock( "cbvalidation.models.result.ValidationResult" ).init();
				expect(
					validator.validate(
						validationResult: vResult,
						target          : this,
						field           : "owner",
						targetValue     : {
							"firstName" : "John",
							"lastName"  : "Doe",
							"address"   : {
								"streetOne" : "123 Elm Street",
								"streetTwo" : "",
								"city"      : "Anytown",
								"state"     : "",
								"zip"       : "60606"
							}
						},
						validationData: {
							"firstName" : { "required" : true, "type" : "string" },
							"lastName"  : { "required" : true, "type" : "string" },
							"address"   : {
								"required"    : true,
								"type"        : "struct",
								"constraints" : {
									"streetOne" : { required : true, type : "string" },
									"streetTwo" : { required : false, type : "string" },
									"city"      : { required : true, type : "string" },
									"state"     : {
										required : true,
										type     : "string",
										size     : 2
									},
									"zip" : {
										required : true,
										type     : "numeric",
										size     : 5
									}
								}
							}
						},
						rules: {}
					)
				).toBeFalse();
				expect( vResult.getAllErrors() ).toBeArray();
				expect( vResult.getAllErrors() ).toHaveLength( 1 );
				expect( vResult.getAllErrors()[ 1 ] ).toBe(
					"Validation failed for [owner.address.state]: The 'state' value is required"
				);
			} );
		} );
	}

}
