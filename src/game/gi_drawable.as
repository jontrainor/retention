package game
{
	public interface gi_drawable {
		/** Update to call on frame */
		function Update( elapsedTime:Number ):void;
		
		/** Add asset to instance */
		function Draw():void;
		
		/** Remove instance from parent */
		function Destroy():void;
	}
}