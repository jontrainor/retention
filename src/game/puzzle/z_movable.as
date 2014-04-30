package game.puzzle
{
	import com.globals;
	
	import flash.geom.Point;
	
	import game.g_entity;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	
	public class z_movable extends g_entity
	{
		/** direction should be set as a point */
		public var direction:Point;
		
		public function z_movable(parent:DisplayObjectContainer, asset:String, isSpriteSheet:Boolean=false, defaultFrames:int=120) {
			super(parent, asset, isSpriteSheet, defaultFrames);
		}
		
		/** Set the direction the movable can move on when triggered 
		 * @param xdir - set > 0 to move to the right, set < 0 to move to the left
		 * @param ydir - set > 0 to move down, set < 0 to move up
		 * */
		public function SetMoveDirection( xdir:int=1, ydir:int=0 ):void {
			direction.x = xdir;
			direction.y = ydir;
		}
		
		/** Move the wall according to the set direction and the tile size 
		 * @param distance - distance (units) to move
		 * */
		public function Move( distance:int=1, timeInSeconds:int=3 ):void {
			MoveTo( new Point( direction.x * distance * globals.tilesize, direction.y * distance * globals.tilesize ), timeInSeconds, false );
		}
	}
}