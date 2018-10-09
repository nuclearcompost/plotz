package
{
	import flash.display.MovieClip;
	
	public class Terrain
	{
		// Constants //
		public static const TYPE_PAVEMENT:int = 0;
		
		// Public Properties //
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}
		
		//* Public Properties *//
		
		
		// Private Properties //
		private var _type:int;
		
		//* Private Properties *//
		
	
		// Initialization //
		public function Terrain(type:int = 0)
		{
			_type = type;
		}
	
		//* Initialization *//
		
		
		// Public Methods //
		
		public function GetPreviewGraphics():MovieClip
		{
			var oGraphics:MovieClip = new MovieClip();
			return oGraphics;
		}
		
		public function Paint():MovieClip
		{
			var oGraphics:Terrain_MC = new Terrain_MC();
			
			oGraphics.gotoAndStop(_type + 1);
			
			return oGraphics;
		}
		
		//* Public Methodes *//
		
		// Protected Methods:
	}
	
}