package game
{
	import starling.display.DisplayObjectContainer;
	
	public class g_drawable extends ga_drawable
	{
		public function g_drawable(
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
		
		override public function Update( elapsedTime:Number ):void {}
		
		override public function Draw():void { m_parent.addChild( this ); }
		override public function Destroy():void { m_parent.removeChild( this ); }
		
		public function get asset():* { return m_asset; }
	}
}