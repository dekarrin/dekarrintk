// quick script to set up a listener so the prompt opens/closes when the tilde key is pressed

this.createEmptyMovieClip( "listen", this.getNextHighestDepth() );

listen.onKeyDown = function() {
	if( Key.isDown( 192 ) ) {
		if( console.currentState() == "on" ) {
			console.deactivate();
		} else {
			console.activate();
		}
	}
}
listen.onKeyUp = function() {
}

Key.addListener( this.listen );