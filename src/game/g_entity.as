package game
{
	import starling.display.DisplayObjectContainer;
	
	/*========================================================================================
	Entity Implementation from abstract entity
	========================================================================================*/
	public class g_entity extends g_abstractentity
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
			//SetAABB();
			Init();
		}
		
		protected function SetAABB():void {
			
		}
		
		//template overrides, which will probably be used eventually
		override public function Init():void {}
		override public function Update( elapsedTime:Number=NaN ):void {}
		override public function Draw():void { m_parent.addChild( this ); }
		override public function Destroy():void { m_parent.removeChild( this ); }
		
		public function get asset():* { return m_asset; }
	}
}