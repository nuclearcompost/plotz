package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	//-----------------------
	//Purpose:				Allow the player to select a fruit type
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class FruitTypePicker extends CustomEventPropertyPicker
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get type():int
		{
			return CustomEventPropertyPicker.TYPE_FRUIT;
		}
		
		public function get fruitType():int
		{
			return _fruitType;
		}
		
		public function set fruitType(value:int):void
		{
			_fruitType = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _fruitType:int;
		private var _gameTime:Time;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function FruitTypePicker(parent:CalendarMenu, viewState:CustomDayEventViewState, fruitType:int, gameTime:Time)
		{
			super(parent, viewState);
			
			_fruitType = fruitType;
			_gameTime = gameTime.GetClone();
		}
		
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function GetGraphics():MovieClip
		{
			var mcPicker:MovieClip = new MovieClip();
			
			var sFruitType:String = "";
			
			var oEvent:DayEvent = _viewState.event;
			
			if (oEvent is CustomHarvestEvent)
			{
				var oCustomHarvestEvent:CustomHarvestEvent = CustomHarvestEvent(oEvent);
				sFruitType = Plant.NAME[oCustomHarvestEvent.fruitType];
			}
			
			var btnHeader:Calendar_FruitTypePicker_Btn = new Calendar_FruitTypePicker_Btn();
			
			UIManager.AssignButtonText(btnHeader, sFruitType);
			
			btnHeader.addEventListener(MouseEvent.CLICK, OnHeaderClick, false, 0, true);
			mcPicker.addChild(btnHeader);
			
			if (_isOpen == true)
			{
				var mcBackground:FruitTypePicker_Background_MC = new FruitTypePicker_Background_MC();
				mcBackground.y = btnHeader.height;
				mcPicker.addChild(mcBackground);
				
				var lY:Array = new Array(Time.MAX_SEASON + 1);
				
				for (var i:int = 0; i < lY.length; i++)
				{
					lY[i] = btnHeader.height;
				}
				
				// get list of non cover crops that can be grown in the amount of time between the current game time and the date the picker's event is on
				var iNumDays = TimeService.GetNumDaysBetween(_gameTime, _viewState.event.time);
				var lGrowablePlantTypes:Array = PlantService.GetNonCoverPlantTypesGrowableInTime(iNumDays);
				
				for (i = 0; i < lGrowablePlantTypes.length; i++)
				{
					var iFruitType:int = int(lGrowablePlantTypes[i]);
					
					var iSeason:int = Plant.GetPreferredSeason(iFruitType);
					
					var mcOption:PlantTypePicker_Option_MC = new PlantTypePicker_Option_MC();
					mcOption.x = iSeason * mcOption.width;
					mcOption.y = lY[iSeason];
					lY[iSeason] += mcOption.height;
					mcOption.Message.text = String(Plant.NAME[iFruitType]);
					mcOption.fruitType = iFruitType;
					mcOption.addEventListener(MouseEvent.CLICK, OnFruitTypeOptionClick, false, 0, true);
					mcOption.addEventListener(MouseEvent.ROLL_OUT, OnFruitTypeOptionRollOut, false, 0, true);
					mcOption.addEventListener(MouseEvent.ROLL_OVER, OnFruitTypeOptionRollOver, false, 0, true);
					mcPicker.addChild(mcOption);
				}
			}
			
			return mcPicker;
		}
		
		public override function GetHeaderWidth():int
		{
			var btnHeader:Calendar_FruitTypePicker_Btn = new Calendar_FruitTypePicker_Btn();
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
			
			var bCanGrowAPlant:Boolean = false;
			
			for (var i:int = 0; i < Plant.NAME.length; i++)
			{
				var iClass:int = Plant.GetClass(i);
				
				if (iClass == Plant.CLASS_COVER)
				{
					continue;
				}
				
				var iDaysToHarvest = Plant.GetDaysToHarvest(i);
				
				if (iDaysToHarvest <= iDaysBetween)
				{
					bCanGrowAPlant = true;
					break;
				}
			}
			
			return bCanGrowAPlant;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function OnFruitTypeOptionClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_isOpen = false;
			
			if (_fruitType != event.currentTarget.fruitType)
			{
				_fruitType = event.currentTarget.fruitType;
				CustomDayEventService.UpdateEventValueFromPicker(_viewState.event, this);
			}
			
			_parent.Repaint();
		}
		
		private function OnFruitTypeOptionRollOut(event:MouseEvent):void
		{
			event.stopPropagation();
			
			event.currentTarget.gotoAndStop(1);
		}
		
		private function OnFruitTypeOptionRollOver(event:MouseEvent):void
		{
			event.stopPropagation();
			
			event.currentTarget.gotoAndStop(2);
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(FruitTypePicker.IsValidFalseIfGameTimeNull());
			lResults.push(FruitTypePicker.IsValidFalseIfCheckTimeNull());
			lResults.push(FruitTypePicker.IsValidFalseForPast());
			lResults.push(FruitTypePicker.IsValidFalseIfNoPlantsCanBeGrown());
			lResults.push(FruitTypePicker.IsValidTrueIfOneOrMorePlantsCanBeGrown());
			
			return lResults;
		}
		
		private static function IsValidFalseIfGameTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FruitTypePicker", "IsValidFalseIfGameTimeNull");
			var oGameTime:Time = null;
			var oCheckTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.TestFalse(FruitTypePicker.IsValid(oGameTime, oCheckTime));
			
			return oResult;
		}
		
		private static function IsValidFalseIfCheckTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FruitTypePicker", "IsValidFalseIfCheckTimeNull");
			var oGameTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCheckTime:Time = null;
			
			oResult.TestFalse(FruitTypePicker.IsValid(oGameTime, oCheckTime));
			
			return oResult;
		}
		
		private static function IsValidFalseForPast():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FruitTypePicker", "IsValidFalseForPast");
			var oGameTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			var oCheckTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.TestFalse(FruitTypePicker.IsValid(oGameTime, oCheckTime));
			
			return oResult;
		}
		
		private static function IsValidFalseIfNoPlantsCanBeGrown():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FruitTypePicker", "IsValidFalseIfNoPlantsCanBeGrown");
			var oGameTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			var oCheckTime:Time = new Time(0, 3, 0, 0, 3, 0, false);
			
			oResult.TestFalse(FruitTypePicker.IsValid(oGameTime, oCheckTime));
			
			return oResult;
		}
		
		private static function IsValidTrueIfOneOrMorePlantsCanBeGrown():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FruitTypePicker", "IsValidTrueIfOneOrMorePlantsCanBeGrown");
			var oGameTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCheckTime:Time = new Time(0, 9, 0, 0, 2, 0, false);
			
			oResult.TestTrue(FruitTypePicker.IsValid(oGameTime, oCheckTime));
			
			return oResult;
		}
		
		/*
		
		private static function ():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FruitTypePicker", "");
			
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