package
{
	import com.globals;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import game.g_main;
	
	import starling.core.Starling;
	import starling.events.ResizeEvent;
	
	[SWF(backgroundColor=0, width=960, height=640, frameRate=60)]
	public class NG extends Sprite
	{
		private var m_starling:Starling;
		private var m_globals:globals;
		
		public function NG() {
			//set stage align and stage scaling
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			m_globals = new globals();
			Init();
		}
		
		private function Init():void {
			stage.addEventListener( ResizeEvent.RESIZE, OnStageResize );
			m_starling = new Starling( g_main, stage );
			m_starling.antiAliasing = 1;
			m_starling.start();
			
			//temporary debugging only
			m_starling.showStats = true;
		}
		
		/** scale with the stage */
		private function OnStageResize( e:Event ):void {
			var viewPortRectangle:Rectangle = new Rectangle();
			viewPortRectangle.width = stage.stageWidth; 
			viewPortRectangle.height = stage.stageHeight;
			
			//resize the viewport
			Starling.current.viewPort = viewPortRectangle;
			
			globals.stageWidth = stage.stageWidth;
			globals.stageHeight = stage.stageHeight;
		}
	}
}