package game
{
	import com.globals;
	
	import flash.utils.getTimer;
	
	import renderer.r_world;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class g_main extends Sprite
	{
		private var m_world			:r_world
		private var m_player		:g_player;
		private var m_appState		:String;
		
		//used to update elapsed time between frames
		private var m_deltaTime		:int;
		private var m_currentTime	:int;
		private var m_previousTime	:int;
		
		public function g_main() {
			addEventListener( Event.ADDED_TO_STAGE, OnAdded );
		}
		
		private function OnAdded( e:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, OnAdded );
			//set globals and state callbacks
			globals.stageWidth 		= stage.stageWidth;
			globals.stageHeight 	= stage.stageHeight;
			g_state.instance.Start 	= Start;
			
			Init();
		}
		
		/** Menu section */
		private function Init():void {
			m_appState = globals.MENU;
			globals.CreateLayers( stage );
			AddListeners();
			//add menu, etc
		}
		
		/** Start is called after we are finished with the menu */
		public function Start():void {
			//remove menu, add player, overworld etc
			m_world = new r_world( AddElements );
			globals.background.addChild( m_world );
			//m_world.visible = false;
			
			//globals.FadeIn();
		}
		
		private function OnTouch( e:TouchEvent ):void {
			var touch:Touch = e.getTouch( stage );
			if ( touch ) {
				if ( touch.phase == TouchPhase.BEGAN ) {
					g_state.instance.StateHandler( touch );
				}
			}
		}
		
		private function Update( e:Event ):void {
			m_currentTime = getTimer();
			m_deltaTime = m_currentTime - m_previousTime;
			
			g_state.instance.UpdateHandler( m_deltaTime );
			m_previousTime = m_currentTime;
		}
		
		private function OnKeyEvent( e:KeyboardEvent ):void {
			g_state.instance.StateHandler( e );
		}
		
		private function AddElements():void {
			//globals.FadeIn();
			m_player = new g_player( globals.midground, "player", true, 4 );
			m_player.Draw();
			m_player.x = stage.stageWidth/2;
			m_player.y = stage.stageHeight/2;
		}
		
		private function AddListeners():void {
			stage.addEventListener( TouchEvent.TOUCH, OnTouch );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, OnKeyEvent );
			stage.addEventListener( KeyboardEvent.KEY_UP, OnKeyEvent );
			addEventListener( Event.ENTER_FRAME, Update );
		}
		
		private function RemoveListeners():void {
			stage.removeEventListener( TouchEvent.TOUCH, OnTouch );
			stage.removeEventListener( KeyboardEvent.KEY_DOWN, OnKeyEvent );
			stage.removeEventListener( KeyboardEvent.KEY_UP, OnKeyEvent );
			removeEventListener( Event.ENTER_FRAME, Update );
		}
	}
}
