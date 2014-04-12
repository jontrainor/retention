package renderer
{
	import com.globals;

	public class r_camera
	{
		private var m_x			:Number;
		private var m_y			:Number;
		private var m_width		:Number;
		private var m_height	:Number;
		
		private var m_world		:r_thebody
		
		/** singleton */
		static private var sm_instance:r_camera;
		
		public function r_camera( world:r_thebody ) {
			if ( sm_instance ) { throw new Error( "Camera instance already created, use instance property" ); }
			sm_instance = this;
			m_width 	= globals.stageWidth;
			m_height 	= globals.stageHeight;
			m_world 	= world;
		}
		
		/*=============================================================================
		Accessors and Mutators
		=============================================================================*/
		public function get x():Number { return m_x; }
		public function get y():Number { return m_y; }
		public function get width():Number { return m_width; }
		public function get height():Number { return m_height; }
		
		public function set x( value:Number ):void {
			m_x = value;
			m_world.x = -(m_x - m_width/2);
		}
		
		public function set y( value:Number ):void {
			m_y = value;
			m_world.y = -(m_y - m_height/2);
		}
		
		static public function get instance():r_camera { return sm_instance; }
	}
}