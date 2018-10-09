package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Record event for a day's weather
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class WeatherEvent extends DayEvent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get eventType():int
		{
			return DayEvent.TYPE_WEATHER;
		}
		
		public function get weatherType():int
		{
			return _weatherType;
		}
		
		public function set weatherType(value:int):void
		{
			_weatherType = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _weatherType:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function WeatherEvent(weatherType:int = 0, time:Time = null)
		{
			super(time, 1);
			
			_weatherType = weatherType;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Equals(other:DayEvent):Boolean
		{
			if (!(other is WeatherEvent))
			{
				return false;
			}
			
			var oOther:WeatherEvent = WeatherEvent(other);
			
			if (oOther.weatherType != _weatherType)
			{
				return false;
			}
			
			return true;
		}
		
		public override function GetIcon():MovieClip
		{
			var mcIcon:MovieClip = new Calendar_WeatherIcon_MC();
			mcIcon.gotoAndStop(_weatherType + 1);
			
			return mcIcon;
		}
		
		public override function GetLongDescription():String
		{
			var sDescription:String = "The weather was " + Weather.DESCRIPTION[_weatherType];
			
			return sDescription;
		}
		
		public override function PrettyPrint():String
		{
			var sOutput:String = "WeatherEvent x" + _occurrences + ", _weatherType = " + _weatherType;
			
			return sOutput;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}