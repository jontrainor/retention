package com
{
	import starling.display.Sprite;
	import starling.display.Stage;

	public class globals
	{
		/*===============
		PRIVATE
		===============*/
		static private var m_stageWidth		:int;
		static private var m_stageHeight	:int;
		static private var m_instance		:globals;
		
		/*===============
		PUBLIC
		===============*/
		static public var stageHalfWidth	:Number;
		static public var stageHalfHeight	:Number;
		static public var background		:Sprite;
		static public var midground			:Sprite;
		static public var foreground		:Sprite;
		static public var overlay			:Sprite;
		
		/*===============
		CONSTANTS
		===============*/
		static public const MENU			:String = "menu";
		static public const GAME			:String = "game";
		static public const RESET			:String = "reset";
		static public const GAME_OVER		:String = "over";
		static public const GAME_OVERWORLD	:String = "overworld";
		
		public function globals():void {
			if ( m_instance ) { echo( "!!Warning!! --> There can only be one globals instance. It's created from Retention." ); return; }
			m_instance = this;
		}
		
		static public function CreateLayers( stage:Stage ):void {
			overlay 	= new Sprite(); overlay.name 	= "overlay";
			midground 	= new Sprite(); midground.name 	= "midground";
			foreground 	= new Sprite(); foreground.name = "foreground";
			background 	= new Sprite(); background.name = "background";
			
			stage.addChild( background );
			stage.addChild( midground );
			stage.addChild( foreground );
			stage.addChild( overlay );
		}
		
		static public function echo( val:* ):void {
			var stack:Error = new Error();
			var log:String = stack.getStackTrace().split( "\n" )[2];
			var c:String = log.replace(/.*\\([a-zA-z0-9_]+).as.*/g, "$1");
			trace( c+" --> " + val ); 
		}
		
		/** SETTERS */
		static public function set stageWidth( val:int ):void { m_stageWidth = val; stageHalfWidth = val * 0.5; }
		static public function set stageHeight( val:int ):void { m_stageHeight = val; stageHalfHeight = val * 0.5; }
		
		/** GETTERS */
		static public function get stageWidth():int { return m_stageWidth; }
		static public function get stageHeight():int { return m_stageHeight; }
	}
}