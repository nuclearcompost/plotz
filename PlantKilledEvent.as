package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Record event for a plant being killed
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class PlantKilledEvent extends DayEvent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get cause():int
		{
			return _cause;
		}
		
		public function set cause(value:int):void
		{
			_cause = value;
		}
		
		public override function get eventType():int
		{
			return DayEvent.TYPE_PLANT_KILLED;
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
		
		private var _cause:int;
		private var _plantType:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function PlantKilledEvent(plantType:int = 0, cause:int = 0, time:Time = null, occurrences:int = 1)
		{
			super(time, occurrences);
			
			_plantType = plantType;
			_cause = cause;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Equals(other:DayEvent):Boolean
		{
			if (!(other is PlantKilledEvent))
			{
				return false;
			}
			
			var oOther:PlantKilledEvent = PlantKilledEvent(other);
			
			if (oOther.plantType != _plantType)
			{
				return false;
			}
			
			if (oOther.cause != _cause)
			{
				return false;
			}
			
			return true;
		}
		
		public override function GetIcon():MovieClip
		{
			var mcIcon:MovieClip = new Calendar_EventIcon_MC();
			mcIcon.gotoAndStop(4);
			
			return mcIcon;
		}
		
		public override function GetLongDescription():String
		{
			var sDescription:String = _occurrences + " " + Plant.NAME[_plantType] + " plants died";
			
			return sDescription;
		}
		
		public override function PrettyPrint():String
		{
			var sOutput:String = "PlantKilledEvent x" + _occurrences + ", plantType = " + _plantType + ", cause = " + _cause;
			
			return sOutput;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}