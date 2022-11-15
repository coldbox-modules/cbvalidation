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
		describe( "Validatable Spec", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				delegate         = getInstance( "Validatable@cbValidation" );
				delegate.injectPropertyMixin( "$parent", this );
			} );

			it( "can be created", function(){
				expect( delegate ).toBeComponent()
			} );

			it( "can validate if a target has value", function(){
				expect( delegate.validateHasValue( "test" ) ).toBeTrue();
				expect( delegate.validateHasValue( "" ) ).toBeFalse();
			} );

			it( "can validate if a target is null or empty", function(){
				expect( delegate.validateIsNullOrEmpty( "" ) ).toBeTrue();
				expect( delegate.validateIsNullOrEmpty( javacast( "null", "" ) ) ).toBeTrue();
				expect( delegate.validateIsNullOrEmpty( "test" ) ).toBeFalse();
			} );

			it( "can validate if a target can be asserted", function(){
				expect( delegate.assert( true ) ).toBeTrue();
				expect( () => delegate.assert( javacast( "null", "" ) ) ).toThrow();
				expect( () => delegate.assert( false ) ).toThrow();
			} );

			it( "can validate", function(){
				var results = delegate.validate();
				expect( results.hasErrors() ).toBeFalse();
			});

			it( "can validate or fail", function(){
				expect( () => delegate.validateOrFail() ).notToThrow();
				expect( () => delegate.validateOrFail(
					constraints = {
						"data" : { required : true }
					}
				) ).toThrow();
			});

			it( "can self validate", function(){
				var results = delegate.isValid();
				expect( results ).toBeTrue();
				expect( delegate.getValidationResults().hasErrors() ).toBeFalse();
			});
		} );
	}

	function getData(){
		return "";
	}

}
