/**
 * Copyright since 2020 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 */
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	this.unLoadColdBox = false;

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	function run(){
		describe( "Integrations Specs", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();

				manager = getInstance( "validationManager@cbValidation" );
			} );


			it( "can process rules", function(){
				var results   = getInstance( "cbvalidation.models.result.ValidationResult" );
				var mockRules = {
					required : true,
					sameAs   : "joe",
					udf      : variables._validateit
				};

				prepareMock( this ).$( "getName", "luis" ).$( "getJoe", "luis" );

				manager.processRules(
					results = results,
					rules   = mockRules,
					target  = this,
					field   = "name"
				);

				assertEquals( 0, results.getErrorCount() );
			} );


			it( "can process rules with custom validators from a wirebox mapping", function(){
				var results       = getInstance( "cbvalidation.models.result.ValidationResult" );
				var mockValidator = prepareMock( getInstance( "tests.resources.MockValidator" ) ).$(
					"validate",
					true
				);
				var mockRule = { "tests.resources.MockValidator" : { customField : "hi" } };
				var mock     = createStub().$( "getName", "luis" );

				manager.processRules(
					results = results,
					rules   = mockRule,
					target  = mock,
					field   = "name"
				);
				assertTrue(
					mockValidator.$once( "validate" ),
					"[validate] should have been called on [customValidator]"
				);
			} );

			it( "can validate and ignore keys ending with `Message`", function(){
				var mockRules = {
					required      : true,
					testMessage   : "Hello",
					uniqueMessage : "Not Unique Man",
					udf           : variables._validateit
				};

				var mock    = createStub().$( "getName", "luis" );
				var results = getInstance( "cbvalidation.models.result.ValidationResult" );
				manager.processRules(
					results = results,
					rules   = mockRules,
					target  = mock,
					field   = "name"
				);

				assertEquals( 0, results.getErrorCount() );
			} );

			it( "can get shared constraints", function(){
				expect( manager.getSharedConstraints() ).notToBeEmpty();
			} );

			it( "can validate a generic form", function(){
				var mockData        = { name : "luis", age : "33" };
				var mockConstraints = {
					name : { required : true },
					age  : { required : true, max : "35" }
				};

				var r = manager.validate( target = mockData, constraints = mockConstraints );
				assertEquals( false, r.hasErrors() );

				var mockData = { name : "luis", age : "55" };
				var r        = manager.validate( target = mockData, constraints = mockConstraints );
				assertEquals( true, r.hasErrors() );
				debug( r.getAllErrors() );
			} );

			it( "can validate with specific fields", function(){
				var mockData        = { name : "", age : "" };
				var mockConstraints = {
					name : { required : true },
					age  : { required : true, max : "35" }
				};

				var r = manager.validate(
					target      = mockData,
					fields      = "name",
					constraints = mockConstraints
				);
				assertEquals( true, r.hasErrors() );
				assertEquals( 0, arrayLen( r.getFieldErrors( "age" ) ) );
				assertEquals( 1, arrayLen( r.getFieldErrors( "name" ) ) );
			} );

			it( "can validate with include fields", function(){
				var mockData        = { name : "", age : "" };
				var mockConstraints = {
					name : { required : true },
					age  : { required : true, max : "35" }
				};

				var r = manager.validate(
					target        = { age : 30 },
					constraints   = mockConstraints,
					includeFields = "age"
				);
				assertEquals( false, r.hasErrors() );
			} );

			it( "can validate with excluded fields", function(){
				var mockData        = { name : "", age : "" };
				var mockConstraints = {
					name : { required : true },
					age  : { required : true, max : "35" }
				};

				var r = manager.validate(
					target        = mockData,
					constraints   = mockConstraints,
					excludeFields = "age"
				);
				assertEquals( true, r.hasErrors() );
				assertEquals( 0, arrayLen( r.getFieldErrors( "age" ) ) );
				assertEquals( 1, arrayLen( r.getFieldErrors( "name" ) ) );
			} );

			it( "can expand nested struct and array syntax", function(){
				var mockData = {
					"owner" : {
						"firstName"    : "John",
						"lastName"     : "Doe",
						"luckyNumbers" : [ 7, 11, 21 ],
						"addresses"    : [
							{
								"streetOne" : "123 Elm Street",
								"city"      : "Anytown",
								"state"     : "IL",
								"zip"       : 60606
							}
						]
					}
				};
				var mockConstraints = {
					"owner.firstName"             : { "required" : true, "type" : "string" },
					"owner.lastName"              : { "required" : true, "type" : "string" },
					"owner.luckyNumbers.*"        : { "required" : true, "type" : "numeric" },
					"owner.addresses.*.streetOne" : { "required" : true, "type" : "string" },
					"owner.addresses.*.streetTwo" : { "required" : false, "type" : "string" },
					"owner.addresses.*.city"      : { "required" : true, "type" : "string" },
					"owner.addresses.*.state"     : { "required" : true, "type" : "string", "size" : 2 },
					"owner.addresses.*.zip"       : { "required" : true, "type" : "numeric", "size" : 5 }
				};

				var r = manager.validate( target = mockData, constraints = mockConstraints );
				assertEquals( false, r.hasErrors() );
			} );

			it( "can use validator aliases in constraints", function(){
				var mockData        = { "luckyNumbers" : [ 7, 11, 111 ] };
				var mockConstraints = { "luckyNumbers" : { "items" : { "required" : true, "type" : "numeric" } } };

				var r = manager.validate( target = mockData, constraints = mockConstraints );
				assertEquals( false, r.hasErrors() );
			} );

			it( "can expand nested struct and array syntax and handle failed validation", function(){
				var mockData = {
					"owner" : {
						"firstName" : "John",
						"lastName"  : "Doe",
						"addresses" : [
							{
								"streetOne" : "123 Elm Street",
								"city"      : "Anytown",
								"state"     : "IL",
								"zip"       : 60606
							},
							{
								"streetOne" : "123 Elm Street",
								"city"      : "Anytown",
								"zip"       : 60606
							}
						]
					}
				};
				var mockConstraints = {
					"owner.firstName"             : { "required" : true, "type" : "string" },
					"owner.lastName"              : { "required" : true, "type" : "string" },
					"owner.addresses.*.streetOne" : { "required" : true, "type" : "string" },
					"owner.addresses.*.streetTwo" : { "required" : false, "type" : "string" },
					"owner.addresses.*.city"      : { "required" : true, "type" : "string" },
					"owner.addresses.*.state"     : { "required" : true, "type" : "string", "size" : 2 },
					"owner.addresses.*.zip"       : { "required" : true, "type" : "numeric", "size" : 5 }
				};

				var r = manager.validate( target = mockData, constraints = mockConstraints );
				assertEquals( true, r.hasErrors() );
				var errors = r.getAllErrors( "owner.addresses[2].state" );
				assertEquals( 1, errors.len() );
				assertEquals( "The 'state' value is required", errors[ 1 ] );
			} );
		} );
	}

	private function _validateit( targetValue, target ){
		return true;
	}

}
