package game.puzzle
{
	import com.globals;
	
	import starling.display.DisplayObjectContainer;
	
	public class z_node extends z_tile
	{
		private var m_isActive:Boolean;
		
		public function z_node(parent:DisplayObjectContainer, asset:String, isSpriteSheet:Boolean=false, defaultFrames:int=120) {
			super(parent, asset, isSpriteSheet, defaultFrames);
		}
		
		public function CheckCollision():void {
			if ( this.bounds.intersects( globals.player.bounds ) ) {
				SetActive();
			}
			//stop listening, deactivate from quad tree
		}
		
		private function SetActive():void {
			if ( m_isActive ) { return; }
			m_isActive = true;
		}
	}
}