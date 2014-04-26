package renderer
{
	import com.assets;
	import com.globals;
	
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import game.g_dispatcher;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.ParticleSystem;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/*=============================================================================
	body/overworld class
	=============================================================================*/
	public class r_thebody extends Sprite
	{
		/** layers are used for parallax, and the name is deceiving as they are all added to background */
		private var m_backgroundLayer	:r_layer;
		private var m_midgroundLayer	:r_layer;
		private var m_foregroundLayer	:r_layer;
		private var m_camera			:r_camera;
		private var m_layers			:Vector.<r_layer>
		
		/** current loaded level */
		private var m_currentLevel		:Object;
		/** this gets called after the level is finished loading and setup */
		private var m_onLoadedCallback	:Function;
		
		/** particle system is the bubble effect created at player's location */
		private var m_particleSystem	:ParticleSystem;
		
		/** test bitmap text field to demonstrate use */
		private var m_testTextField		:TextField;
		
		public function r_thebody( onLoadedCallback:Function ) {
			m_camera = new r_camera(this);
			m_layers = new Vector.<r_layer>;
			m_onLoadedCallback = onLoadedCallback;
			addEventListener( Event.ADDED_TO_STAGE, onAdded );
		}
		
		protected function onAdded( e:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAdded );
			
			m_backgroundLayer 	= new r_layer( 0.5, this );
			m_midgroundLayer 	= new r_layer( 0.75, this );
			m_foregroundLayer 	= new r_layer( 1, this );
			
			m_layers.push( m_backgroundLayer );
			m_layers.push( m_midgroundLayer );
			m_layers.push( m_foregroundLayer );
			
			LoadBodyLevel();
		}
		
		protected function LoadBodyLevel():void {
			//TODO: pull from shared object, determine what world the player is on
			r_loader.instance.GetLevel( "thebody_1", ".rmf", OnLevelLoaded );
		}
		
		protected function OnLevelLoaded( levelData:Object ):void {
			m_currentLevel = {};
			m_currentLevel.tiles = [];
			m_currentLevel.baseLevel = levelData;
			r_tileloader.instance.loadAmount = levelData.tiles.length;			
			
			var i:int;
			for ( ; i < levelData.tiles.length; ++i ) {
				r_tileloader.instance.AddAssetToLoad( levelData.tiles[ i ].tile, OnTileLoaded );
			}
			r_tileloader.instance.LoadAll();
		}
		
		protected function OnTileLoaded( asset:Bitmap, isComplete ):void {
			m_currentLevel.tiles.push( asset );
			if ( isComplete ) { GenerateLevel(); }
		}
		
		/** Parse through all the tile objects, add them to the correct container, and apply the correct transformations */
		private function GenerateLevel():void {
			var i:int;
			for ( ; i < m_currentLevel.tiles.length; ++i ) {
				var element:Object = m_currentLevel.baseLevel.tiles[ i ];
				var tileContainer:Sprite = new Sprite();
				var tile:Image = new Image( Texture.fromBitmap( m_currentLevel.tiles[ i ] ) );
				tileContainer.x = element.position.x;
				tileContainer.y = element.position.y;
				tileContainer.addChild( tile );
				
				ApplyTileProperties( tileContainer, tile, element );
				m_layers[ element.layer ].addChild( tileContainer );
			}
			m_onLoadedCallback();
			DrawAll();
		}
		
		/** Callback when tile properties are changed */
		public function ApplyTileProperties( container:Sprite, tile:Image, properties:Object ):void {
			var prevW:Number 	= container.width;
			var prevH:Number 	= container.height;
			var prevScale:Point = new Point( container.scaleX, container.scaleY );
			container.scaleX 	= properties.scale.x;
			container.scaleY 	= properties.scale.y;
			
			//rotate the tile only
			var matrix:Matrix = new Matrix();
			matrix.translate( -container.width/2, -container.height/2 );
			matrix.rotate( properties.rotation * Math.PI / 180 );
			matrix.translate( container.width/2, container.height/2 );
			tile.transformationMatrix = matrix;
		}
		
		/** One time call to have the overworld elemenst appear */
		protected function DrawAll():void {
			AddParticles();
			AddTextField();
			
			m_backgroundLayer.Draw();
			m_midgroundLayer.Draw();
			m_foregroundLayer.Draw();
			
			m_midgroundLayer.flatten();
			m_backgroundLayer.flatten();
			m_foregroundLayer.flatten();
			
			g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.BEGAN );
			g_dispatcher.instance.AddToDispatch( Update );
		}
		
		protected function Update():void {
			m_camera.x = globals.player.x;
			m_camera.y = globals.player.y;
			m_particleSystem.emitterX = globals.player.x + (globals.player.asset.width/2 * Math.cos( globals.player.rotation ) );
			m_particleSystem.emitterY = globals.player.y + (globals.player.asset.height/2 * Math.sin( globals.player.rotation ) );
		}
		
		/** Particle effect, update emitterX and emitterY to player position.
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
		
		protected function AddTextField():void {
			// This technically only needs to get called once ever
			// Doing the register in some global init file would probably be wise
			// Note the name, having the exact same name as a system font breaks flash
			//assets.registerBitmapFont( "Consolass" );
			//m_testTextField		= new TextField(400, 100, "This is a test text field, remove me!", "Consolass", 20, 0xFFFFFF);
			//addChild(m_testTextField);
		}
		
		/*=============================================================================
		Event Handling
		=============================================================================*/
		/** Touch event handler */
		protected function OnTouch( touch:Touch ):void {}
		
		/*=============================================================================
		Accessors and Mutators
		=============================================================================*/
		/** Set the world x coordinate*/
		override public function set x(value:Number):void {
			m_midgroundLayer.x 		= value;
			m_backgroundLayer.x 	= value;
			m_foregroundLayer.x 	= value;
			globals.background.x 	= value;
			globals.midground.x 	= value;
		}
		
		/** Set the world y coordinate*/
		override public function set y(value:Number):void {
			m_midgroundLayer.y 		= value;
			m_backgroundLayer.y 	= value;
			m_foregroundLayer.y 	= value;
			globals.background.y 	= value;
			globals.midground.y 	= value;
		}
	}
}