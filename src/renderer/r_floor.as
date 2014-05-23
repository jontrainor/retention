package renderer
{
	import com.globals;
	
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;

	public class r_floor extends r_collidable
	{
		public function r_floor( type:String="floor" ) {
			super( type );
		}
	}
}