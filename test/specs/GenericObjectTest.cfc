/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component extends="coldbox.system.testing.BaseModelTest" model="cbvalidation.model.GenericObject"{

	function setup(){
		super.setup();
		model.init( {name="luis", age="33"} );
	}

	function testGet(){
		assertEquals("luis", model.getName() );
		assertEquals("33", model.getAge() );
	}

	function testBad(){
		expect( function(){ model.getThere(); } ).toThrow();
	}

}