package game
{
	import starling.display.DisplayObjectContainer;
	
	public class g_entity extends a_entity
	{
		public function g_entity(
			parent				:DisplayObjectContainer,
			asset				:String, 
			isSpriteSheet		:Boolean = false, 
			defaultFrames		:int = 120 ) {
			//
			super(parent, asset, isSpriteSheet, defaultFrames);
			SetDefaults();
		}
		
		protected function SetDefaults():void {
			addChild( m_asset );
		}
		
		override public function Update():void {}
		
		override public function Draw():void { m_parent.addChild( this ); }
		override public function Destroy():void { m_parent.removeChild( this ); }
		
		public function get asset():* { return m_asset; }
	}
}