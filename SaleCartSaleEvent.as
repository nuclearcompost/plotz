package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Record event for an item being sold from the Sale Cart
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class SaleCartSaleEvent extends DayEvent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get eventType():int
		{
			return DayEvent.TYPE_SALE_CART_SALE;
		}
		
		public function get itemClass():String
		{
			return _itemClass;
		}
		
		public function set itemClass(value:String):void
		{
			_itemClass = value;
		}
		
		public function get itemType():int
		{
			return _itemType;
		}
		
		public function set itemType(value:int):void
		{
			_itemType = value;
		}
		
		public function get price():int
		{
			return _price;
		}
		
		public function set price(value:int):void
		{
			_price;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _itemClass:String;
		private var _itemType:int;
		private var _price:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function SaleCartSaleEvent(itemClass:String = "", itemType:int = 0, price:int = 0, time:Time = null, occurrences:int = 1)
		{
			super(time, occurrences);
			
			_itemClass = itemClass;
			_itemType = itemType;
			_price = price;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Equals(other:DayEvent):Boolean
		{
			if (!(other is SaleCartSaleEvent))
			{
				return false;
			}
			
			var oOther:SaleCartSaleEvent = SaleCartSaleEvent(other);
			
			if (oOther.itemClass != _itemClass)
			{
				return false;
			}
			
			if (oOther.itemType != _itemType)
			{
				return false;
			}
			
			if (oOther.price != _price)
			{
				return false;
			}
			
			return true;
		}
		
		public static function GetCoalesceDescription(events:Array):String
		{
			var iNumItems:int = 0;
			var iTotalCost:int = 0;
			
			for (var i:int = 0; i < events.length; i++)
			{
				var oEvent:SaleCartSaleEvent = SaleCartSaleEvent(events[i]);
				
				iNumItems += oEvent.occurrences;
				iTotalCost += (oEvent.occurrences * oEvent.price);
			}
			
			var sOutput:String = iNumItems + " items sold from your Sale Cart for a gain of $" + iTotalCost;
			
			return sOutput;
		}
		
		public override function GetIcon():MovieClip
		{
			var mcIcon:MovieClip = new Calendar_EventIcon_MC();
			mcIcon.gotoAndStop(3);
			
			return mcIcon;
		}
		
		public override function GetLongDescription():String
		{
			var sDescription:String = "Sale cart sold " + _occurrences + " items costing " + _price + " each for a total of $" + _occurrences * _price;
			
			return sDescription;
		}
		
		public override function PrettyPrint():String
		{
			var sOutput:String = "SaleCartSaleEvent x" + _occurrences + ", itemClass = " + _itemClass + ", itemType = " + _itemType + ", price = " + _price;
			
			return sOutput;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}