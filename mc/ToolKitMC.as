class dekarrintk.mc.ToolKitMC extends MovieClip {
	
	private var designation:String;
	
	public function ToolKitMC() {
		this.designation = this._name;
	}
	
	public function print_r( level:Number ) {
		if( level == undefined ) {
			level = 0;
		}
		
		// create string based on level
		var outputString:String = "\t";
		for( var i = 0; i < level; i++ ) {
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
	
	private function report( stringOut:String ) {
		if ( _root._debugFlags == 1 ) {
			_root.console.report( designation, stringOut );
		}
	}
}