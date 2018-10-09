package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Base class for calendar stat tracking events
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//Extended By:
	//	CustomDayEvent
	//		CustomHarvestEvent
	//		CustomPlantEvent
	//	FruitHarvestedEvent
	//	FutureHarvestEvent
	//	ItemShopPurchaseEvent
	//	ItemShopSaleEvent
	//	PlantKilledEvent
	//	SaleCartSaleEvent
	//	SeedPlantedEvent
	//	WeatherEvent
	//	WellAmountEvent
	//
	//-----------------------
	
	public class DayEvent
	{
		// Constants //
		
		public static const TYPE_FRUIT_HARVESTED:int = 0;
		public static const TYPE_ITEM_SHOP_PURCHASE:int = 1;
		public static const TYPE_ITEM_SHOP_SALE:int = 2;
		public static const TYPE_PLANT_KILLED:int = 3;
		public static const TYPE_SALE_CART_SALE:int = 4;
		public static const TYPE_SEED_PLANTED:int = 5;
		public static const TYPE_WEATHER:int = 6;
		public static const TYPE_WELL_AMOUNT:int = 7;
		public static const TYPE_FUTURE_HARVEST:int = 8;
		public static const TYPE_CUSTOM_PLANT:int = 9;
		public static const TYPE_CUSTOM_HARVEST:int = 10;
		
		public static const MAX_TYPE:int = 10;
		
		public static const DESCRIPTION:Array = [ "Fruit Harvested", "Item Shop Purchase", "Item Shop Sale", "Plant Killed", "Sale Cart Sale", "Seed Planted", "Weather",
												   "Well Amount", "Harvest", "Plant", "Harvest" ];
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get eventType():int
		{
			trace("DayEvent eventType getter called!");
			return -1;
		}
		
		public function get occurrences():int
		{
			return _occurrences;
		}
		
		public function set occurrences(value:int):void
		{
			_occurrences = value;
		}
		
		public function get time():Time
		{
			return _time;
		}
		
		public function set time(value:Time):void
		{
			_time = value;
		}
		
		//- Public Properties -//
		
		
		// Protected Properties //
		
		protected var _occurrences:int;
		protected var _time:Time;
		
		//- Protected Properties -//
		
	
		// Initialization //
		
		public function DayEvent(time:Time = null, occurrences:int = 1)
		{
			_time = time;
			if (_time == null)
			{
				_time = new Time(0, 0, 0, 0, 0, 0, false);
			}
			
			_occurrences = occurrences;
		}
		
		//- Initialization -//
		
		
		// Public Methods //
		
		public function Equals(other:DayEvent):Boolean
		{
			trace("DayEvent Equals method called!");
			return false;
		}
		
		public static function GetDescription(eventType:int):String
		{
			var sDescription:String = DayEvent.DESCRIPTION[eventType];
			
			return sDescription;
		}
		
		public function GetIcon():MovieClip
		{
			trace("DayEvent GetIcon method called!");
			return null;
		}
		
		public function GetLongDescription():String
		{
			trace("DayEvent GetLongDescription method called!");
			return "";
		}
		
		public function PrettyPrint():String
		{
			trace("DayEvent PrettyPrint method called!");
			return "";
		}
		
		public static function PrettyPrintList(list:Array):String
		{
			if (list == null)
			{
				return "";
			}
			
			var sOutput:String = "";
			
			for (var i:int = 0; i < list.length; i++)
			{
				var oObject:Object = list[i];
				
				if (oObject == null)
				{
					continue;
				}
				
				if (!(oObject is DayEvent))
				{
					continue;
				}
				
				var oDayEvent:DayEvent = DayEvent(oObject);
				
				sOutput += (oDayEvent.PrettyPrint() + "; ");
			}
			
			return sOutput;
		}
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		//- Protected Methods -//
	}
}