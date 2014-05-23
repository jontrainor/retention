package game
{
	public interface g_istatemachine
	{
		/** start the machine */
		function Init():void;
		
		/** state handler should be deciding what to do with some input */
		function StateHandler( input:* ):void;
		
		/** all update handlers should be receiving the elapsed game time since the last update */
		function UpdateHandler( elapsedTime:Number ):void;
	}
}