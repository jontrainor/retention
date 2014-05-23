package game
{
	import starling.events.KeyboardEvent;
	import starling.events.Touch;

	/*========================================================================================
	g_dispatcher calls functions applied to a single touch event or enter_frame listener in g_main
	========================================================================================*/
	public class g_dispatcher
	{
		/** List of functions to dispatch for each frame*/
		private var m_dispatchFrameList:Vector.<Object>;
		
		/** List of functions to dispatch for each touch event*/
		private var m_dispatchTouchList:Vector.<Object>;
		
		/** List of functions to dispatch for each keyboard event*/
		private var m_dispatchKeyboardList:Vector.<Object>;
		
		private const TOUCH:String = "touch";
		private const KEYBOARD:String = "keyboard";
		
		/** Singleton */
		static private var sm_instance:g_dispatcher;
		
		public function g_dispatcher( pvt:privateclass ) { 
			m_dispatchFrameList 	= new Vector.<Object>; 
			m_dispatchTouchList 	= new Vector.<Object>; 
			m_dispatchKeyboardList 	= new Vector.<Object>; 
		}
		
		/** Add a function to be dispatched on the next dispatch call 
		 * @param dispatchEventType - pass "frame" for ENTER_FRAME event, "touch" for a touch event 
		 * @param phase - if you are passing dispatchEventType value "touch", then pass the phase you want it to triger with
		 * otherwise pass the event phase you want it to run on
		 */
		public function AddToDispatch( f:Function, args:Object=null, dispatchEventType:String="frame", phase:String=null ):void {
			dispatchEventType.toLowerCase();
			var listName:String = dispatchEventType.charAt( 0 );
			listName = listName.toUpperCase()+dispatchEventType.slice(1);
			
			var list:Vector.<Object> = this[ "m_dispatch"+listName+"List" ];
			if ( m_dispatchFrameList.indexOf( f ) == -1 ) {
				if ( phase && dispatchEventType == TOUCH ) {
					m_dispatchTouchList.push( { func:f, args:args, phase:phase } );
				}
				else if ( dispatchEventType == KEYBOARD ) {
					m_dispatchKeyboardList.push( { func:f, args:args, phase:phase } );
				}
				else {
					m_dispatchFrameList.push( { func:f, args:args } );
				}
			}
		}
		
		/** Remove a function from the dispatch list */
		public function RemoveFromDispatch( f:Function, type:String="Frame" ):void {
			var i:int;
			var list:Vector.<Object> = this[ "m_dispatch"+type+"List" ];
			for ( ; i < list.length; ++i ) {
				if ( list[ i ].func == f ) {
					list.splice( i , 1 );
				}
			}
		}
		
		/** Dispatch all functions in the dispatch list */
		public function DispatchFrame( elapsedTime:Number ):void {
			var i:int;
			for ( ; i < m_dispatchFrameList.length; ++i ) {
				m_dispatchFrameList[ i ].func.apply( this, [elapsedTime] );
			}
		}
		
		/** Dispatch all functions in the dispatch list with the touch object arguement */
		public function DispatchTouch( touch:Touch ):void {
			var i:int;
			var obj:Object;
			for ( ; i < m_dispatchTouchList.length; ++i ) {
				obj = m_dispatchTouchList[ i ];
				if ( obj.phase == touch.phase ) {
					m_dispatchTouchList[ i ].func( touch );
				}
			}
		}
		
		/** Dispatch all functions in the dispatch list 
		 * @param type - type of keyboard event (ie. down, up)
		 * */
		public function DispatchKeyboard( e:KeyboardEvent ):void {
			var i:int;
			var obj:Object;
			for ( ; i < m_dispatchKeyboardList.length; ++i ) {
				obj = m_dispatchKeyboardList[i];
				if ( obj.phase == e.type ) {
					m_dispatchKeyboardList[ i ].func.apply( this, [ e ] );
				}
			}
		}
		
		/** Empty the specific dispatch list: Frame or Touch */
		public function ClearList(type:String="Frame"):void { this[ "dispatch"+type+"List" ].length = 0; }
		
		/** Empty all dispatch lists */
		public function Clear():void { m_dispatchFrameList.length = m_dispatchTouchList.length = 0; }
		
		/** Destroy the singleton */
		public function Destroy():void { sm_instance = null; }
		
		static public function get instance():g_dispatcher { return sm_instance = sm_instance ? sm_instance : new g_dispatcher( new privateclass ); }
	}
}

class privateclass{}