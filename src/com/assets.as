package com
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/*========================================================================================
	ASSETS EMBED HERE
	========================================================================================*/
	public class assets
	{
		/*=================
		OVERWORLD
		=================*/
		[Embed(source="../../assets/consolas.fnt", 
			   mimeType="application/octet-stream")]					static private var ConsolassFntCfg	:Class;												
		[Embed(source="../../assets/consolas.png")]						static private var ConsolassFntTex	:Class;
		
		//player atlas
		[Embed(source="../../assets/spritesheet_player.png")] 
		public static const spritesheet_player:Class;
		[Embed(source="../../assets/data_player.xml", mimeType="application/octet-stream")]
		public static const data_player:Class;
		
		private static var textures:Dictionary = new Dictionary();
		private static var atlases:Dictionary = new Dictionary();
		private static var configs:Dictionary = new Dictionary();
		private static var bitmapFonts:Dictionary = new Dictionary();
		
		static public function getSpriteSheet( name:String ):TextureAtlas {
			if ( !atlases[ name ] ) {
				var xml:XML 			= XML( new assets[ "data_"+name ]() );
				var texture:Texture 	= getTexture( "spritesheet_"+name );
				assets[ name ] 			= new TextureAtlas( texture, xml );
				atlases[ name ] 		= assets[ name ];
			}
			return atlases[ name ];
		}
		
		static public function getTexture( name:String ):Texture {
			if ( !textures[ name ] ) {
				var bitmap:Bitmap 	= new assets[ name ]();
				textures[ name ] 	= Texture.fromBitmap( bitmap, false, true );
			}
			return textures[ name ];
		}
		
		static public function getConfig( name:String ):XML {
			if ( !configs[ name ] ) {
				var config:XML = XML( new assets[ name + "Config" ] );
				configs[ name ] = config;
			}
			return configs[ name ];
		}
		
		static public function registerBitmapFont( name:String ):BitmapFont {
			if ( !bitmapFonts[ name ] ) {
				var fontConfig:XML 	= XML( new assets[ name+"FntCfg" ]() );
				var fontTex:Texture	= getTexture( name+"FntTex" );
				bitmapFonts[ name ]	= new BitmapFont( fontTex, fontConfig );
				//TextField.registerBitmapFont( bitmapFonts[ name ] );
			}
			return bitmapFonts[ name ];
		}
	}
}