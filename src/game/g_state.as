package game
{
	import com.globals;
	
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	public class g_state
	{	
		/*===============
		PRIVATE			
		===============*/
		private var m_state		:String;
		
		/*===============
		PUBLIC			
		===============*/
		/** Start function to call for state handler */
		public var Start		:Function;
		public var elapsedTime	:Number;
		
		/** singleton */
		static private var m_instance:g_state;
		
		public function g_state( pvt:privateclass ) { m_state = globals.MENU; }
		
		/** Handle a touch event state based on our current game state */
		public function stateHandler( touch:Touch ):void {
			switch( touch.phase ) {
				case TouchPhase.BEGAN :
					//for now just call start and change the state
					if ( m_state == globals.MENU ) {
						Start();
						SetState( globals.GAME_OVERWORLD );
					} 
					else if ( m_state == globals.GAME_OVERWORLD ) {
						g_dispatcher.instance.DispatchTouch( touch );
					}
					break;
			}
		}
		
		/** Dispatch all the frame event functions */
		public function updateHandler( elapsedTime:Number ):void {
			this.elapsedTime = elapsedTime;
			g_dispatcher.instance.DispatchFrame();
		}
		
		private function SetState( state:String ):void {
			m_state = state;
			globals.echo( "state set to: " + m_state );
		}
		
		public function get state():String { return m_state; }
		
		static public function get instance():g_state { return m_instance = m_instance ? m_instance : new g_state( new privateclass() ); }
	}
	
	
}

class privateclass {}