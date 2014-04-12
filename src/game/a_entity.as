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
	Entity Abstract Super
	========================================================================================*/
	public class a_entity extends Sprite implements i_drawable
	{
		protected var m_asset:Image;
		protected var m_assetHalfWidth:Number;
		protected var m_assetHalfHeight:Number;
		protected var m_parent:DisplayObjectContainer;
		
		protected var m_velocity:Point;
		
		/** Speed is used in conjunction with velocity and elapsed time to stabilize variability in frame rates 
		 *  i.e. - Update() will calculate velocity = speed * elapsedTime since last frame udpate */
		protected var m_speed:Number = 300;
		
		/** Damping will act as resistance */
		protected var m_damping:Number;
		
		/** All drawables should have a parent and asset to load, if it's a sprite sheet set how many frames for the animations */
		public function a_entity(
			parent				:DisplayObjectContainer, 					
			asset				:String, 							
			isSpriteSheet		:Boolean = false, 					
			defaultFrames		:int = 120 ) {
			//
			m_parent = parent;
			m_asset = !isSpriteSheet ? new Image( assets.getTexture( asset ) ) : new MovieClip( assets.getSS( asset ).getTextures(asset), defaultFrames );
			
			m_assetHalfWidth = m_asset.width * 0.5;
			m_assetHalfHeight = m_asset.height * 0.5;
			
			m_velocity	= new Point( 0, 0 );
			m_damping	= 1;
			m_speed		= 0;
		}
		
		/** Set the origin point to the center instead of top left */
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
		public function MoveTo( location:Point, timeInSeconds:int=1, center:Boolean=true ):void {
			location.x -= center ? m_assetHalfWidth : 0;
			location.y -= center ? m_assetHalfHeight : 0;
			
			var tween:Tween = new Tween( this, timeInSeconds );
			tween.animate( "x", location.x );
			tween.animate( "y", location.y );
			Starling.juggler.add( tween );
		}
		
		/** Translate, usuallyed call in Update() */
		protected function Move():void {
			m_speed = m_speed > 0 ? m_speed - m_damping : m_speed;
			x += m_velocity.x * m_speed * elapsedTime;
			y += m_velocity.y * m_speed * elapsedTime;
		}
		
		/** Impulse in a direction
		 * @param angle - angle in radians
		 * @param rotate - set to false if you do not want the rotation property manipulated
		 * @param rotationOffset - add rotation to the current angle (used with rotate property) in radians
		 */
		public function Impulse( angle:Number, speed:int, rotate:Boolean=true, rotationOffset:Number = 0 ):void {
			m_speed = speed;
			m_velocity.x = Math.cos( angle );
			m_velocity.y = Math.sin( angle );
			if ( rotate ) {
				var tween:Tween = new Tween( this, 0.5 );
				tween.animate( "rotation", angle + rotationOffset );
				Starling.juggler.add( tween );
			}
		}
		
		/** Update function - translations based on time, (i.e. - drawable.x += velocity.x * elapsedTime) */
		public function Update():void { AbstractError(); }
		
		/** Remove from parent, nullify, garbage collection prep */
		public function Destroy():void { AbstractError(); }
		
		/** Draw function, add asset to class, class instance is added to parent */
		public function Draw():void {AbstractError();  }
		
		protected function get elapsedTime():Number {
			return g_state.instance.elapsedTime;
		}
		
		private function AbstractError():void {
			var stack:Error = new Error();
			var log:String = stack.getStackTrace();
			var f:String = log.replace( /.*\/([a-zA-Z0-9_]+)\(\).*/, "$1()" );
			throw new IllegalOperationError( f + " must be overriden in subclass" );
		}
	}
}