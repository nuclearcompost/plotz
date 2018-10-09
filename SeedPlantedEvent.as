package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Record event for a seed being planted
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class SeedPlantedEvent extends DayEvent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get eventType():int
		{
			return DayEvent.TYPE_SEED_PLANTED;
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
		
		public function SeedPlantedEvent(plantType:int = 0, time:Time = null, occurrences:int = 1)
		{
			super(time, occurrences);
			
			_plantType = plantType;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Equals(other:DayEvent):Boolean
		{
			if (!(other is SeedPlantedEvent))
			{
				return false;
			}
			
			var oOther:SeedPlantedEvent = SeedPlantedEvent(other);
			
			if (oOther.plantType != _plantType)
			{
				return false;
			}
			
			return true;
		}
		
		public override function GetIcon():MovieClip
		{
			var mcIcon:MovieClip = new Calendar_EventIcon_MC();
			mcIcon.gotoAndStop(1);
			
			return mcIcon;
		}
		
		public override function GetLongDescription():String
		{
			var sDescription:String = "Planted " + _occurrences + " " + Plant.NAME[_plantType] + " plants";
			
			return sDescription;
		}
		
		public override function PrettyPrint():String
		{
			var sOutput:String = "SeedPlantedEvent x" + _occurrences + ", plantType = " + _plantType;
			
			return sOutput;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}