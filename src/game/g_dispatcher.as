package game
{
	import starling.events.Touch;

	public class g_dispatcher
	{
		/** List of functions to dispatch for each frame*/
		private var m_dispatchFrameList:Vector.<Object>;
		
		/** List of functions to dispatch for each touch event*/
		private var m_dispatchTouchList:Vector.<Object>;
		
		/** Singleton */
		static private var sm_instance:g_dispatcher;
		
		public function g_dispatcher( pvt:privateclass ) { m_dispatchFrameList = new Vector.<Object>; m_dispatchTouchList = new Vector.<Object>; }
		
		/** Add a function to be dispatched on the next dispatch call 
		 * @param dispatchEventType - pass "frame" for ENTER_FRAME event, "touch" for a touch event 
		 * @param touchPhase - if you are passing dispatchEventType value "touch", then pass the phase you want it to triger with
		 */
		public function AddToDispatch( f:Function, args:Object=null, dispatchEventType:String="frame", touchPhase:String=null ):void {
			dispatchEventType.toLowerCase();
			var listName:String = dispatchEventType.charAt(0);
			listName = listName.toUpperCase()+dispatchEventType.slice(1);
			
			var list:Vector.<Object> = this[ "m_dispatch"+listName+"List" ];
			if ( m_dispatchFrameList.indexOf( f ) == -1 ) {
				if ( touchPhase && dispatchEventType == "touch" ) {
					m_dispatchFrameList.push( { func:f, args:args, phase:touchPhase } );
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
					break;
				}
			}
		}
		
		/** Dispatch all functions in the dispatch list */
		public function DispatchFrame():void {
			var i:int;
			for ( ; i < m_dispatchFrameList.length; ++i ) {
				m_dispatchFrameList[ i ].func( m_dispatchFrameList[ i ].args );
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