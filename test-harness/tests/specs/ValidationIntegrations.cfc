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
	}

}
