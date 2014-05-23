package game
{
	import com.globals;
	
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import nape.callbacks.InteractionCallback;
	
	import starling.core.Starling;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;

	public class g_playerstate implements g_istatemachine
	{
		protected var m_player			:g_player;
		protected var m_elapsedTime		:Number;
		//key press container
		protected var keys				:Dictionary;
		
		//state flags
		protected var m_jumpState		:String;
		protected var m_moveState		:String;
		
		//const
		protected const JUMPING			:String = "jumping";
		protected const DESCEND			:String	= "descend";
		protected const RUNNING			:String	= "running";
		protected const READY			:String	= "ready";
		protected const NONE			:String	= "none";
		
		public function g_playerstate( player:g_player ) {
			m_player = player;	
		}
		
		public function Init():void {
			keys = new Dictionary;
			m_jumpState = m_moveState = READY;
			g_dispatcher.instance.AddToDispatch( OnKeyDown, null, "keyboard", KeyboardEvent.KEY_DOWN );
			g_dispatcher.instance.AddToDispatch( OnKeyUp, null, "keyboard", KeyboardEvent.KEY_UP );
			g_dispatcher.instance.AddToDispatch( UpdateHandler );
		}
		
		public function StateHandler( input:* ):void {
			
		}
		
		
		public function HandleFloorCollision( collision:InteractionCallback ):void {
			//determine what to do with the type of collision that occured with the player
			m_jumpState = READY;
			//m_player.m_body.gravMass = 0;
		}
		
		public function UpdateHandler( elapsedTime:Number ):void {
			//handle current key presses
			if ( keys[ Keyboard.LEFT ] ) {
				m_player.Move( -1, elapsedTime );
			}
			else if ( keys[ Keyboard.RIGHT ] ) {
				m_player.Move( 1, elapsedTime );
			}
			else if ( m_moveState == RUNNING && m_jumpState != JUMPING ) {
				m_moveState = READY;
				m_player.m_body.velocity.x *= 0.3;
			}
			m_elapsedTime = elapsedTime;
		}
		
		/** Keyboard event, applied with relative touch phases
		 * e.g. - g_dispatcher.instance.AddToDispatch( OnKeyDown, null, "keyboard", KeyboardEVent.KEY_DOWN ); 
		 * */
		protected function OnKeyDown( e:KeyboardEvent ):void {
			switch( e.keyCode ) {
				case Keyboard.UP:		JumpState( Keyboard.UP );
					break;
				
				case Keyboard.LEFT:		MoveState( Keyboard.LEFT );
					break;
				
				/*case Keyboard.S:	MoveState();
					break;*/
				
				case Keyboard.RIGHT:	MoveState( Keyboard.RIGHT );
					break;
			}
		}
		
		/** Keyboard event, applied with relative touch phases
		 * e.g. - g_dispatcher.instance.AddToDispatch( OnKeyDown, null, "keyboard", KeyboardEVent.KEY_DOWN ); 
		 * */
		protected function OnKeyUp( e:KeyboardEvent ):void {
			switch( e.keyCode ) {
				case Keyboard.UP:		keys[ Keyboard.UP ] = false;
					break;
				
				case Keyboard.LEFT:		keys[ Keyboard.LEFT ] = false;
					break;
				
				case Keyboard.RIGHT:	keys[ Keyboard.RIGHT ] = false;
					break;
			}
			if ( !keys[ Keyboard.LEFT ] && !keys[ Keyboard.RIGHT ] ) {
				m_player.asset.gotoAndStop( e.keyCode == Keyboard.LEFT ? 0 : 4 );
			}
		}
		
		/** Touch event, applied with relative touch phases
		 * e.g. - g_dispatcher.instance.AddToDispatch( OnTouch, null, "touch", TouchPhase.BEGAN ); 
		 * */
		protected function OnTouch( touch:Touch ):void {
			
		}
		
		protected function MoveState( key:uint ):void {
			if ( keys[ key ] ) { return; }
			keys[ key ] = true;
			m_moveState = RUNNING;
			var startFrame:int = key == Keyboard.LEFT ? 0 : 4;
			var endFrame:int = key == Keyboard.LEFT ? 2 : 6;
			m_player.asset.gotoAndPlay( startFrame, endFrame );
			
		}
		
		protected function JumpState( key:uint ):void {
			if ( m_jumpState == JUMPING || keys[ Keyboard.UP ] ) { return; }
			keys[ key ] = true;
			m_jumpState = JUMPING;
			m_player.Jump();
		}
		
		public function JumpFinished():void { m_jumpState = DESCEND; }
	}
}