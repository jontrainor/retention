package renderer
{
	import com.globals;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;

	public class r_collidable
	{
		protected var m_width		:Number;
		protected var m_height		:Number;
		protected var m_body		:Body;
		protected var m_position	:Vec2;
		
		/** all collidables are a type, eg. floor, wall, default */
		protected var m_type		:String;
		
		/** New collidable object 
		 * @param type - set to default, wall, or floor
		 */
		public function r_collidable( type:String="default" ) {
			m_position = new Vec2();
			m_type = type;
		}
		
		public function Init():void {
			CreateBody();
		}
		
		protected function CreateBody():void {
			m_body 	= new Body( BodyType.STATIC );
			m_body.shapes.add( new Polygon( Polygon.rect( m_position.x,m_position.y,m_width,m_height ), new Material( 0,0.45 ) ) );
			m_body.space = globals.space;
			m_body.cbTypes.add( globals[ "CB_"+m_type.toUpperCase() ] );
		}
		
		/*========================================================================================
		ANCILLARY
		========================================================================================*/
		public function get width():Number 				{ return m_width; }
		public function get height():Number 			{ return m_height; }
		public function get x():Number 					{ return m_position.x; }
		public function get y():Number 					{ return m_position.y; }
		public function get type():String					{ return m_type; }
		//
		public function set x(value:Number):void 		{ m_position.x = value; }
		public function set y(value:Number):void 		{ m_position.y = value; }
		public function set width(value:Number):void 	{ m_width = value; }
		public function set height(value:Number):void 	{ m_height = value; }
		public function set type(value:String):void		{ m_type = value; }
	}
}