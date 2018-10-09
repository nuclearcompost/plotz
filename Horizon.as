package
{
	//-----------------------
	//Purpose:				Contents of everything above the horizon line - sun, clouds, skybox
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class Horizon
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get clouds():Array
		{
			return _clouds;
		}
		
		public function set clouds(value:Array):void
		{
			_clouds = value;
		}
		
		public function get skyboxColor():uint
		{
			return _skyboxColor;
		}
		
		public function set skyboxColor(value:uint):void
		{
			_skyboxColor = value;
		}
		
		public function get sun():Sun
		{
			return _sun;
		}
		
		public function set sun(value:Sun):void
		{
			_sun = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _clouds:Array;
		private var _skyboxColor:uint;
		private var _sun:Sun;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Horizon(skyboxColor:uint = 0x000000, sun:Sun = null, clouds:Array = null)
		{
			_skyboxColor = skyboxColor;
			_sun = sun;
			_clouds = clouds;
			
			if (_clouds == null)
			{
				_clouds = new Array();
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function SetUpForWeather(weather:int, time:int = 0):void
		{
			// set skyboxColor based on weather
			if (weather == Weather.TYPE_RAIN || weather == Weather.TYPE_STORM)
			{
				_skyboxColor = 0xAAAAAA;
			}
			else if (weather == Weather.TYPE_CLOUD)
			{
				_skyboxColor = 0x6699CC;
			}
			else
			{
				_skyboxColor = 0x3333FF;
			}
			
			// set sun type based on weather
			var oStartLocation:PixelLocation = PixelLocation.GetPointAtDistanceInDirection(new PixelLocation(360, 400), 400, 220 + time);
			_sun = null;
			if (weather == Weather.TYPE_HOT)
			{
				_sun = new Sun(Sun.TYPE_HOT, oStartLocation);
			}
			else if (weather == Weather.TYPE_CLOUD || weather == Weather.TYPE_SUN)
			{
				_sun = new Sun(Sun.TYPE_NORMAL, oStartLocation);
			}
			
			// create some new clouds based on weather
			_clouds = new Array();
			
			var iCloudType:int = Cloud.TYPE_NONE;
			
			if (weather == Weather.TYPE_CLOUD)
			{
				iCloudType = Cloud.TYPE_WHITE;
				
				var iNumClouds:int = Math.floor(Math.random() * 10) + 2;
				
				for (var i:int = 0; i < iNumClouds; i++)
				{
					var iCloudStyle:int = 0;  // TODO: this will be one of several values when there's different types of clouds
					var iCloudX:int = Math.floor(Math.random() * (UIManager.SCREEN_PIXEL_WIDTH + 200)) - 100;
					var iCloudY:int = Math.floor(Math.random() * (UIManager.HORIZON_PIXEL_HEIGHT - 20)) - 40;
					var oCloudLocation:PixelLocation = new PixelLocation(iCloudX, iCloudY);
					var nCloudSpeed:Number = 1 / (Math.floor(Math.random() * 3) + 3);
					
					_clouds[i] = new Cloud(iCloudType, iCloudStyle, oCloudLocation, nCloudSpeed);
				}
			}
			else if (weather == Weather.TYPE_RAIN || weather == Weather.TYPE_STORM)
			{
				iCloudType = Cloud.TYPE_GRAY;
				
				var iX:int = -40;
				
				while (iX < UIManager.SCREEN_PIXEL_WIDTH)
				{
					iCloudStyle = 0;  // TODO: this will be one of several values when there's different types of clouds
					iCloudY = Math.floor(Math.random() * 30) - 65;  // -65 thru -35 == -50 +- 15
					
					_clouds[_clouds.length] = new Cloud(iCloudType, iCloudStyle, new PixelLocation(iX, iCloudY), 0);
					
					iX += (Math.floor(Math.random() * 30) + 105);  // 105 thru 135 == 120 +- 15
				}
			}
		}
		
		public function Update(time:Number):void
		{
			// move sun
			if (_sun != null)
			{
				_sun.pixelLocation = PixelLocation.GetPointAtDistanceInDirection(new PixelLocation(360, 400), 400, 220 + time);
			}
			
			// move clouds
			if (_clouds != null)
			{
				for (var i:int = 0; i < _clouds.length; i++)
				{
					var oCloud:Cloud = Cloud(_clouds[i]);
					oCloud.pixelLocation.x += oCloud.speed;
					
					// loop back around
					if (oCloud.pixelLocation.x > (UIManager.SCREEN_PIXEL_WIDTH + 100))
					{
						oCloud.pixelLocation.x -200;
					}
				}
			}
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}