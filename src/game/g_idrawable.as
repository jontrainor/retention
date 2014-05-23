package game
{
	public interface g_idrawable {
		
		function Init():void;
		
		/** Update to call on frame, all drawables should have the current time since last update */
		function Update( elapsedTime:Number=NaN ):void;
		
		/** Add asset to instance */
		function Draw():void;
		
		/** Remove instance from parent */
		function Destroy():void;
		
	}
}