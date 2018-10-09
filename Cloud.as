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
	public class Cloud
	{
		// Constants //
		
		public static const TYPE_NONE:int = -1;
		public static const TYPE_WHITE:int = 0;
		public static const TYPE_GRAY:int = 1;
		
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
		
		public function get speed():Number
		{
			return _speed;
		}
		
		public function set speed(value:Number):void
		{
			_speed = value;
		}
		
		public function get style():int
		{
			return _style;
		}
		
		public function set style(value:int):void
		{
			_style = value;
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
		private var _speed:Number;
		private var _style:int;
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Cloud(type:int = 0, style:int = 0, pixelLocation:PixelLocation = null, speed:Number = 0.0)
		{
			_type = type;
			_style = style;
			_pixelLocation = pixelLocation;
			_speed = speed;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function Paint():MovieClip
		{
			var mcCloud:MovieClip = new MovieClip();
			
			if (_type == Cloud.TYPE_WHITE)
			{
				mcCloud = new Weather_WhiteCloud_MC();
			}
			else if (_type == Cloud.TYPE_GRAY)
			{
				mcCloud = new Weather_GrayCloud_MC();
			}
			
			mcCloud.gotoAndStop(_style + 1);
			
			return mcCloud;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}