package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Record event for the amount of water currently in a well
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class WellAmountEvent extends DayEvent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get eventType():int
		{
			return DayEvent.TYPE_WELL_AMOUNT;
		}
		
		public function get amount():Number
		{
			return _amount;
		}
		
		public function set amount(value:Number):void
		{
			_amount = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _amount:Number;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function WellAmountEvent(amount:Number = 0, time:Time = null)
		{
			super(time, 1);
			
			_amount = amount;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Equals(other:DayEvent):Boolean
		{
			if (!(other is WellAmountEvent))
			{
				return false;
			}
			
			var oOther:WellAmountEvent = WellAmountEvent(other);
			
			if (oOther.amount != _amount)
			{
				return false;
			}
			
			return true;
		}
		
		public override function GetIcon():MovieClip
		{
			var mcIcon:MovieClip = new Calendar_EventIcon_MC();
			mcIcon.gotoAndStop(7);
			
			return mcIcon;
		}
		
		public override function GetLongDescription():String
		{
			var sDescription:String = "The well had " + _amount + " water at the end of the day";
			
			return sDescription;
		}
		
		public override function PrettyPrint():String
		{
			var sOutput:String = "WellAmountEvent x" + _occurrences + ", amount = " + _amount;
			
			return sOutput;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}