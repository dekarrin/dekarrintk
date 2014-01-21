/*
	@class ToolKitConsole
	@author Dekarrin Larimal
	@version 1.0
	@date 2009
	This class extends the MovieClip functionality into a console program.
	You will need to write a custom definition for all of your commands.
*/
class dekarrintk.console.ToolKitConsole extends MovieClip {
	private var activeCommand:String = "";
	private var activeOutput:String = "";
	private var commandWords:Array = new Array();
	private var commandHistory:Array = new Array();
	private var historyNumber:Number = 0;
	private var historyBrowseIndex:Number = 0;
	private var activating:Boolean = false;
	private var deactivating:Boolean = false;
	
	public function ToolKitConsole() {
		drawSelf();
		buildChildren();
		initializePosition();
	}
	
	public function onEnterFrame():Void {
		if( activating ) {
			moveActive();
		}
		if( deactivating ) {
			moveDeactive();
		}
	}
	
	public function activate():Void {
		if( !this.deactivating ) {
			this._visible = true;
			clearEntry();
			this.activating = true;
		}
	}
	
	public function deactivate():Void {
		if( !this.activating ) {
			this.deactivating = true;
			Selection.setFocus( null );
		}
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
		// pass the parameters directly into the display module
		this["consoleDisplay"].printMessage( messageContent );
	}
	
	public function output( messageContent:String, lineNumber:Number ):Void {
		// pass the parameters directly into the display module
		this["consoleDisplay"].output( messageContent, lineNumber );
	}
	
	public function clearScreen():Void {
		// pass to display module
		this["consoleDisplay"].clearScreen();
	}
	
	public function clearLine( lineNumber:Number ):Void {
		// pass to display module
		this["consoleDisplay"].clearLine( lineNumber );
	}
	
	public function addString( stringToAdd:String, lineNumber:Number ):Void {
		// pass to display module
		this["consoleDisplay"].addString( stringToAdd, lineNumber );
	}
	
	public function backspace( lineNumber:Number ):Void {
		// pass to display module
		this["consoleDisplay"].backspace( lineNumber );
	}
	
	public function process( commandIn:String ):Void {
		activeCommand = commandIn;
		arrayCommand();
		addToHistory();
		parseCommand();
		purgeVariables();
	}
	
	public function historyUp():Void {
		if( commandHistory.length > 0 ) {
			this["consoleEntry"].setText( prevHistItem() );
		}
	}
	
	public function historyDown():Void {
		if( commandHistory.length > 0 ) {
			this["consoleEntry"].setText( nextHistItem() );
		}
	}
	
	public function currentState():String {
		if( this._y == 0 ) {
			return "on";
		} else {
			return "off";
		}
	}
	
	public function scrollUp():Void {
		this["consoleDisplay"].scrollUp();
	}
	
	public function scrollDown():Void {
		this["consoleDisplay"].scrollDown();
	}
	
	private function initializePosition():Void {
		this._y = this._height*-1;
		this._alpha = 0;
		this._visible = false;
		Selection.setFocus( null );
	}
	
	private function moveActive():Void {
		if( this._y < 0 ) {
			if( this._y + 10 > 0 ) {
				this._y = 0;
			} else {
				this._y += 10;
			}
			this._alpha = calculateAlpha();
		} else {
			this.activating = false;
		}
	}
	
	private function moveDeactive():Void {
		if( this._y > this._height*-1 ) {
			if( this._y - 10 < this._height*-1 ) {
				this._y = this._height*-1;
			} else {
				this._y -= 10;
			}
			this._alpha = calculateAlpha();
		} else {
			this.deactivating = false;
			this._visible = false;
		}
	}
	
	private function calculateAlpha():Number {
		var workingValue:Number;
		workingValue = (this._y/(this._height*-1))*100;
		workingValue = 50-(workingValue-50);
		workingValue *= .5;
		return workingValue;
	}
	
	private function buildChildren():Void {
		this.attachMovie( "emptyConsoleEntry", "consoleEntry", this.getNextHighestDepth() );
		this.attachMovie( "emptyConsoleDisplay", "consoleDisplay", this.getNextHighestDepth() );
	}
	
