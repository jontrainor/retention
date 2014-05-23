package game
{
	import com.globals;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	
	/*========================================================================================
	g_player is the super for g_bodyPlayer and g_puzzlePlayer
	========================================================================================*/
	public class g_player extends g_entity
	{	
		protected var m_state		:g_playerstate;
		public var m_body			:Body;
		
		protected var SPEED			:Number = 3;
		protected const MAX_SPEED	:int 	= 400;
		protected const JUMP_HEIGHT	:int	= -500;
		
		public function g_player(
			parent				:DisplayObjectContainer, 
			asset				:String, 
			isSpriteSheet		:Boolean = false, 
			defaultFrames		:int = 120 ) {
			
			//////////////////////////////////
			m_speed = 0;			
			super(parent, asset, isSpriteSheet, defaultFrames);
		}
		
		override protected function SetDefaults():void {
			m_state 		= new g_playerstate( this );
			globals.player 	= this;
			m_body 			= new Body( BodyType.DYNAMIC, new Vec2( x,y ) );
			
			m_body.shapes.add( new Polygon(Polygon.rect(x,y,asset.width,asset.height), new Material(0, 0.55, 1, 1 ) ) );
			m_body.space	= globals.space;
			m_body.allowRotation = false;
			m_body.cbTypes.add( globals.CB_PLAYER );
			
			super.SetDefaults();
		}
		
		override public function Init():void {
			m_state.Init();
			var m_interactListen:InteractionListener = new InteractionListener( CbEvent.BEGIN, 
																				InteractionType.COLLISION, 
																				globals.CB_FLOOR, 
																				globals.CB_PLAYER, 
																				m_state.HandleFloorCollision );
			globals.space.listeners.add( m_interactListen );
			g_dispatcher.instance.AddToDispatch( Update );
		}
		
		override public function Update( elapsedTime:Number=NaN ):void {
			asset.x = m_body.position.x;
			asset.y = m_body.position.y;
			asset.rotation = m_body.rotation;
		}
		
		/** Move in +/- x direction 
		 * @param direction - pass either -1, 1, 0
		 * */
		public function Move( direction:int, elapsedTime:Number ):void {
			m_body.velocity.x = m_body.velocity.x + (SPEED * direction * elapsedTime);
			
			if ( Math.abs(m_body.velocity.x) >= MAX_SPEED ) {
				m_body.velocity.x = MAX_SPEED * direction;
			}
			//trace( "VELOCITY: " + m_body.velocity.x);
		}
		
		public function Jump():void {
			m_body.gravMass = 1.2;
			m_body.velocity.y = JUMP_HEIGHT;
			//m_body.applyImpulse( impulse );
		}
		
		override public function set x(value:Number):void {
			m_body.position.x = value;
			asset.x = value;
		}
		
		override public function set y(value:Number):void {
			m_body.position.y = value;
			asset.y = value;
		}
	}
}