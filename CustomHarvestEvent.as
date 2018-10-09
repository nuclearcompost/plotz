package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Record event for a planned harvest
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CustomHarvestEvent extends CustomDayEvent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get eventType():int
		{
			return DayEvent.TYPE_CUSTOM_HARVEST;
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
		private var _plantEvent:CustomPlantEvent;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CustomHarvestEvent(fruitType:int = 0, time:Time = null, occurrences:int = 1, plantEvent:CustomPlantEvent = null)
		{
			super(time, occurrences);
			
			_fruitType = fruitType;
			
			_plantEvent = plantEvent;
			if (_plantEvent == null)
			{
				BuildLinkedEvents();
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function BuildLinkedEvents():Array
		{
			var oTime:Time = _time.GetClone();
			var iDaysToHarvest:int = Plant.GetDaysToHarvest(_fruitType);
			
			for (var i:int = 0; i < iDaysToHarvest; i++)
			{
				TimeService.BackUpDate(oTime);
			}
			
			var oPlantEvent:CustomPlantEvent = new CustomPlantEvent(_fruitType, oTime, _occurrences, this);
			_plantEvent = oPlantEvent;
			
			var lLinkedEvents:Array = [ oPlantEvent ];
			
			return lLinkedEvents;
		}
		
		public override function Equals(other:DayEvent):Boolean
		{
			if (!(other is CustomHarvestEvent))
			{
				return false;
			}
			
			var oOther:CustomHarvestEvent = CustomHarvestEvent(other);
			
			if (oOther.fruitType != _fruitType)
			{
				return false;
			}
			
			return true;
		}
		
		public override function ForceToValidValues(gameTime:Time):void
		{
			var iDaysToNewPlantEvent:int = TimeService.GetNumDaysBetween(gameTime, _plantEvent.time);
			
			// if new linked plant event is still in the present or future, we're all good
			if (iDaysToNewPlantEvent >= 0)
			{
				return;
			}
			
			// otherwise, the linked plant event is in the past so our current fruit type is not valid
			//  In this case we'll need to assign a new fruit type to both the harvest and plant events and possible adjust the plant event's date
			
			// Keep in mind that there should be at least one valid fruitType at this point, otherwise the user shouldn't have seen the Harvest option in the EventTypePicker
			
			var iDaysAvailable:int = TimeService.GetNumDaysBetween(gameTime, _time);
			
			for (var i:int = 0; i < Plant.NAME.length; i++)
			{
				var iDaysToHarvest:int = Plant.GetDaysToHarvest(i);
				
				if (iDaysToHarvest <= iDaysAvailable)
				{
					_fruitType = i;
					_plantEvent.plantType = i;
					
					var iHarvestDateValue:int = _time.GetNumericDateValue();
					var iNewPlantDateValue:int = iHarvestDateValue - iDaysToHarvest;
					_plantEvent.time = Time.GetDateFromNumericValue(iNewPlantDateValue, _time.useMonth);
					
					break;
				}
			}
		}
		
		public override function GetIcon():MovieClip
		{
			var mcIcon:MovieClip = new Calendar_EventIcon_MC();
			mcIcon.gotoAndStop(2);
			
			return mcIcon;
		}
		
		public override function GetLinkedEvents():Array
		{
			var lLinkedEvents = new Array();
			
			if (_plantEvent != null)
			{
				lLinkedEvents.push(_plantEvent);
			}
			
			return lLinkedEvents;
		}
		
		public override function GetLongDescription():String
		{
			var sDescription:String = "Harvest " + _occurrences + " " + Plant.NAME[_fruitType];
			
			return sDescription;
		}
		
		public override function GetPickerTypes():Array
		{
			var lPickers:Array = [ CustomEventPropertyPicker.TYPE_QUANTITY, CustomEventPropertyPicker.TYPE_FRUIT ];
			
			return lPickers;
		}
		
		public static function IsValid(gameTime:Time, checkTime:Time):Boolean
		{
			if (NumberPicker.IsValid(gameTime, checkTime) == false)
			{
				return false;
			}
			
			if (FruitTypePicker.IsValid(gameTime, checkTime) == false)
			{
				return false;
			}
			
			return true;
		}
		
		public override function PrettyPrint():String
		{
			var sOutput:String = "CustomHarvestEvent x" + _occurrences + ", fruitType = " + _fruitType;
			
			return sOutput;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}