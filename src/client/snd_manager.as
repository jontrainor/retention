package client
{
	import flash.media.Sound;
	import flash.net.URLRequest;

	/*========================================================================================
	Sound manager
	========================================================================================*/
	public class snd_manager
	{
		private var m_audioPaths:Vector.<String>;
		
		/** singleton */
		static private var sm_instance:snd_manager;
		
		public function snd_manager( pvt:privateclass ){
			m_audioPaths = new Vector.<String>;
		}
		
		public function LoadAudio( onCompleteCallback:Function=null ):void {
			var i:int;
			for ( ; i < m_audioPaths.length; i++ ) {
				//var req:URLRequest = new URLRequest( "audio/"+m_audioPaths[i] );
				//var name:String = m_audioPaths[i].replace(  /(.*)\..*/g, "$1" );
				//m_audioPaths.push( { name: name, sound: new Sound(req) } );
			}
			if ( onCompleteCallback != null ) {
				onCompleteCallback();
			}
		}
		
		public function GetAudio( index:int ):Sound {
			return m_audioPaths[index].sound;
		}
		
		static public function get instance():snd_manager { return sm_instance = sm_instance ? sm_instance : new snd_manager( new privateclass() ); }
	}
}

class privateclass{}