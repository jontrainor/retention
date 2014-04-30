package game.puzzle
{
	import flash.geom.Point;
	
	import game.g_entity;
	
	import starling.display.DisplayObjectContainer;
	
	/*========================================================================================
	Basic tile class, should contain a texture and any other relevant tile data
	========================================================================================*/
	public class z_tile extends g_entity
	{
		protected var m_gridPosition:Point;
		
		public function z_tile(parent:DisplayObjectContainer, asset:String, isSpriteSheet:Boolean=false, defaultFrames:int=120) {
			super(parent, asset, isSpriteSheet, defaultFrames);
		}
		
		public function SetGridPosition( row:int, column:int ):void {
			m_gridPosition = new Point(column,row);
		}
	}
}