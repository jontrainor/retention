package game
{
	import com.assets;
	import com.globals;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	/*========================================================================================
	Abstract Super
	========================================================================================*/
	public class ga_drawable extends Sprite implements gi_drawable
	{
		protected var m_asset:Image;
		protected var m_assetHalfWidth:Number;
		protected var m_assetHalfHeight:Number;
		protected var m_parent:DisplayObjectContainer;
		
		protected var m_velocity:Point;
		
		/** All drawables should have a parent and asset to load, if it's a sprite sheet set how many frames for the animations */
		public function ga_drawable(
			parent				:DisplayObjectContainer, 					
			asset				:String, 							
			isSpriteSheet		:Boolean = false, 					
			defaultFrames		:int = 120 ) {
			//
			m_parent = parent;
			m_asset = !isSpriteSheet ? new Image( assets.getTexture( asset ) ) : new MovieClip( assets.getSS( asset ).getTextures(asset), defaultFrames );
			
			m_assetHalfWidth = m_asset.width * 0.5;
			m_assetHalfHeight = m_asset.height * 0.5;
		}
		
		protected function CenterOrigin():void {
			m_asset.pivotX = m_asset.width * 0.5;
			m_asset.pivotY = m_asset.height * 0.5;
		}
		
		/** Centers on the parent */
		protected function Center():void {
			x = m_parent.width * 0.5 - (width * 0.5 - m_asset.pivotX);
			y = m_parent.height * 0.5 - (height * 0.5 - m_asset.pivotY);
		}
		
		/** Centers on the stage */
		protected function AbsoluteCenter():void {
			x = globals.stageHalfWidth - (width * 0.5 - m_asset.pivotX);
			y = globals.stageHalfHeight - (height * 0.5 - m_asset.pivotY);
		}
		
		/** Basic programmatic translation using tween */
		public function moveTo( location:Point, timeInSeconds:int=1, center:Boolean=true ):void {
			location.x -= center ? m_assetHalfWidth : 0;
			location.y -= center ? m_assetHalfHeight : 0;
			
			var tween:Tween = new Tween( this, timeInSeconds );
			tween.animate( "x", location.x );
			tween.animate( "y", location.y );
			Starling.juggler.add( tween );
		}
		
		/** Update function - translations based on time, (i.e. - drawable.x += velocity.x * elapsedTime) */
		public function Update( elapsedTime:Number ):void { AbstractError(); }
		
		/** Remove from parent, nullify, garbage collection prep */
		public function Destroy():void { AbstractError(); }
		
		/** Draw function, add asset to class, class instance is added to parent */
		public function Draw():void {AbstractError();  }
		
		private function AbstractError():void {
			var stack:Error = new Error();
			var log:String = stack.getStackTrace();
			var f:String = log.replace( /.*\/([a-zA-Z0-9_]+)\(\).*/, "$1()" );
			throw new IllegalOperationError( f + " must be overriden in subclass" );
		}
	}
}