	private function drawSelf():Void {
		moveTo( 0, 0 );
		beginFill( 0x3366ff );
		lineStyle();
		lineTo( Stage.width, 0 );
		lineTo( Stage.width, 150 );
		lineTo( 0, 150 );
		lineTo( 0, 0 );
		endFill();
	}

	private function arrayCommand():Void {
		var i = 0;
		while( hasSpaces() ) {
			indexWord(i);
			deleteFirstWord();
			i++;
		}
		indexFinalWord(i);
	}
	
	private function displayOutput():Void {
		printMessage( activeOutput );
	}
	
	private function indexWord( indexNumber:Number ):Void {
		commandWords[indexNumber] = activeCommand.substring( 0, activeCommand.indexOf( " ", 0 ) );
	}
	
	private function deleteFirstWord():Void {
		activeCommand = activeCommand.substr( activeCommand.indexOf( " ", 0 )+1 );
	}
	
	private function indexFinalWord( indexNumber:Number ):Void {
		commandWords[indexNumber] = activeCommand;
	}
	
	private function hasSpaces():Boolean {
		if( activeCommand.indexOf( " ", 0 ) > -1 ) {
			return true;
		} else {
			return false;
		}
	}
	
	private function purgeVariables():Void {
		activeCommand = "";
		activeOutput = "";
		commandWords = [];
		historyBrowseIndex = historyNumber;
	}
	
	private function addToHistory():Void {
		if( historyNumber < 50 ) {
			commandHistory[historyNumber] = reconstructedCommand();
			historyNumber++;
		} else {
			cycleOutHistory();
			commandHistory[49] = reconstructedCommand();
		}
	}
	
	private function prevHistItem():String {
		if( historyBrowseIndex > 0 ) {
			historyBrowseIndex--;
		}
		return commandHistory[historyBrowseIndex];
	}
	
	private function nextHistItem():String {
		if( historyBrowseIndex <= commandHistory.length-1 ) {
			historyBrowseIndex++;
		}
		if( historyBrowseIndex == commandHistory.length ) {
			return "";
		}
		if( historyBrowseIndex > commandHistory.length-1 ) {
			historyBrowseIndex = commandHistory.length-1;
		}
		return commandHistory[historyBrowseIndex];
	}
	
	private function reconstructedCommand():String {
		var placeHolder:String = "";
		for( var i = 0; i < commandWords.length; i++ ) {
			placeHolder += commandWords[i];
			placeHolder += " ";
		}
		placeHolder = placeHolder.substr( 0, placeHolder.length-1 );
		return placeHolder;
	}
	
	private function cycleOutHistory():Void {
		for( var i = 0; i < 50; i++ ) {
			// workaround so it doesn't reference itself:
			var placeHolder = commandHistory[i];
			if( i != 0 ) {
				commandHistory[i-1] = placeHolder;
			}
		}
	}
	
	private function clearEntry():Void {
		// pass to input module
		this["consoleEntry"].clearEntry();
	}

	
	
	
	/*
		This section is the command definitions
	*/
	private function parseCommand():Void {
		// this is the primary parser for the program
		switch( commandWords[0] ) {
			case "echo" :
				CMDEcho();
				break;
			case "clear" :
				CMDClear();
				break;
			default :
				if( !customCommands() ) {
					CMDUnknown();
				}
				break;
		}
	}
	
	// Define new commands here
	private function customCommands():Boolean {
		return false;
	}
	
	private function CMDUnknown():Void {
		activeOutput = "Unrecognized command '"+commandWords[0]+"'";
		displayOutput();
	}
	
	private function CMDEcho():Void {
		commandWords.shift();
		for( var i = 0; i < commandWords.length-1; i++ ) {
			activeOutput += commandWords[i]+" ";
		}
		if( commandWords[0] != undefined ) {
			activeOutput += commandWords[commandWords.length-1];
		} else {
			activeOutput = "";
		}
		displayOutput();
	}
	
	private function CMDClear():Void {
		clearScreen();
	}
	
	private function CMDReport( designator:String, messageContent:String ):Void {
		activeOutput = String = designator + ": " + messageContent;
		displayOutput();
	}

}