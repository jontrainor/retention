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
		
		public function r_layer( parallaxSpeed:Number, parent:DisplayObjectContainer ) {
			visible = false;
			this.parallaxSpeed 	= parallaxSpeed;
			parent.addChild( this );
		}
		
		/** Remove and dispose QuadBatch and Texture */
		public function Destroy():void {
			this.dispose();
		}
		
		/** Show the quadbatch */
		public function Draw():void {
			visible = true;
		}
		
		override public function set x(value:Number):void {
			super.x = value * parallaxSpeed;
		}
		
		override public function set y(value:Number):void {
			super.y = value * parallaxSpeed;
		}
	}
}