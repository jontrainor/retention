package game
{
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	public class g_bodyPlayer extends g_player
	{
		public function g_bodyPlayer(parent:DisplayObjectContainer, asset:String, isSpriteSheet:Boolean=false, defaultFrames:int=120)
		{
			super(parent, asset, isSpriteSheet, defaultFrames);
		}
		
		override protected function SetDefaults():void {
			super.SetDefaults();
			AbsoluteCenter();
			g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.BEGAN );
		}
		
		override protected function OnTouch( touch:Touch ):void {
			//MoveTo( new Point( touch.globalX, touch.globalY ) );
			var gtl:Point = m_parent.globalToLocal( new Point( touch.globalX, touch.globalY ) );
			Impulse( Math.atan2( gtl.y - y, gtl.x - x ), 200, true, 1.57 );
		}
		
		override public function Update():void {
			Move();
		}
	}
}