package game
{
	import com.globals;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	/*========================================================================================
	g_player is the super for g_bodyPlayer and g_puzzlePlayer
	========================================================================================*/
	public class g_player extends g_entity
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
			g_dispatcher.instance.AddToDispatch( Update );
			globals.player = this;
		}
		
		/** Touch event, applied with relative touch phases
		 * e.g. - g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.BEGAN ); 
		 * */
		protected function OnTouch( touch:Touch ):void {}
	}
}