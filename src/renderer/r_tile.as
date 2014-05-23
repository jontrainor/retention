package renderer
{
	import com.globals;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class r_tile extends Sprite
	{
		//is it a wall? floor? or passable (default) tile
		private const DEFAULT		:String = "default";
		private const WALL			:String = "wall";
		private const FLOOR			:String = "floor";
		
		//private
		private var m_body			:Body;
		private var m_asset			:Image;
		
		//public
		public var type				:String	= DEFAULT;
		
		public function r_tile( type:String=null ) {
			this.type = type ? type : DEFAULT;
		}
		
		/** Initialize the tile so it creates collisions if needed */
		public function Init():void {
			m_asset = getChildAt( 0 ) as Image;
			if ( type == WALL || type == FLOOR ) { 
				//CreateBody(); 
				//m_body.cbTypes.add( type == WALL ? globals.CB_WALL : globals.CB_FLOOR );
			}
		}
		
		private function CreateBody():void {
			m_body 			= new Body( BodyType.STATIC );
			m_body.shapes.add( new Polygon(Polygon.rect(x,y,m_asset.width,m_asset.height), new Material(0,0.45) ) );
			m_body.space	= globals.space;
			m_body.userData.graphic = this;
			
		}
	}
}