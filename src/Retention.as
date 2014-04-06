package
{
	import com.globals;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	
	import game.g_main;
	
	import starling.core.Starling;
	
	[SWF(backgroundColor=0, width=1024, height=768, frameRate=60)]
	public class Retention extends Sprite
	{
		private var m_starling:Starling;
		private var m_globals:globals;
		
		public function Retention() {
			//set stage align and stage scaling
			m_globals = new globals();
			Init();
		}
		
		private function Init():void {
			m_starling = new Starling( g_main, stage );
			m_starling.antiAliasing = 1;
			m_starling.start();
		}
	}
}