package renderer
{
	import com.assets;
	import com.globals;
	
	import flash.geom.Point;
	
	import game.g_dispatcher;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.ParticleSystem;
	
	public class r_thebody extends Sprite
	{
		/** layers are used for parallax, and the name is deceiving as they are all added to background */
		private var m_backgroundLayer	:r_layer;
		private var m_midgroundLayer	:r_layer;
		private var m_foregroundLayer	:r_layer;
		private var m_camera			:r_camera;
		
		/** particle system is the bubble effect created at player's location */
		private var m_particleSystem	:ParticleSystem;
		
		public function r_thebody() {
			m_camera			= new r_camera(this);
			
			addEventListener( Event.ADDED_TO_STAGE, onAdded );
		}
		
		protected function onAdded( e:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAdded );
			
			m_backgroundLayer 	= new r_layer( assets.getTexture( "background" ), 0.5, stage );
			m_midgroundLayer 	= new r_layer( assets.getTexture( "midground" ), 0.75, stage );
			m_foregroundLayer 	= new r_layer( assets.getTexture( "foreground" ), 1, stage );
			
			drawBackground();
		}
		
		protected function drawBackground():void {
			//addParticles();
			
			m_backgroundLayer.Draw();
			m_midgroundLayer.Draw();
			m_foregroundLayer.Draw();
			
			g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.BEGAN );
			g_dispatcher.instance.AddToDispatch( Update );
		}
		
		protected function OnTouch( touch:Touch ):void {
			var angle:Number = Math.atan2( touch.globalY - globals.stageHalfHeight, touch.globalX - globals.stageHalfWidth );
			var velocity:Point = new Point( Math.cos( angle ), Math.sin( angle ) );
		}
		
		protected function Update():void {
			m_camera.x = globals.player.x;
			m_camera.y = globals.player.y;
		}
		
		/** Bubble effect, update emitterX and emitterY to player position.
		 * 	The particle.pex file can be update to change values as well, (pex is an xml)
		 */
		protected function AddParticles():void {
			m_particleSystem = new PDParticleSystem( assets.getConfig( "particle" ), assets.getTexture( "particle" ) );
			
			m_particleSystem.emitterX = globals.stageHalfWidth;
			m_particleSystem.emitterY = globals.stageHalfHeight;
			m_particleSystem.start();
			
			addChild( m_particleSystem );
			Starling.juggler.add( m_particleSystem );
		}
		
		/** Set the world x coordinate*/
		override public function set x(value:Number):void {
			m_backgroundLayer..x 	= value;
			m_midgroundLayer.x 		= value;
			m_foregroundLayer.x 	= value;
		}
		
		/** Set the world y coordinate*/
		override public function set y(value:Number):void {
			m_backgroundLayer.y 	= value;
			m_midgroundLayer.y 		= value;
			m_foregroundLayer.y 	= value;
		}
	}
}