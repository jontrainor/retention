package renderer
{
	import com.globals;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/*========================================================================================
	OEL file loader for puzzle levels
	========================================================================================*/
	public class r_loader extends URLLoader
	{
		private var m_levelPath			:String;
		private var m_loadState			:String;
		private var m_callback			:Function;
		private var m_loadQue			:Vector.<Object>;
		private var m_loadedLevels		:Dictionary;
		
		/** singleton */
		static private var sm_instance	:r_loader;
		
		public function r_loader( pvt:privateclass ) {
			m_loadedLevels 	= new Dictionary();
			m_loadQue 		= new Vector.<Object>();
			m_levelPath		= "../levels/";
			m_loadState 	= globals.READY;
			this.addEventListener( Event.COMPLETE, OnComplete );
		}
		
		/*
		==============
		LoadLevel
		==============
		*/
		private function LoadLevel( path:String ):void {
			globals.echo( "loading level: " + path );
			m_loadState = globals.LOADING;
			load( new URLRequest( path ) );
		}
		
		/*
		==============
		OnComplete
		
		Level finished loading, store level file and do callback
		Continue through loadQue while it contains assets to be loaded
		==============
		*/
		private function OnComplete( e:Event ):void {
			var xml:XML = new XML(e.target.data);
			m_loadedLevels[xml.name] = xml;
			m_loadState = globals.READY;
			
			m_callback( xml );
			
			if ( m_loadQue.length > 0 ) {
				GetLevel( m_loadQue[ 0 ].name, m_loadQue[0].callback );
				m_loadQue.splice( 0, 1 );
			}
		}
		
		/*
		==============
		GetLevel
		
		Return level or load level if it is not stored in the loadedAssets container
		If a level is currently loading when GetLevel is called, we add that level to the loadQue
		==============
		*/
		public function GetLevel( name:String, callback:Function=null ):* {
			if ( m_loadedLevels[name] ) { 
				return m_loadedLevels[name];
			}
			if ( m_loadState != globals.LOADING ) { 
				m_callback = callback;
				LoadLevel( m_levelPath+name+".xml" ); //change to oel when ready to use ogmo
			} 
			else if ( m_loadQue.indexOf( name ) == -1 ) {
				m_loadQue.push( { name:name, callback:callback } );
			}
		}
		
		
		/*=============================================================================
		Accessors and Mutators
		=============================================================================*/
		public function set levelPath( path:String ):void { m_levelPath = path; }
		public function get levelPath():String { return m_levelPath; }
		
		public static function get instance():r_loader { return sm_instance ? sm_instance : sm_instance = new r_loader( new privateclass() ); }
	}
}

class privateclass{}