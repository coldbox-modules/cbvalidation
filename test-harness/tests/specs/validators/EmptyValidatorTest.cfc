/**
 * *******************************************************************************
 * *******************************************************************************
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.EmptyValidator" {

	function beforeAll(){
		super.beforeAll();
		super.setup();
		model.init();
	}

	function run(){
		describe( "empty validator", function(){
			beforeEach( function(){
				variables.result = createMock( "cbvalidation.models.result.ValidationResult" ).init();
			} );

			it( "skips over null values", function(){
				expect(
					model.validate(
						variables.result,
						this,
						"test",
						javacast( "null", "" ),
						true
					)
				).toBeTrue();
			} );

			describe( "empty: true", function(){
				it( "passes when given an empty string", function(){
					expect( model.validate( variables.result, this, "test", "", true ) ).toBeTrue();
				} );

				it( "passes when given an empty array", function(){
					expect( model.validate( variables.result, this, "test", [], true ) ).toBeTrue();
				} );

				it( "passes when given an empty struct", function(){
					expect( model.validate( variables.result, this, "test", {}, true ) ).toBeTrue();
				} );

				it( "fails when given a non-empty string", function(){
					expect( model.validate( result, this, "test", "woot", true ) ).toBeFalse();
				} );

				it( "fails when given a number", function(){
					expect( model.validate( result, this, "test", 42.155, true ) ).toBeFalse();
				} );

				it( "fails when given a date", function(){
					expect( model.validate( result, this, "test", now(), true ) ).toBeFalse();
				} );

				it( "fails when given a non-empty array", function(){
					expect( model.validate( variables.result, this, "test", [ 1 ], true ) ).toBeFalse();
				} );

				it( "fails when given a non-empty struct", function(){
					expect(
						model.validate(
							variables.result,
							this,
							"test",
							{ "foo" : "bar" },
							true
						)
					).toBeFalse();
				} );
			} );

			describe( "empty: false", function(){
				it( "fails when given an empty string", function(){
					expect( model.validate( variables.result, this, "test", "", false ) ).toBeFalse();
				} );

				it( "fails when given an empty array", function(){
					expect( model.validate( variables.result, this, "test", [], false ) ).toBeFalse();
				} );

				it( "fails when given an empty struct", function(){
					expect( model.validate( variables.result, this, "test", {}, false ) ).toBeFalse();
				} );

				it( "does not fail when given a non-empty string", () => {
					expect( model.validate( variables.result, this, "test", 10, false ) ).toBeTrue();
				} );
			} );
		} );
	}

}
