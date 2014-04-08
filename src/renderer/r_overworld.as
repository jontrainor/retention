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
	
	public class r_overworld extends Sprite
	{
		/** layers are used for parallax, and the name is deceiving as they are all added to background */
		private var m_backgroundLayer	:r_layer;
		private var m_midgroundLayer	:r_layer;
		private var m_foregroundLayer	:r_layer;
		
		/** particle system is the bubble effect created at player's location */
		private var m_particleSystem	:ParticleSystem;
		
		public function r_overworld() {
			m_backgroundLayer = new r_layer( assets.getTexture( "background" ), 0.5, globals.background );
			m_midgroundLayer = new r_layer( assets.getTexture( "midground" ), 0.75, globals.background );
			m_foregroundLayer = new r_layer( assets.getTexture( "foreground" ), 1, globals.background );
			addEventListener( Event.ADDED_TO_STAGE, onAdded );
		}
		
		protected function onAdded( e:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAdded );
			drawBackground();
		}
		
		protected function drawBackground():void {
			//addParticles();
			globals.background.addChild( m_backgroundLayer );
			globals.midground.addChild( m_midgroundLayer );
			globals.foreground.addChild( m_foregroundLayer );
			
			m_backgroundLayer.Draw();
			m_midgroundLayer.Draw();
			m_foregroundLayer.Draw();
			
			g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.BEGAN );
		}
		
		protected function OnTouch( touch:Touch ):void {
			var angle:Number = Math.atan2( touch.globalY - globals.stageHalfHeight, touch.globalX - globals.stageHalfWidth );
			var velocity:Point = new Point( Math.cos( angle ), Math.sin( angle ) );
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
	}
}