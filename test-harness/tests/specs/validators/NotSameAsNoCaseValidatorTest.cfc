/**
 * *******************************************************************************
 * *******************************************************************************
 */
component
	extends="coldbox.system.testing.BaseModelTest"
	model  ="cbvalidation.models.validators.NotSameAsNoCaseValidator"
{

	function setup(){
		super.setup();
		model.init();
	}

	function testValidate(){
		result = createMock( "cbvalidation.models.result.ValidationResult" ).init();

		// luis not the same as data
		r = model.validate(
			validationResult: result,
			target          : this,
			field           : "test",
			targetValue     : "data",
			validationData  : "luis"
		);
		expect( r ).toBeTrue();

		// luis is the same as data
		r = model.validate(
			validationResult: result,
			target          : this,
			field           : "test",
			targetValue     : "luis",
			validationData  : "luis"
		);
		expect( r ).toBeFalse();
	}

	function getLuis(){
		return "luis";
	}

	function getData(){
		return "data";
	}

}
