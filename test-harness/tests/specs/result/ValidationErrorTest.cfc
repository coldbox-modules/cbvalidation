/**
 * *******************************************************************************
 * *******************************************************************************
 */
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.models.result.ValidationError" {

	function setup(){
		super.setup();
		model.init();
	}

	function testObject(){
		assertEquals( "", model.getMessage() );
		assertEquals( "", model.getField() );
		assertEquals( "", model.getRejectedValue() );
		assertEquals( "", model.getValidationType() );
		assertEquals( "", model.getValidationData() );

		model.configure( "hello", "name", "oops", "Discrete", "eq:4" );
		assertEquals( "hello", model.getMessage() );
		assertEquals( "name", model.getField() );
		assertEquals( "oops", model.getRejectedValue() );
		assertEquals( "Discrete", model.getValidationType() );
		assertEquals( "eq:4", model.getValidationData() );

		assertEquals( "hello", model.getMemento().message );
		assertEquals( "name", model.getMemento().field );
		assertEquals( "oops", model.getMemento().rejectedValue );
		assertEquals( "Discrete", model.getMemento().validationType );
	}

}
