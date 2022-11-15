component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.validators.BeforeValidator" {

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
		describe( "Before Date Validator", function(){
			beforeEach( function( currentSpec ){
				result = createMock( "cbvalidation.models.result.ValidationResult" ).init();
			} );

			it( "can invalidate if the target value is not a date", function(){
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : "I am not a date",
						validationData  : now(),
						rules           : {}
					)
				).toBeFalse();
			} );

			it( "can validate true if the field under validation is before the target", function(){
				// testField = { afterDate = "value" }
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : dateAdd( "d", -5, now() ),
						validationData  : now(),
						rules           : {}
					)
				).toBeTrue();
			} );

			it( "can validate false if the field under validation is after the target", function(){
				// testField = { afterDate = "value" }
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : dateAdd( "d", 5, now() ),
						validationData  : now(),
						rules           : {}
					)
				).toBeFalse();
			} );

			it( "can validate false if the field under validation is the same as the target", function(){
				// testField = { afterDate = "value" }
				var now = now();
				expect(
					model.validate(
						validationResult: result,
						target          : this,
						field           : "testField",
						targetValue     : now,
						validationData  : now,
						rules           : {}
					)
				).toBeFalse();
			} );
		} );
	}

}
