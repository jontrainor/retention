package game.puzzle
{
	import flash.geom.Point;
	
	import game.g_entity;
	
	import starling.display.DisplayObjectContainer;
	
	public class z_movable extends g_entity
	{
		/** direction should be set as a point */
		public var direction:Point;
		
		public function z_movable(parent:DisplayObjectContainer, asset:String, isSpriteSheet:Boolean=false, defaultFrames:int=120) {
			super(parent, asset, isSpriteSheet, defaultFrames);
		}
	}
}