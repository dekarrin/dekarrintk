// script to set up standard functions

// test to see if it loaded; disabled by default
//trace( "Library loaded: std_library" );

function print_r( level:Number ) {
	if( level == undefined ) {
		level = 0;
	}
	
	// create string based on level
	var outputString:String = "\t";
	for( var i = 0; i<level; i++ ) {
		outputString += "\t";
	}
	outputString = outputString.substr( 0, outputString.length-2 );
	outputString += "|__";
	
	for( var each in this ) {
		outputString += each;
		trace( outputString );
		outputString = outputString.substr( 0, outputString.length-(each.length) );
		this[each].print_r( level+1 );
	}
}