package com
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/*========================================================================================
	ASSETS EMBED HERE
	========================================================================================*/
	public class assets
	{
		/*[Embed(source="../../assets/triggerf.ttf", 
	    fontName = "trigger", 
	    mimeType = "application/x-font",
	    fontStyle="normal",  
	    advancedAntiAliasing="true", 
	    embedAsCFF="false")]
		public static const bitFont:Class;*/
		
		[Embed(source="../../assets/player.png")]
		static private var player:Class;
		
		//player atlas
		/*[Embed(source="../../assets/playerAtlas.png")]
		public static const playerAtlas:Class;
		[Embed(source="../../assets/playerXML.xml", mimeType="application/octet-stream")]
		public static const playerXML:Class;*/
		
		private static var textures:Dictionary = new Dictionary();
		private static var atlases:Dictionary = new Dictionary();
		
		public static function getSS( name:String ):TextureAtlas {
			if ( !atlases[ name ] ) {
				var xml:XML 			= XML( new assets[ name+"XML" ]() );
				var texture:Texture 	= getTexture( name+"Atlas" );
				assets[ name+"Atlas" ] 	= new TextureAtlas( texture, xml );
				atlases[ name ] 		= assets[ name+"Atlas" ];
			}
			return atlases[ name ];
		}
		
		public static function getTexture( name:String ):Texture {
			if ( !textures[ name ] ) {
				var bitmap:Bitmap 	= new assets[ name ]();
				textures[ name ] 	= Texture.fromBitmap( bitmap, false, true );
			}
			return textures[ name ];
		}
	}
}