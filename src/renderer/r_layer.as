package renderer
{	
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class r_layer extends Sprite
	{
		private var m_texture:Texture;
		
		static public var sm_speed:Number;
		
		/** Quadbatch can be massive as long as it contains one image */
		private var m_quadBatch:QuadBatch;
		
		public function r_layer( texture:Texture, parallaxSpeed:Number, parent:DisplayObjectContainer ) {
			m_quadBatch = new QuadBatch();
			m_quadBatch.addImage( new Image( texture ) );
			m_texture = texture;
			m_quadBatch.visible = false;
			parent.addChild( m_quadBatch );
		}
		
		/** Remove and dispose QuadBatch and Texture */
		public function Destroy():void {
			m_quadBatch.parent.removeChild( m_quadBatch );
			m_texture = null;
			m_quadBatch.dispose();
			m_quadBatch = null;
		}
		
		/** Show the quadbatch */
		public function Draw():void {
			m_quadBatch.visible = true;
		}
		
		/** All layers move in accordance to the player velocity */
		public function Move( velocity:Point ):void {
			//sm_speed = ;
			m_quadBatch.x += velocity.x;
			m_quadBatch.y += velocity.y;
		}
	}
}