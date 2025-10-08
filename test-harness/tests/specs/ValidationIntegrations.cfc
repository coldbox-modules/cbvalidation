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

	function run(){
		describe( "Integrations Specs", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			story( "validate or fail with structures", function(){
				given( "invalid data", function(){
					then( "it should throw an exception", function(){
						expect( function(){
							this.request(
								route  = "/main/validateOrFailWithKeys",
								params = {},
								method = "post"
							);
						} ).toThrow();
					} );
				} );

				given( "valid data", function(){
					then( "it should give you back the validated keys", function(){
						var e = this.request(
							route  = "/main/validateOrFailWithKeys",
							params = {
								username     : "luis",
								password     : "luis",
								bogus        : now(),
								anotherBogus : now()
							},
							method = "post"
						);

						var keys = e.getPrivateValue( "keys" );
						debug( keys );
						expect( keys )
							.toBeStruct()
							.toHaveKey( "username" )
							.toHaveKey( "password" )
							.notToHaveKey( "bogus" )
							.notToHaveKey( "anotherBogus" );
					} );
				} );

				given( "valid nested data", function(){
					then( "it should give you back only the validated keys including in nested structs", function(){
						var e = this.request(
							route  = "/main/validateOrFailWithNestedKeys",
							params = {
								"keepNested0" : {
									"keepNested1" : { "keep2" : "foo", "remove2" : "foo" },
									"keepArray1"  : [
										{ "keepNested3" : "foo", "removeNested3" : "foo" },
										{ "keepNested3" : "bar", "removeNested3" : "bar" }
									],
									"keepArray1B"   : [ [ "foo", "bar" ], [ "baz", "qux" ] ],
									"removeNested1" : { "foo" : "bar" },
									"remove1"       : "foo"
								},
								"keepNested0B" : { "keep1B" : "foo", "remove1B" : "foo" },
								"keep0"        : "foo",
								"remove0"      : "foo"
							},
							method = "post"
						);

						var keys = e.getPrivateValue( "keys" );
						debug( keys );
						expect( keys ).toBeStruct();
						expect( keys ).toHaveKey( "keepNested0" );
						expect( keys ).toHaveKey( "keepNested0B" );
						expect( keys ).toHaveKey( "keep0" );
						expect( keys ).notToHaveKey( "remove0" );

						var nested0 = keys.keepNested0;
						expect( nested0 ).toBeStruct();
						expect( nested0 ).toHaveKey( "keepNested1" );
						expect( nested0 ).toHaveKey( "keepArray1" );
						expect( nested0 ).toHaveKey( "keepArray1B" );
						expect( nested0 ).notToHaveKey( "remove1" );
						expect( nested0 ).notToHaveKey( "removeNested1" );

						var nested1 = nested0.keepNested1;
						expect( nested1 ).toBeStruct();
						expect( nested1 ).toHaveKey( "keep2" );
						expect( nested1 ).notToHaveKey( "remove2" );

						var array1 = nested0.keepArray1;
						expect( array1 ).toBeArray();
						expect( array1 ).toHaveLength( 2 );
						expect( array1[ 1 ] ).toBeStruct();
						expect( array1[ 1 ] ).toHaveKey( "keepNested3" );
						expect( array1[ 1 ] ).notToHaveKey( "removeNested3" );
						expect( array1[ 2 ] ).toBeStruct();
						expect( array1[ 2 ] ).toHaveKey( "keepNested3" );
						expect( array1[ 2 ] ).notToHaveKey( "removeNested3" );

						var array1B = nested0.keepArray1B;
						expect( array1B ).toBeArray();
						expect( array1B ).toHaveLength( 2 );
						expect( array1B[ 1 ] ).toBeArray();
						expect( array1B[ 1 ] ).toHaveLength( 2 );
						expect( array1B[ 1 ][ 1 ] ).toBeString();
						expect( array1B[ 1 ][ 1 ] ).toBe( "foo" );
						expect( array1B[ 1 ][ 2 ] ).toBeString();
						expect( array1B[ 1 ][ 2 ] ).toBe( "bar" );

						expect( array1B[ 2 ] ).toBeArray();
						expect( array1B[ 2 ] ).toHaveLength( 2 );
						expect( array1B[ 2 ][ 1 ] ).toBeString();
						expect( array1B[ 2 ][ 1 ] ).toBe( "baz" );
						expect( array1B[ 2 ][ 2 ] ).toBeString();
						expect( array1B[ 2 ][ 2 ] ).toBe( "qux" );

						var nested0B = keys.keepNested0B;
						expect( nested0B ).toBeStruct();
						expect( nested0B ).toHaveKey( "keep1B" );
						expect( nested0B ).notToHaveKey( "remove1B" );
					} );
				} );
			} );

			story( "validate or fail with objects", function(){
				given( "invalid data", function(){
					then( "it should throw an exception", function(){
						expect( function(){
							this.request(
								route  = "/main/validateOrFailWithObject",
								params = {},
								method = "post"
							);
						} ).toThrow();
					} );
				} );

				given( "valid data", function(){
					then( "it should give you back the validated object", function(){
						var e = this.request(
							route  = "/main/validateOrFailWithObject",
							params = {
								username     : "luis",
								password     : "luis",
								email        : "lmajano@ortussolutions.com",
								status       : 1,
								bogus        : now(),
								anotherBogus : now()
							},
							method = "post"
						);

						var object = e.getPrivateValue( "object" );
						debug( object );
						expect( object ).toBeComponent();
					} );
				} );
			} );


			story( "I want to Validate with contraint profiles", function(){
				given( "a single profile", function(){
					then( "it must validate it with only those fields in that profile", function(){
						var e = this.request(
							route  = "/main/validateOrFailWithProfiles",
							params = {
								username     : "luis",
								email        : "lmajano@ortussolutions.com",
								bogus        : now(),
								anotherBogus : now(),
								_profiles    : "update"
							},
							method = "post"
						);

						var object = e.getPrivateValue( "object" );
						debug( object );
						expect( object ).toBeComponent();
					} );
				} );
				given( "a multiple profiles", function(){
					then( "it must validate it with only distinct fields in those profiles", function(){
						var e = this.request(
							route  = "/main/validateOrFailWithProfiles",
							params = {
								username     : "luis",
								email        : "lmajano@ortussolutions.com",
								password     : "luis",
								anotherBogus : now(),
								_profiles    : "update,new,bogus"
							},
							method = "post"
						);

						var object = e.getPrivateValue( "object" );
						debug( object );
						expect( object ).toBeComponent();
					} );
				} );
				given( "a single profile and invalid data", function(){
					then( "then throw the exception", function(){
						expect( function(){
							this.request(
								route  = "/main/validateOrFailWithProfiles",
								params = { username : "luis" },
								method = "post"
							);
						} ).toThrow();
					} );
				} );
			} );
		} );


		story( "I want to access error metadata in UDF and method validators", function(){
			given( "invalid data", function(){
				then( "it should allow access to custom udf metadata", function(){
					var e = this.request(
						route  = "/main/validateOnly",
						params = {
							username : "luis",
							email    : "lmajano@ortussolutions.com",
							password : "luis",
							status   : 4 // should not validate
						},
						method = "post"
					);

					var result = e.getPrivateValue( "result" );

					expect( result.getErrors().len() ).toBe( 1 );
					expect( result.getErrors()[ 1 ].getValidationType() ).toBe( "UDF" );
					expect( result.getErrors()[ 1 ].getErrorMetaData() ).toHaveKey( "custom" );
				} );
				then( "it should allow udf generated error messages based on metadata", function(){
					var e = this.request(
						route  = "/main/validateOnly",
						params = {
							username : "luis",
							email    : "lmajano@ortussolutions.com",
							password : "luis"
						},
						method = "post"
					);

					var result = e.getPrivateValue( "result" );
					expect( result.getErrors()[ 1 ].getMessage() ).toBe(
						"This is a custom error message from within the udf"
					);
				} );
				then( "it should allow access to custom method metadata", function(){
					var e = this.request(
						route  = "/main/validateOnly",
						params = {
							username : "luis",
							email    : "lmajano@ortussolutions.com",
							password : "luis",
							status   : 1,
							type     : 4 // should not validate
						},
						method = "post"
					);

					var result = e.getPrivateValue( "result" );

					expect( result.getErrors().len() ).toBe( 1 );
					expect( result.getErrors()[ 1 ].getValidationType() ).toBe( "method" );
					expect( result.getErrors()[ 1 ].getErrorMetaData() ).toHaveKey( "custom" );
				} );
				then( "it should allow method generated error messages based on metadata", function(){
					var e = this.request(
						route  = "/main/validateOnly",
						params = {
							username : "luis",
							email    : "lmajano@ortussolutions.com",
							password : "luis",
							status   : 1,
							type     : 4 // should not validate
						},
						method = "post"
					);

					var result = e.getPrivateValue( "result" );
					expect( result.getErrors()[ 1 ].getMessage() ).toBe(
						"This is a custom error message from within the method"
					);
				} );
			} );
		} );
	}

}
