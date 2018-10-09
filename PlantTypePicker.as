package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	//-----------------------
	//Purpose:				Allow the player to select a plant type
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class PlantTypePicker extends CustomEventPropertyPicker
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get type():int
		{
			return CustomEventPropertyPicker.TYPE_PLANT;
		}
		
		public function get plantType():int
		{
			return _plantType;
		}
		
		public function set plantType(value:int):void
		{
			_plantType = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _plantType:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function PlantTypePicker(parent:CalendarMenu, viewState:CustomDayEventViewState, plantType:int)
		{
			super(parent, viewState);
			
			_plantType = plantType;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function GetGraphics():MovieClip
		{
			var mcPicker:MovieClip = new MovieClip();
			
			var sPlantType:String = "";
			
			var oEvent:DayEvent = _viewState.event;
			
			if (oEvent is CustomPlantEvent)
			{
				var oCustomPlantEvent:CustomPlantEvent = CustomPlantEvent(oEvent);
				sPlantType = Plant.NAME[oCustomPlantEvent.plantType];
			}
			
			var btnHeader:Calendar_PlantTypePicker_Btn = new Calendar_PlantTypePicker_Btn();
			
			UIManager.AssignButtonText(btnHeader, sPlantType);
			
			btnHeader.addEventListener(MouseEvent.CLICK, OnHeaderClick, false, 0, true);
			mcPicker.addChild(btnHeader);
			
			if (_isOpen == true)
			{
				var lY:Array = new Array(Time.MAX_SEASON + 1);
				
				for (var i:int = 0; i < lY.length; i++)
				{
					lY[i] = btnHeader.height;
				}
				
				for (i = 0; i < Plant.NAME.length; i++)
				{
					if (Plant.GetClass(i) == Plant.CLASS_COVER)
					{
						continue;
					}
					
					var iSeason:int = Plant.GetPreferredSeason(i);
					
					var mcOption:PlantTypePicker_Option_MC = new PlantTypePicker_Option_MC();
					mcOption.x = iSeason * mcOption.width;
					mcOption.y = lY[iSeason];
					lY[iSeason] += mcOption.height;
					mcOption.Message.text = String(Plant.NAME[i]);
					mcOption.plantType = i;
					mcOption.addEventListener(MouseEvent.CLICK, OnPlantTypeOptionClick, false, 0, true);
					mcOption.addEventListener(MouseEvent.ROLL_OUT, OnPlantTypeOptionRollOut, false, 0, true);
					mcOption.addEventListener(MouseEvent.ROLL_OVER, OnPlantTypeOptionRollOver, false, 0, true);
					mcPicker.addChild(mcOption);
				}
			}
			
			return mcPicker;
		}
		
		public override function GetHeaderWidth():int
		{
			var btnHeader:Calendar_PlantTypePicker_Btn = new Calendar_PlantTypePicker_Btn();
			var iWidth:int = btnHeader.width;
			
			return iWidth;
		}
		
		public static function IsValid(gameTime:Time, checkTime:Time):Boolean
		{
			if (gameTime == null || checkTime == null)
			{
				return false;
			}
			
			var iDaysBetween:int = TimeService.GetNumDaysBetween(gameTime, checkTime);
			
			if (iDaysBetween >= 0)
			{
				return true;
			}
			
			return false;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function OnPlantTypeOptionClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_isOpen = false;
			
			if (_plantType != event.currentTarget.plantType)
			{
				_plantType = event.currentTarget.plantType;
				CustomDayEventService.UpdateEventValueFromPicker(_viewState.event, this);
			}
			
			_parent.Repaint();
		}
		
		private function OnPlantTypeOptionRollOut(event:MouseEvent):void
		{
			event.stopPropagation();
			
			event.currentTarget.gotoAndStop(1);
		}
		
		private function OnPlantTypeOptionRollOver(event:MouseEvent):void
		{
			event.stopPropagation();
			
			event.currentTarget.gotoAndStop(2);
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(PlantTypePicker.IsValidFalseIfGameTimeNull());
			lResults.push(PlantTypePicker.IsValidFalseIfCheckTimeNull());
			lResults.push(PlantTypePicker.IsValidFalseForPast());
			lResults.push(PlantTypePicker.IsValidTrueForPresent());
			lResults.push(PlantTypePicker.IsValidTrueForFuture());
			
			return lResults;
		}
		
		private static function IsValidFalseIfGameTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantTypePicker", "IsValidFalseIfGameTimeNull");
			var oGameTime:Time = null;
			var oCheckTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.TestFalse(PlantTypePicker.IsValid(oGameTime, oCheckTime));
			
			return oResult;
		}
		
		private static function IsValidFalseIfCheckTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantTypePicker", "IsValidFalseIfCheckTimeNull");
			var oGameTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCheckTime:Time = null;
			
			oResult.TestFalse(PlantTypePicker.IsValid(oGameTime, oCheckTime));
			
			return oResult;
		}
		
		private static function IsValidFalseForPast():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantTypePicker", "IsValidFalseForPast");
			var oGameTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			var oCheckTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.TestFalse(PlantTypePicker.IsValid(oGameTime, oCheckTime));
			
			return oResult;
		}
		
		private static function IsValidTrueForPresent():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantTypePicker", "IsValidTrueForPresent");
			var oGameTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			var oCheckTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			
			oResult.TestTrue(PlantTypePicker.IsValid(oGameTime, oCheckTime));
			
			return oResult;
		}
		
		private static function IsValidTrueForFuture():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantTypePicker", "IsValidTrueForFuture");
			var oGameTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCheckTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			
			oResult.TestTrue(PlantTypePicker.IsValid(oGameTime, oCheckTime));
			
			return oResult;
		}
		
		/*
		
		private static function ():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantTypePicker", "");
			
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