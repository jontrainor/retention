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
		
		public var parallaxSpeed:Number;
		
		/** Quadbatch can be massive as long as it contains one image */
		private var m_quadBatch:QuadBatch;
		
		public function r_layer( texture:Texture, parallaxSpeed:Number, parent:DisplayObjectContainer ) {
			m_quadBatch 		= new QuadBatch();
			m_texture 			= texture;
			m_quadBatch.visible = false;
			this.parallaxSpeed 	= parallaxSpeed;
			
			m_quadBatch.addImage( new Image( texture ) );
			
			addChild( m_quadBatch );
			parent.addChild( this );
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
		
		override public function set x(value:Number):void {
			super.x = value * parallaxSpeed;
		}
		
		override public function set y(value:Number):void {
			super.y = value * parallaxSpeed;
		}
	}
}