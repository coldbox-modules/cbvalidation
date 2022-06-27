/**
 * *******************************************************************************
 * *******************************************************************************
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.GenericObject" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
		super.setup();
		model.init( { name : "luis", age : "33" } );
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "Generic Object", function(){
			it( "can do getters", function(){
				expect( model.getName() ).toBe( "luis" );
				expect( model.getAge() ).toBe( "33" );
			} );

			it(
				title = "can do null getters",
				body  = function(){
					expect( model.getInvalid() ).toBeNull();
				}
			);
		} );
	}

}
