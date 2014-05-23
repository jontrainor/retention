package renderer
{
	import com.globals;
	
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import game.g_dispatcher;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/*=============================================================================
	body/overworld class
	=============================================================================*/
	public class r_world extends Sprite
	{
		/** layers are used for parallax, and the name is deceiving as they are all added to background */
		private var m_backgroundLayer	:r_layer;
		private var m_midgroundLayer	:r_layer;
		private var m_foregroundLayer	:r_layer;
		private var m_layers			:Vector.<r_layer>;
		private var m_space				:Space;
		private var m_tiles				:Vector.<r_tile>;
		
		//debugging only
		private var m_debug				:BitmapDebug;
		
		/** current loaded level */
		private var m_currentLevel		:Object;
		/** this gets called after the level is finished loading and setup */
		private var m_onLoadedCallback	:Function;
		
		/** test bitmap text field to demonstrate use */
		private var m_testTextField		:TextField;
		
		public function r_world( onLoadedCallback:Function ) {
			m_layers = new Vector.<r_layer>;
			m_tiles = new Vector.<r_tile>;
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
			
			LoadLevel();
		}
		
		protected function LoadLevel():void {
			//TODO: pull from shared object, determine what world the player is on
			r_loader.instance.GetLevel( "TestLevel", ".rmf", OnLevelLoaded );
		}
		
		protected function OnLevelLoaded( levelData:Object ):void {
			m_currentLevel = {};
			m_currentLevel.tiles = [];
			m_currentLevel.baseLevel = levelData;
			r_tileloader.instance.loadAmount = levelData.tiles.length;			
			
			var i:int;
			var loadedTiles:Array = [];
			for ( ; i < levelData.tiles.length; ++i ) {
				loadedTiles.push( levelData.tiles[ i ].tile );
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
			//create the world physics
			CreateWorldPhysics();
			var i:int;
			var element:Object;
			for ( ; i < m_currentLevel.tiles.length; ++i ) {
				element = m_currentLevel.baseLevel.tiles[ i ];
				var tileContainer:r_tile = new r_tile();
				var tile:Image = new Image( Texture.fromBitmap( m_currentLevel.tiles[ i ] ) );
				tileContainer.x = element.position.x;
				tileContainer.y = element.position.y;
				tileContainer.addChild( tile );
				
				ApplyTileProperties( tileContainer, tile, element );
				tileContainer.Init();
				m_tiles.push( tileContainer );
				m_layers[ element.layer ].addChild( tileContainer );
			}
			for ( i=0; i < m_currentLevel.baseLevel.collisions.length; ++i ) {
				element = m_currentLevel.baseLevel.collisions[ i ];
				var collision:r_collidable = new r_collidable( element.type );
				collision.x = element.position.x;
				collision.y = element.position.y;
				collision.width = element.box.width;
				collision.height = element.box.height;
				collision.Init();
			}
			Init();
			m_onLoadedCallback();
		}
		
		/** Apply correct properties of the tile */
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
		
		/** One time call to start the world phyiscs */
		protected function CreateWorldPhysics():void {
			//AddTextField();
			//debugging only - replace with compiler tags later
			m_debug = new BitmapDebug(stage.stageWidth, stage.stageHeight, 0, true);
			Starling.current.nativeOverlay.addChild( m_debug.display );
			
			m_space = new Space( new Vec2(0, globals.gravity ) );
			
			globals.space = m_space;
		}
		
		/** Initialize all the layer drawing */
		protected function Init():void {
			m_backgroundLayer.Draw();
			m_midgroundLayer.Draw();
			m_foregroundLayer.Draw();
			
			m_midgroundLayer.flatten();
			m_backgroundLayer.flatten();
			m_foregroundLayer.flatten();
			
			g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.BEGAN );
			g_dispatcher.instance.AddToDispatch( Update );
		}
		
		protected function Update( elapsedTime:Number ):void {
			m_debug.clear();
			m_space.step(1/60);
			
			//debugging only
			m_debug.draw(m_space);
			m_debug.flush();
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
	}
}