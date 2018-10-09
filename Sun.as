package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class Sun
	{
		// Constants //
		
		public static const TYPE_NORMAL:int = 0;
		public static const TYPE_HOT:int = 1;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get pixelLocation():PixelLocation
		{
			return _pixelLocation;
		}
		
		public function set pixelLocation(value:PixelLocation):void
		{
			_pixelLocation = value;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _pixelLocation:PixelLocation;
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Sun(type:int = 0, pixelLocation:PixelLocation = null)
		{
			_type = type;
			_pixelLocation = pixelLocation;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function Paint():MovieClip
		{
			var mcSun:MovieClip = new MovieClip();
			
			if (_type == Sun.TYPE_NORMAL)
			{
				mcSun = new Weather_Sun_MC();
			}
			else if (_type == Sun.TYPE_HOT)
			{
				mcSun = new Weather_StrongSun_MC();
			}
			
			return mcSun;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}