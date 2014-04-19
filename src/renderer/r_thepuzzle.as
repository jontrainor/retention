package renderer
{
	import game.puzzle.z_tile;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	import starling.display.Sprite;

	/*========================================================================================
	Puzzle world
	========================================================================================*/
	public class r_thepuzzle extends Sprite
	{
		protected var m_tiles:Vector.<z_tile>;
		
		public function r_thepuzzle() {
			m_tiles = new Vector.<z_tile>;	
		}
		
		/** Create grid here based on .oel, grid should create a list of type z_tile */
		public function CreateGrid( levelName:String ):void {
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest("../levels/" + levelName + ".oel"));
			loader.addEventListener(Event.COMPLETE, createGridCallback);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}

		protected function createGridCallback(e:Event):void {
			var level:XML = new XML(e.target.data);
			/* trace(level); */

			var levelLayers:Object = {};
			var levelNodes:XMLList = level.children();
			for each(var node:XML in levelNodes) {
				var levelLayer:Array = node.toString().split('\n');
				var layerIndex:int = 0;
				for each(var layer:String in levelLayer) {
					var layerArr:Array = layer.split('');
					levelLayer[layerIndex] = layerArr;
					layerIndex++;
				}
				levelLayers[node.name()] = levelLayer;
			}
			
			/* print out 2D arrays of each layer */
			for(var layerName:String in levelLayers) {
				trace(layerName + ' = ' + levelLayers[layerName]);
			}

			//create the grid, and call SetGridPosition on the tile
			//var tile:z_tile = new z_tile( somelayer, "basicTileTexture" );
			//tile.SetGridPosition( row, column );
			//m_tiles.push( tile );
		}

		protected function parseLevel(level:XML):void {
		}

		protected function onIOError(e:IOErrorEvent):void {
			trace("level did not load");
		}
		
		public function Destroy():void {
			m_tiles.length = 0;
		}
	}
}
