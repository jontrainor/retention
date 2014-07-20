package game
{
	import com.globals;
	
	import flash.utils.getTimer;
	
	import game.puzzle.z_player;
	
	import renderer.r_thebody;
	import renderer.r_thepuzzle;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class g_main extends Sprite
	{
		private var m_overworld		:r_thebody
		private var m_puzzleworld	:r_thepuzzle;
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
			AddTouch();
			AddUpdate();
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
		
		private function Update( e:Event ):void {
			m_currentTime = getTimer();
			m_deltaTime = m_currentTime - m_previousTime;
			g_state.instance.updateHandler( m_deltaTime/1000 );
			m_previousTime = m_currentTime;
		}
		
		public function Start():void {
			//remove menu, add player, overworld etc
			//overworld
			/*m_overworld = new r_thebody( AddElements );
			globals.background.addChild( m_overworld );
			m_overworld.visible = false;*/
			
			//puzzle
			m_puzzleworld = new r_thepuzzle( AddElements );
			m_puzzleworld.visible = true;
			
			globals.background.addChild( m_puzzleworld );
			globals.FadeIn();
		}
		
		private function AddElements():void {
			globals.FadeIn();
			//overworld
			//m_overworld.visible = true;
			//m_player = new g_bodyplayer( globals.midground, "player" );
			//m_player.Draw();
			
			//puzzle
			m_player 		= new z_player( globals.midground, "puzzleplayer" );
			//store reference to game grid
			m_player.x 		= m_puzzleworld.playerStartPosition.x;
			m_player.y 		= m_puzzleworld.playerStartPosition.y;
			m_player["grid"]= m_puzzleworld.grid;
			m_player.Draw();
		}
		
		private function AddTouch():void { stage.addEventListener( TouchEvent.TOUCH, OnTouch ); }
		private function RemoveTouch():void { stage.removeEventListener( TouchEvent.TOUCH, OnTouch ); }
		
		private function AddUpdate():void { addEventListener( Event.ENTER_FRAME, Update ); }
		private function RemoveUpdate():void { removeEventListener( Event.ENTER_FRAME, Update ); }
	}
}
