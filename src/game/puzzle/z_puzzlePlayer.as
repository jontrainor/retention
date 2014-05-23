package game.puzzle
{
	import flash.geom.Point;
	
	import game.g_dispatcher;
	import game.g_player;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	public class z_puzzleplayer extends g_player
	{
		protected var m_grid:Array;
		
		public var currentWalls:Array;
		public var currentMovables:Array;		
		public var gridPosition:Point;
		
		private const SPEED:int = 200;
		
		public function z_puzzleplayer(parent:DisplayObjectContainer, asset:String, isSpriteSheet:Boolean=false, defaultFrames:int=120){
			super(parent, asset, isSpriteSheet, defaultFrames);
			gridPosition = new Point( 0, 0 );
		}
		
		override protected function SetDefaults():void {
			super.SetDefaults();
			g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.BEGAN );
			g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.MOVED );
		}
		
		override protected function OnTouch( touch:Touch ):void {
			var gridPos:Point = GetGridLocation( touch.globalX, touch.globalY );
			if ( gridPos ) { 
				x = gridPos.x;
				y = gridPos.y;
			}
		}
		
		override public function Update():void {
			
		}
		
		override public function set x(value:Number):void {
			super.x = value;
			gridPosition.x = 0;
		}
		
		override public function set y(value:Number):void {
			super.y = value;
		}
		
		public function set grid( values:Array ):void { m_grid = values; }
		
		/** Get the grid location where the touch occured and move the player in that direction */
		private function GetGridLocation( touchX:Number, touchY:Number ):Point {
			//implementation needed
			var pos:Point = new Point(touchX, touchY);
			var currentDistance:Number = int.MAX_VALUE;
			
			var i:int;
			var dist:Number = 0;
			for ( ; i < m_grid[0].length; ++i ) {
				dist = Math.abs( i*64 - touchX+m_asset.width/2 );
				if ( dist < currentDistance ) { currentDistance = dist; pos.x = i*64; }
			}
			currentDistance = int.MAX_VALUE;
			for ( i=0; i < m_grid.length; ++i ) {
				dist = Math.abs( i*64 - touchY+m_asset.height/2 );
				if ( dist < currentDistance ) { currentDistance = dist; pos.y = i*64; }
			}
			return m_grid[ pos.y / 64 ][ pos.x / 64 ] && m_grid[ pos.y / 64 ][ pos.x / 64 ] > 0 ? null : pos;
		}
	}
}