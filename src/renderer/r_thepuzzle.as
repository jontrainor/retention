package renderer
{
	import com.globals;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import game.g_dispatcher;
	import game.puzzle.z_tile;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/*========================================================================================
	Puzzle world
	========================================================================================*/
	public class r_thepuzzle extends Sprite
	{
		protected var m_tiles				:Vector.<z_tile>;
		protected var m_layers				:Vector.<r_layer>;
		protected var m_currentLevel		:String;
		
		protected var m_backgroundLayer		:r_layer;
		protected var m_midgroundLayer		:r_layer;
		protected var m_foregroundLayer		:r_layer;
		
		protected var m_camera				:r_camera;
		
		/** this gets called after the level is finished loading and setup */
		private var m_onLoadedCallback		:Function;
		private var m_playerStartPosition	:Point;
		
		public var levelWidth				:int;
		public var levelHeight				:int;
		public var grid						:Array;

		
		public function r_thepuzzle( onLoadedCallback:Function ) {
			m_tiles = new Vector.<z_tile>;
			m_layers = new Vector.<r_layer>;
			m_backgroundLayer 	= new r_layer( 1, this );
			m_midgroundLayer 	= new r_layer( 1, this );
			m_foregroundLayer 	= new r_layer( 1, this );
			
			m_onLoadedCallback = onLoadedCallback;
			
			m_layers.push( m_backgroundLayer );
			m_layers.push( m_midgroundLayer );
			m_layers.push( m_foregroundLayer );
			
			m_currentLevel = "puzzle_1"; //change this accordingly for shared object
			m_camera = new r_camera( this );
			LoadLevel( m_currentLevel );
		}
		
		public function LoadLevel( levelName:String ):void {
			r_tileloader.instance.assetPath = "../assets/puzzle/";
			r_tileloader.instance.AddAssetToLoad( "wall.png" );
			r_tileloader.instance.AddAssetToLoad( "player.png" );
			r_tileloader.instance.AddAssetToLoad( "node.png" );
			r_tileloader.instance.AddAssetToLoad( "floor.png", OnLoadComplete );
			r_tileloader.instance.LoadAll();
		}
		
		private function OnLoadComplete( ...args ):void {
			r_loader.instance.GetLevel( m_currentLevel, ".oel", GenerateLevel );
		}
		
		/** Create grid here based on .oel, grid should create a list of type z_tile */
		public function GenerateLevel( level:XML ):void {
			var walls:Array = level.walls.split("\n");
			var moveableWalls:Array = level.moveableWalls.split("\n");
			
			m_playerStartPosition = new Point( level.entity.player.attribute("x"), level.entity.player.attribute("y") );
			var nodeLocations:Vector.<Point> = new Vector.<Point>;
			
			for each ( var entity:XML in level.entity ) {
				if ( entity.node ) {
					nodeLocations.push( new Point( entity.node.attribute( "x" ), entity.node.attribute( "y" ) ) );
				}
			}
			
			var row:int;
			var column:int;
			var assetName:String;
			grid = [];
			for ( ; row < walls.length; ++row ) {
				grid[row] = [];
				walls[ row ] = walls[ row ].split("");
				for ( column = 0; column < walls[ row ].length; ++column ) {
					assetName = walls[ row ][ column ] == 1 ? "wall" : "floor";
					var tile:z_tile = new z_tile( m_backgroundLayer, assetName );
					m_backgroundLayer.addChild( tile );
					
					tile.SetGridPosition( row, column );
					
					tile.x = column * tile.width;
					tile.y = row * tile.height;
					grid [row ][ column ] = walls[ row ][column ];
				}
			}
			//sort walls in grid
			for ( row=0; row < moveableWalls.length; ++row ) {
				moveableWalls[ row ] = moveableWalls[ row ].split("");
				for ( column = 0; column < walls[ row ].length; ++column ) {
					/*assetName = walls[ row ][ column ] == 1 ? "wall" : "floor";
					var movable:z_tile = new z_tile( m_backgroundLayer, assetName );
					m_backgroundLayer.addChild( movable );
					
					movable.SetGridPosition( row, column );
					
					movable.x = column * movable.width;
					movable.y = row * movable.height;*/
					grid [row ][ column ] = walls[ row ][column ];
				}
			}
			
			levelWidth = level.attribute("width");
			levelHeight = level.attribute("height");
			DrawAll();
			m_onLoadedCallback();
		}
		
		protected function DrawAll():void {
			//g_dispatcher.instance.AddToDispatch( Update );
			
			m_backgroundLayer.Draw();
			m_midgroundLayer.Draw();
			m_foregroundLayer.Draw();
		}
		
		protected function Update():void {


		}
		
		public function Destroy():void {
			m_tiles.length = 0;
			m_layers.length = 0;
		}
		
		public function get playerStartPosition():Point { return m_playerStartPosition; }
	}
}
