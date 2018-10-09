package
{
	//-----------------------
	//Purpose:				A calendar event the user can add and modify at will
	//
	//Properties:
	//	
	//Methods:
	//	
	//Extended By:
	//	CustomHarvestEvent
	//	CustomPlantEvent
	//
	//-----------------------
	public class CustomDayEvent extends DayEvent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CustomDayEvent(time:Time = null, occurrences:int = 1)
		{
			super(time, occurrences);
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		// override in each child class
		public function BuildLinkedEvents():Array
		{
			trace("CustomDayEvent BuildLinkedEvents method called");
			return null;
		}
		
		// override in each child class
		public function ForceToValidValues(gameTime:Time):void
		{
			trace("CustomDayEvent ForceToValidValues method called");
			return;
		}
		
		// override in each child class
		public function GetLinkedEvents():Array
		{
			trace("CustomDayEvent GetLinkedEvents method called");
			return new Array();
		}
		
		// override in each child class
		public function GetPickerTypes():Array
		{
			trace("CustomDayEvent GetPickerTypes method called");
			return new Array();
		}
		
		public static function GetValidTypes(gameTime:Time, checkTime:Time):Array
		{
			var lValidTypes:Array = new Array();
			
			if (CustomHarvestEvent.IsValid(gameTime, checkTime) == true)
			{
				lValidTypes.push(DayEvent.TYPE_CUSTOM_HARVEST);
			}
			
			if (CustomPlantEvent.IsValid(gameTime, checkTime) == true)
			{
				lValidTypes.push(DayEvent.TYPE_CUSTOM_PLANT);
			}
			
			return lValidTypes;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(CustomDayEvent.GetValidTypesReturnsNone());
			lResults.push(CustomDayEvent.GetValidTypesReturnsOne());
			lResults.push(CustomDayEvent.GetValidTypesReturnsMultiple());
			
			return lResults;
		}
		
		private static function GetValidTypesReturnsNone():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEvent", "GetValidTypesReturnsNone");
			var oGameTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			var oCheckTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.expected = "0";
			
			var lActual:Array = CustomDayEvent.GetValidTypes(oGameTime, oCheckTime);
			oResult.actual = String(lActual.length);
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetValidTypesReturnsOne():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEvent", "GetValidTypesReturnsOne");
			var oGameTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			var oCheckTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			
			oResult.expected = "[ " + String(DayEvent.TYPE_CUSTOM_PLANT) + " ]";
			
			var lActual:Array = CustomDayEvent.GetValidTypes(oGameTime, oCheckTime);
			
			oResult.actual = "[ ";
			
			for (var i:int = 0; i < lActual.length; i++)
			{
				oResult.actual += (String(lActual[i]) + " ");
			}
			
			oResult.actual += "]";
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetValidTypesReturnsMultiple():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEvent", "GetValidTypesReturnsMultiple");
			var oGameTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			var oCheckTime:Time = new Time(0, 9, 0, 0, 2, 0, false);
			
			oResult.expected = "[ " + String(DayEvent.TYPE_CUSTOM_HARVEST) + " " + String(DayEvent.TYPE_CUSTOM_PLANT) + " ]";
			
			var lActual:Array = CustomDayEvent.GetValidTypes(oGameTime, oCheckTime);
			
			oResult.actual = "[ ";
			
			for (var i:int = 0; i < lActual.length; i++)
			{
				oResult.actual += (String(lActual[i]) + " ");
			}
			
			oResult.actual += "]";
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		/*
		
		private static function ():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEvent", "");
			
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