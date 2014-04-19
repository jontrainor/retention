package game.puzzle
{
	import flash.geom.Point;
	
	import game.g_dispatcher;
	import game.g_player;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	public class z_puzzlePlayer extends g_player
	{
		public function z_puzzlePlayer(parent:DisplayObjectContainer, asset:String, isSpriteSheet:Boolean=false, defaultFrames:int=120)
		{
			super(parent, asset, isSpriteSheet, defaultFrames);
		}
		
		override protected function SetDefaults():void {
			super.SetDefaults();
			g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.BEGAN );
			g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.MOVED );
		}
		
		override protected function OnTouch( touch:Touch ):void {
			var gridPos:Point = GetGridLocation( touch.globalX, touch.globalY );
			if ( gridPos ) { MoveTo( gridPos ); }
		}
		
		override public function Update():void {
			
		}
		
		/** Get the grid location where the touch occured and move the player in that direction */
		private function GetGridLocation( touchX:Number, touchY:Number ):Point {
			//implementation needed
			return null;
		}
	}
}