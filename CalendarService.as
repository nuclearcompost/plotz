package
{
	//-----------------------
	//Purpose:				Service logic for the Calendar tool
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class CalendarService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CalendarService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function GetDefaultCustomEvent(time:Time):CustomDayEvent
		{
			var iPlantType:int = Plant.TYPE_ASPARAGUS;
			
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			if (time != null)
			{
				oTime = time.GetClone();
			}
			
			var oDefaultEvent:CustomPlantEvent = new CustomPlantEvent(iPlantType, oTime, 1);
			
			return oDefaultEvent;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(CalendarService.GetDefaultCustomEventUsesDefaultTimeIfTimeNull());
			lResults.push(CalendarService.GetDefaultCustomEventReturnsCorrectEventType());
			lResults.push(CalendarService.GetDefaultCustomEventReturnsCorrectTime());
			lResults.push(CalendarService.GetDefaultCustomEventReturnsCorrectOccurrences());
			
			return lResults;
		}
		
		private static function GetDefaultCustomEventUsesDefaultTimeIfTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarService", "GetDefaultCustomEventUsesDefaultTimeIfTimeNull");
			var oTime:Time = null;
			var oExpectedTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			var oEvent:CustomDayEvent = CalendarService.GetDefaultCustomEvent(oTime);
			
			oResult.TestTrue(oEvent.time.IsSameDay(oExpectedTime));
			
			return oResult;
		}
		
		private static function GetDefaultCustomEventReturnsCorrectEventType():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarService", "GetDefaultCustomEventReturnsCorrectEventType");
			var oTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			var oEvent:CustomDayEvent = CalendarService.GetDefaultCustomEvent(oTime);
			
			oResult.expected = String(DayEvent.TYPE_CUSTOM_PLANT);
			oResult.actual = String(oEvent.eventType);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetDefaultCustomEventReturnsCorrectTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarService", "GetDefaultCustomEventReturnsCorrectTime");
			var oTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			var oEvent:CustomDayEvent = CalendarService.GetDefaultCustomEvent(oTime);
			
			oResult.TestTrue(oTime.IsSameDay(oEvent.time));
			
			return oResult;
		}
		
		private static function GetDefaultCustomEventReturnsCorrectOccurrences():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarService", "GetDefaultCustomEventReturnsCorrectOccurrences");
			var oTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			var oEvent:CustomDayEvent = CalendarService.GetDefaultCustomEvent(oTime);
			
			oResult.expected = "1";
			oResult.actual = String(oEvent.occurrences);
			oResult.TestEquals();
			
			return oResult;
		}
		
		/*
		
		private static function ():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarService", "");
			
			return oResult;
		}
		
		private static function ():Array
		{
			var lResults:Array = new Array();
			
			return lResults;
		}
		
		*/
		
		//- Testing Methods -//
	}
}