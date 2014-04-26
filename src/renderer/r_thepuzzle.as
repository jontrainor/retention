package renderer
{
	import game.puzzle.z_tile;

	import starling.display.Sprite;

	/*========================================================================================
	Puzzle world
	========================================================================================*/
	public class r_thepuzzle extends Sprite
	{
		protected var m_tiles:Vector.<z_tile>;
		
		public function r_thepuzzle() {
			m_tiles = new Vector.<z_tile>;	
		}
		
		public function LoadLevel( levelName:String ):void {
			r_loader.instance.GetLevel( levelName, ".oel", CreateGrid );
		}
		
		/** Create grid here based on .oel, grid should create a list of type z_tile */
		public function CreateGrid( level:XML ):void {
			
		}
		
		public function Destroy():void {
			m_tiles.length = 0;
		}
	}
}
