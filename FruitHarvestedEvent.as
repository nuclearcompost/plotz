package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Record event for a fruit being harvested
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class FruitHarvestedEvent extends DayEvent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get eventType():int
		{
			return DayEvent.TYPE_FRUIT_HARVESTED;
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
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function FruitHarvestedEvent(fruitType:int = 0, time:Time = null, occurrences:int = 1)
		{
			super(time, occurrences);
			
			_fruitType = fruitType;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Equals(other:DayEvent):Boolean
		{
			if (!(other is FruitHarvestedEvent))
			{
				return false;
			}
			
			var oOther:FruitHarvestedEvent = FruitHarvestedEvent(other);
			
			if (oOther.fruitType != _fruitType)
			{
				return false;
			}
			
			return true;
		}
		
		public override function GetIcon():MovieClip
		{
			var mcIcon:MovieClip = new Calendar_EventIcon_MC();
			mcIcon.gotoAndStop(2);
			
			return mcIcon;
		}
		
		public override function GetLongDescription():String
		{
			var sDescription:String = _occurrences + " " + Fruit.DESCRIPTION[_fruitType] + " were harvested";
			
			return sDescription;
		}
		
		public override function PrettyPrint():String
		{
			var sOutput:String = "FruitHarvestedEvent x" + _occurrences + ", fruitType = " + _fruitType;
			
			return sOutput;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}