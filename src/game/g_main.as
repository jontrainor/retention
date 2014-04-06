package game
{
	import com.globals;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class g_main extends Sprite
	{
		private var m_player:g_drawable;
		private var m_appState:String;
		
		public function g_main() {
			addEventListener( Event.ADDED_TO_STAGE, OnAdded );
		}
		
		private function OnAdded( e:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, OnAdded );
			//set globals and state callbacks
			globals.stageWidth 		= stage.stageWidth;
			globals.stageHeight 	= stage.stageHeight;
			g_state.instance.Start 	= Start;
			//added to the stage, ready to display items
			
			Init();
		}
		
		private function Init():void {
			m_appState = globals.MENU;
			globals.CreateLayers( stage );
			AddTouch();
			//add menu, etc
		}
		
		private function OnTouch( e:TouchEvent ):void {
			var touch:Touch = e.getTouch( stage );
			if ( touch ) {
				if ( touch.phase == TouchPhase.BEGAN ) {
					g_state.instance.stateHandler( touch );
				}
			}
		}
		
		private function AddTouch():void { stage.addEventListener( TouchEvent.TOUCH, OnTouch ); }
		private function RemoveTouch():void { stage.removeEventListener( TouchEvent.TOUCH, OnTouch ); }
		
		public function Start():void {
			//remove menu, add player, overworld etc
			m_player = new g_player( globals.midground, "player" );
			m_player.Draw();
		}
	}
}