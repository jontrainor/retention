package renderer
{
	import com.globals;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
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
		private var m_currentLevelName	:String;
		
		/** singleton */
		static private var sm_instance	:r_loader;
		
		public function r_loader( pvt:privateclass ) {
			m_loadedLevels 	= new Dictionary();
			m_loadQue 		= new Vector.<Object>();
			m_levelPath		= "../levels/";
			m_loadState 	= globals.READY;
			this.addEventListener( Event.COMPLETE, OnComplete );
		}
		
		private function LoadLevel( path:String ):void {
			globals.echo( "loading level: " + path );
			m_loadState = globals.LOADING;
			load( new URLRequest( path ) );
		}
		
		private function OnComplete( e:Event ):void {
			//did we load a puzzle level?
			if ( this.dataFormat == URLLoaderDataFormat.TEXT ) {
				var xml:XML = new XML(e.target.data);
				m_loadedLevels[m_currentLevelName] = xml;
				m_callback( xml );
			}
			//nope, it's a body level
			else {
				var loader:URLLoader = e.target as URLLoader;
				var data:ByteArray = loader.data as ByteArray;
				var levelObject:Object = data.readObject();
				m_loadedLevels[ m_currentLevelName ] = m_loadedLevels;
				m_callback( levelObject );
			}
			m_loadState = globals.READY;
			
			if ( m_loadQue.length > 0 ) {
				GetLevel( m_loadQue[ 0 ].name, m_loadQue[0].callback );
				m_loadQue.splice( 0, 1 );
			}
		}
		
		/** Load a level file, either for the body or the puzzle section 
		 * @param name - name of the level file
		 * @param extension - set this to .rmf or .oel respectively (oel for ogmo)
		 * @param callback - method to call once the level file has finished loading
		 * */
		public function GetLevel( name:String, extension:String=".rmf", callback:Function=null ):* {
			if ( m_loadedLevels[name] ) { 
				return m_loadedLevels[name];
			}
			if ( m_loadState != globals.LOADING ) { 
				m_callback = callback;
				m_currentLevelName = name;
				this.dataFormat = extension == ".rmf" ? URLLoaderDataFormat.BINARY : URLLoaderDataFormat.TEXT;
				LoadLevel( m_levelPath+name+extension );
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