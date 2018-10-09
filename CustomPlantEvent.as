package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Record event for planning to plant a seed
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CustomPlantEvent extends CustomDayEvent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get eventType():int
		{
			return DayEvent.TYPE_CUSTOM_PLANT;
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
		
		private var _harvestEvent:CustomHarvestEvent;
		private var _plantType:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CustomPlantEvent(plantType:int = 0, time:Time = null, occurrences:int = 1, harvestEvent:CustomHarvestEvent = null)
		{
			super(time, occurrences);
			
			_plantType = plantType;
			
			_harvestEvent = harvestEvent;
			if (_harvestEvent == null)
			{
				BuildLinkedEvents();
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function BuildLinkedEvents():Array
		{
			var oTime:Time = _time.GetClone();
			var iDaysToHarvest:int = Plant.GetDaysToHarvest(_plantType);
			
			for (var i:int = 0; i < iDaysToHarvest; i++)
			{
				TimeService.AdvanceDate(oTime);
			}
			
			var oHarvestEvent:CustomHarvestEvent = new CustomHarvestEvent(_plantType, oTime, _occurrences, this);
			_harvestEvent = oHarvestEvent;
			
			var lLinkedEvents:Array = [ oHarvestEvent ];
			
			return lLinkedEvents;
		}
		
		public override function Equals(other:DayEvent):Boolean
		{
			if (!(other is CustomPlantEvent))
			{
				return false;
			}
			
			var oOther:CustomPlantEvent = CustomPlantEvent(other);
			
			if (oOther.plantType != _plantType)
			{
				return false;
			}
			
			return true;
		}
		
		public override function ForceToValidValues(gameTime:Time):void
		{
			// any custom harvest event values are also valid custom plant event values, so there's nothing to do here
			return;
		}
		
		public override function GetIcon():MovieClip
		{
			var mcIcon:MovieClip = new Calendar_EventIcon_MC();
			mcIcon.gotoAndStop(1);
			
			return mcIcon;
		}
		
		public override function GetLinkedEvents():Array
		{
			var lLinkedEvents = new Array();
			
			if (_harvestEvent != null)
			{
				lLinkedEvents.push(_harvestEvent);
			}
			
			return lLinkedEvents;
		}
		
		public override function GetLongDescription():String
		{
			var sDescription:String = "Plant " + _occurrences + " " + Plant.NAME[_plantType];
			
			return sDescription;
		}
		
		public override function GetPickerTypes():Array
		{
			var lPickers:Array = [ CustomEventPropertyPicker.TYPE_QUANTITY, CustomEventPropertyPicker.TYPE_PLANT ];
			
			return lPickers;
		}
		
		public static function IsValid(gameTime:Time, checkTime:Time):Boolean
		{
			if (NumberPicker.IsValid(gameTime, checkTime) == false)
			{
				return false;
			}
			
			if (PlantTypePicker.IsValid(gameTime, checkTime) == false)
			{
				return false;
			}
			
			return true;
		}
		
		public override function PrettyPrint():String
		{
			var sOutput:String = "CustomPlantEvent x" + _occurrences + ", plantType = " + _plantType;
			
			return sOutput;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}