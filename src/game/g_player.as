package game
{
	import com.globals;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	public class g_player extends g_drawable
	{	
		public function g_player(
			parent				:DisplayObjectContainer, 
			asset				:String, 
			isSpriteSheet		:Boolean = false, 
			defaultFrames		:int = 120 ) {
			//
			m_speed = 0;
			super(parent, asset, isSpriteSheet, defaultFrames);
		}
		
		override protected function SetDefaults():void {
			super.SetDefaults();
			AbsoluteCenter();
			
			g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.BEGAN );
			g_dispatcher.instance.AddToDispatch( Update );
		}
		
		private function OnTouch( touch:Touch ):void {
			//MoveTo( new Point( touch.globalX, touch.globalY ) );
			var gtl:Point = m_parent.globalToLocal( new Point( touch.globalX, touch.globalY ) );
			Impulse( Math.atan2( gtl.y - y, gtl.x - x ), 200, true, 1.57 );
		}
		
		override public function Update():void {
			m_speed = m_speed > 0 ? m_speed - m_damping : m_speed;
			x += m_velocity.x * m_speed * elapsedTime;
			y += m_velocity.y * m_speed * elapsedTime;
		}
	}
}