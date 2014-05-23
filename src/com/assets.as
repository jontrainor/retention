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
		[Embed(source="../../assets/player.png")] 			static private var player			:Class;
		[Embed(source="../../assets/particle.png")] 		static private var particle			:Class;
		[Embed(source="../../assets/particle.pex",  
			   mimeType="application/octet-stream")]		static private var particleConfig	:Class;
		[Embed(source="../../assets/background.png")] 		static private var background		:Class;
		[Embed(source="../../assets/midground.png")] 		static private var midground		:Class;
		[Embed(source="../../assets/foreground.png")]		static private var foreground		:Class;
		
		/*=================
		PUZZLE
		=================*/
		[Embed(source="../../assets/puzzle/floor.png")]		static private var floor			:Class;
		[Embed(source="../../assets/puzzle/wall.png")]		static private var wall				:Class;
		[Embed(source="../../assets/puzzle/node.png")]		static private var node				:Class;
		[Embed(source="../../assets/puzzle/player.png")]	static private var puzzleplayer		:Class;
		[Embed(source="../../assets/consolas.fnt", 
			   mimeType="application/octet-stream")]		static private var ConsolassFntCfg	:Class;												
		[Embed(source="../../assets/consolas.png")]			static private var ConsolassFntTex	:Class;
		
		//player atlas
		/*[Embed(source="../../assets/playerAtlas.png")]
		public static const playerAtlas:Class;
		[Embed(source="../../assets/playerXML.xml", mimeType="application/octet-stream")]
		public static const playerXML:Class;*/
		
		private static var textures:Dictionary = new Dictionary();
		private static var atlases:Dictionary = new Dictionary();
		private static var configs:Dictionary = new Dictionary();
		private static var bitmapFonts:Dictionary = new Dictionary();
		
		static public function getSS( name:String ):TextureAtlas {
			if ( !atlases[ name ] ) {
				var xml:XML 			= XML( new assets[ name+"XML" ]() );
				var texture:Texture 	= getTexture( name+"Atlas" );
				assets[ name+"Atlas" ] 	= new TextureAtlas( texture, xml );
				atlases[ name ] 		= assets[ name+"Atlas" ];
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