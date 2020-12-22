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

	function run(){
		describe( "Integrations Specs", function(){
			beforeEach( function( currentSpec ){
				structDelete( application, "cbController" );
				structDelete( application, "wirebox" );
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
                            username     : "luis",
                            email        : "lmajano@ortussolutions.com",
                            password     : "luis"
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
                            username     : "luis",
                            email        : "lmajano@ortussolutions.com",
                            password     : "luis"
                        },
                        method = "post"
                    );

                    var result = e.getPrivateValue( "result" );
                    expect( result.getErrors()[ 1 ].getMessage() ).toBe( "This is a custom error message from within the udf" );
                } );
                then( "it should allow access to custom method metadata", function(){
                    var e = this.request(
                        route  = "/main/validateOnly",
                        params = {
                            username     : "luis",
                            email        : "lmajano@ortussolutions.com",
                            password     : "luis",
                            status       : 1,
                            type         : 4 // should not validate
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
                            username     : "luis",
                            email        : "lmajano@ortussolutions.com",
                            password     : "luis",
                            status       : 1,
                            type         : 4 // should not validate
                        },
                        method = "post"
                    );

                    var result = e.getPrivateValue( "result" );
                    expect( result.getErrors()[ 1 ].getMessage() ).toBe( "This is a custom error message from within the method" );
                    
                } );
            } );
        } );
	}

}
