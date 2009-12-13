/*
	This class expects to have _root #include the ToolKitLib.
*/
class dekarrintk.console.ToolKitConsoleDisplay extends MovieClip {
	private var scrollHistoryIndex:Number = 0;
	private var scrollHistory:Array = new Array();
	private var scrollBrowseIndex:Number = 1;
	
	public function ToolKitConsoleDisplay() {
		drawSelf();
		buildTextFields();
	}
	
	public function print_r( level:Number ):Void {
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
	
	public function printMessage( messageContent:String ):Void {
		checkHistoryBrowser();
		moveLinesUp();
		this["line9"].text = messageContent;
		if( scrollHistoryIndex < 200 ) {
			scrollHistory[scrollHistoryIndex] = messageContent;
			scrollHistoryIndex++;
		} else {
			cycleOutHistory();
			scrollHistory[199] = messageContent;
		}
	}
	
	public function output( messageContent:String, lineNumber:Number ):Void {
		this["line"+lineNumber].text = messageContent;
	}
	
	public function clearScreen():Void {
		for( var i = 0; i < 10; i++ ) {
			this["line"+i].text = "";
		}
	}
	
	public function clearLine( lineNumber:Number ):Void {
		this["line"+lineNumber].text = "";
	}
	
	public function addString( stringToAdd:String, lineNumber:Number ):Void {
		this["line"+lineNumber].text = this["line"+lineNumber].text + stringToAdd;
	}
	
	public function backspace( lineNumber:Number ):Void {
		this["line"+lineNumber].text = this["line"+lineNumber].substring( 0, this["line"+lineNumber].length-2 );
	}
	
	public function scrollUp():Void {
		if( scrollBrowseIndex < scrollHistory.length-9 ) {
			scrollBrowseIndex++;
			scrollUpdate();
		}
	}
	
	public function scrollDown():Void {
		if( scrollBrowseIndex > 1 ) {
			scrollBrowseIndex--;
			scrollUpdate();
		}
	}
	
	private function checkHistoryBrowser():Void {
		scrollBrowseIndex = 1;
		scrollUpdate();
	}
	
	private function scrollUpdate():Void {
		var n:Number = 9
		for( var i:Number = 0; i < 10; i++ ) {
			if( scrollHistory[scrollHistoryIndex-scrollBrowseIndex-n] == undefined ) {
				this["line"+i].text = "";
			} else {
				this["line"+i].text = scrollHistory[scrollHistoryIndex-scrollBrowseIndex-n];
			}
			n--;
		}
	}
	
	private function moveLinesUp():Void {
		for( var i = 0; i < 9; i++ ) {
			this["line"+i].text = this["line"+(i+1)].text;
		}
	}
	
	private function cycleOutHistory():Void {
		for( var i = 0; i < 200; i++ ) {
			// workaround so it doesn't reference itself:
			var placeHolder = scrollHistory[i];
			if( i != 0 ) {
				scrollHistory[i-1] = placeHolder;
			}
		}
	}
	
	private function drawSelf():Void {
		this._x = 2;
		this._y = 2;
		moveTo( 0, 0 );
		beginFill( 0x0000cc );
		lineStyle( 0, 0x333366 );
		lineTo( this._parent._width-6, 0 );
		lineStyle( 0, 0x0033ff );
		lineTo( this._parent._width-6, this._parent._height-26.1 );
		lineTo( 0, this._parent._height-26.1 );
		lineStyle( 0, 0x333366 );
		lineTo( 0, 0 );
		endFill();
	}
	
	private function buildTextFields():Void {
		createTextFields();
		applyFormatting();
	}
	
	private function createTextFields():Void {
		var n = 2;
		for( var i = 0; i < 10; i++) {
			this.createTextField( "line"+i, this.getNextHighestDepth(), 2, n, this._parent._width-6, 14.1 );
			n += 12;
		}
	}
	
	private function applyFormatting():Void {
		// set up TextFormat object
		var format:TextFormat = new TextFormat();
		format.font = "Lucida Console";
		format.size = 10;
		format.color = 0xcccccc;
		
		// now apply it to the TextField(s)
		for( var i = 0; i < 10; i++) {
			this["line"+i].setNewTextFormat( format );
		}
	}
}