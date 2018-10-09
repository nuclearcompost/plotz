package
{
	//-----------------------
	//Purpose:				Handle displaying and manipulating a CustomDayEvent when on the Calendar menu's day mode
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CustomDayEventViewState
	{
		// Constants //
		
		public static const MODE_READ:int = 0;
		public static const MODE_EDIT:int = 1;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get event():CustomDayEvent
		{
			return _event;
		}
		
		public function set event(value:CustomDayEvent):void
		{
			_event = value;
		}
		
		public function get mode():int
		{
			return _mode;
		}
		
		public function set mode(value:int):void
		{
			_mode = value;
		}
		
		public function get pickers():Array
		{
			return _pickers;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _event:CustomDayEvent;
		private var _mode:int;
		private var _pickers:Array;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CustomDayEventViewState(event:CustomDayEvent = null, mode:int = 0)
		{
			_event = event;
			_mode = mode;
			
			_pickers = new Array();
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function SetPickers(parent:CalendarMenu, eventTypePicker:EventTypePicker, gameTime:Time):void
		{
			_pickers = new Array();
			
			_pickers.push(eventTypePicker);
			
			var lEventSpecificPickerTypes:Array = _event.GetPickerTypes();
			
			for (var i:int = 0; i < lEventSpecificPickerTypes.length; i++)
			{
				var iType:int = lEventSpecificPickerTypes[i];
				
				_pickers.push(PickerFactory.BuildPicker(iType, parent, this, gameTime));
			}
		}
		
		public function ToggleMode():void
		{
			if (_mode == CustomDayEventViewState.MODE_READ)
			{
				_mode = CustomDayEventViewState.MODE_EDIT;
				return;
			}
			
			_mode = CustomDayEventViewState.MODE_READ;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(CustomDayEventViewState.ToggleModeReadToEdit());
			lResults.push(CustomDayEventViewState.ToggleModeEditToRead());
			
			return lResults;
		}
		
		private static function ToggleModeReadToEdit():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventViewState", "ToggleModeReadToEdit");
			var oViewState:CustomDayEventViewState = new CustomDayEventViewState();
			oViewState.mode = CustomDayEventViewState.MODE_READ;
			
			oViewState.ToggleMode();
			
			oResult.expected = String(CustomDayEventViewState.MODE_EDIT);
			oResult.actual = String(oViewState.mode);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ToggleModeEditToRead():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventViewState", "ToggleModeEditToRead");
			var oViewState:CustomDayEventViewState = new CustomDayEventViewState();
			oViewState.mode = CustomDayEventViewState.MODE_EDIT;
			
			oViewState.ToggleMode();
			
			oResult.expected = String(CustomDayEventViewState.MODE_READ);
			oResult.actual = String(oViewState.mode);
			oResult.TestEquals();
			
			return oResult;
		}
		
		/*
		
		private static function ():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventViewState", "");
			
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