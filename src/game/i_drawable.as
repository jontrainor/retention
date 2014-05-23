package game
{
	public interface i_drawable {
		
		/** Update to call on frame */
		function Update():void;
		
		/** Add asset to instance */
		function Draw():void;
		
		/** Remove instance from parent */
		function Destroy():void;
		
	}
}