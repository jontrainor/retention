package game
{
	import com.globals;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	public class g_player extends g_drawable
	{
		/** Velocity is used in conjunction with elapsed time to stabilize variability in frame rates 
		 *  i.e. - Update() will calculate velocity = speed * elapsedTime since last frame udpate */
		protected const SPEED:Number = 300;
		
		public function g_player(
			parent				:DisplayObjectContainer, 
			asset				:String, 
			isSpriteSheet		:Boolean = false, 
			defaultFrames		:int = 120 ) {
			//
			super(parent, asset, isSpriteSheet, defaultFrames);
		}
		
		override protected function SetDefaults():void {
			super.SetDefaults();
			AbsoluteCenter();
			
			g_dispatcher.instance.AddToDispatchTouch( TouchPhase.BEGAN, OnTouch );
		}
		
		private function OnTouch( touch:Touch ):void {
			//moveTo( new Point( touch.globalX, touch.globalY ) );
		}
		
		override public function Update( elapsedTime:Number ):void {
			
		}
	}
}