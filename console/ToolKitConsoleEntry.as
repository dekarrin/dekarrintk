/*
	This class expects to have _root #include the ToolKitLib.
*/

class dekarrintk.console.ToolKitConsoleEntry extends MovieClip {
	public function ToolKitConsoleEntry() {
		drawSelf();
		makeEntry();
		setupKeyListenerEvents();
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
	
	public function startWait():Void {
		Key.addListener( this );
	}
	
	public function stopWait():Void {
		Key.removeListener( this );
	}
	
	public function clearEntry():Void {
		this["entry"].text = "";
	}
	
	public function setText( newText:String ):Void {
		this["entry"].text = newText;
	}
	
	private function drawSelf():Void {
		this._y = this._parent._height - 22.1;
		this._x = 2;
		moveTo( 0, 0 );
		beginFill( 0x0000cc );
		lineStyle( 0, 0x333366 );
		lineTo( this._parent._width-6, 0 );
		lineStyle( 0, 0x0033ff );
		lineTo( this._parent._width-6, 18.1 );
		lineTo( 0, 18.1 );
		lineStyle( 0, 0x333366 );
		lineTo( 0, 0 );
		endFill();
	}
	
	private function setupKeyListenerEvents():Void {
		this.onKeyDown = function() {
			if( Key.isDown( Key.ENTER ) ) {
				enterCommand();
			}
			if( Key.isDown( Key.DOWN ) ) {
				if( Key.isToggled( Key.CAPSLOCK ) ) {
					scrollDown();
				} else {
					historyDown();
				}
			}
			if( Key.isDown( Key.UP ) ) {
				if( Key.isToggled( Key.CAPSLOCK ) ) {
					scrollUp();
				} else {
					historyUp();
				}
			}
		}
		this.onKeyUp = function() {
			
		}
	}
	
	private function makeEntry():Void {
		createTextField( "entry", getNextHighestDepth(), 2, 2, _width-4, _height-4);
		setEntryProperties();
		setEntryEventHandlers();
	}
	
	private function setEntryProperties():Void {
		this["entry"].type = "input";
		applyFormatting();
	}
	
	private function setEntryEventHandlers():Void {
		this["entry"].onSetFocus = function() {
			_parent.startWait();
		}
		this["entry"].onKillFocus = function() {
			_parent.stopWait();
		}
	}
	
	private function applyFormatting( lineNumber:Number ):Void {
		// set up TextFormat object
		var format:TextFormat = new TextFormat();
		format.font = "Lucida Console";
		format.size = 10;
		format.color = 0xffffff;
		
		// now apply it to the TextField
		this["entry"].setNewTextFormat( format );
	}
	
	private function enterCommand():Void {
		this._parent.process( this["entry"].text );
		this["entry"].text = "";
	}
	
	private function historyUp():Void {
		// pass to console
		this._parent.historyUp();
	}
	
	private function historyDown():Void {
		// pass to console
		this._parent.historyDown();
	}
	
	private function scrollUp():Void {
		// pass to console
		this._parent.scrollUp();
	}
	
	private function scrollDown():Void {
		// pass to console
		this._parent.scrollDown();
	}
}