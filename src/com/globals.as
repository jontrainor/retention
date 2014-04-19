package com
{
	import flash.display.BitmapData;
	
	import game.g_entity;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.textures.Texture;

	public class globals
	{
		/*===============
		PRIVATE
		===============*/
		static private var m_stageWidth		:int;
		static private var m_stageHeight	:int;
		static private var m_instance		:globals;
		static private var m_fade			:Image;
		
		/*===============
		PUBLIC
		===============*/
		static public var stageHalfWidth	:Number;
		static public var stageHalfHeight	:Number;
		static public var background		:Sprite;
		static public var midground			:Sprite;
		static public var foreground		:Sprite;
		static public var overlay			:Sprite;
		static public var player			:g_entity;
		
		/*===============
		CONSTANTS
		===============*/
		static public const MENU			:String = "menu";
		static public const GAME			:String = "game";
		static public const RESET			:String = "reset";
		static public const GAME_OVER		:String = "over";
		static public const GAME_OVERWORLD	:String = "overworld";
		static public const READY			:String = "ready";
		static public const LOADING			:String = "loading";
		
		public function globals():void {
			if ( m_instance ) { echo( "!!Warning!! --> There can only be one globals instance. It's created from Retention." ); return; }
			m_instance = this;
		}
		
		/** Creates the sprites used for layering
		 * creates: background, midground, foreground, and overlay */
		static public function CreateLayers( stage:Stage ):void {
			overlay 	= new Sprite(); overlay.name 	= "overlay";
			midground 	= new Sprite(); midground.name 	= "midground";
			foreground 	= new Sprite(); foreground.name = "foreground";
			background 	= new Sprite(); background.name = "background";
			
			stage.addChild( background );
			stage.addChild( midground );
			stage.addChild( foreground );
			stage.addChild( overlay );
			
			CreateFade();
		}
		
		/** Create the fade texture */
		static private function CreateFade():void {
			var bmd:BitmapData = new BitmapData( stageWidth, stageHeight );
			bmd.fillRect( bmd.rect, 0xFF000000 );
			
			var t:Texture = Texture.fromBitmapData( bmd );
			m_fade = new Image( t );
			//turn off visability and prep for fading
			//m_fade.visible = false;
			//m_fade.alpha = 0;
			overlay.addChild( m_fade );
		}
		
		/** Debugging, trace statements with class information */
		static public function echo( val:* ):void {
			var stack:Error = new Error();
			var log:String = stack.getStackTrace().split( "\n" )[2];
			var c:String = log.replace(/.*\\([a-zA-z0-9_]+).as.*/g, "$1");
			trace( c+" --> " + val ); 
		}
		
		static public function FadeOut( time:int=3 ):void {
			m_fade.alpha = 0;
			m_fade.visible = true;
			var tween:Tween = new Tween( m_fade, time );
			tween.animate( "alpha", 1 );
			Starling.juggler.add( tween );
		}
		
		static public function FadeIn( time:int=3 ):void {
			m_fade.alpha = 1;
			m_fade.visible = true;
			Starling.juggler.tween( m_fade, time, {
				alpha:0,
				onComplete: function():void { m_fade.visible = false; }
			});
		}
		
		/*=============================================================================
		Accessors and Mutators
		=============================================================================*/
		static public function set stageWidth( val:int ):void { m_stageWidth = val; stageHalfWidth = val * 0.5; }
		static public function set stageHeight( val:int ):void { m_stageHeight = val; stageHalfHeight = val * 0.5; }
		
		static public function get stageWidth():int { return m_stageWidth; }
		static public function get stageHeight():int { return m_stageHeight; }
	}
}