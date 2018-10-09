package
{
	//-----------------------
	//Purpose:				Service logic for dealing with Item object prices
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class ItemPricingService
	{
		// Constants //
		
		public static const PRICE_MOD_PERCENT:Array = [ -100, -15, -10, -5, 0, 5, 10, 15 ];
		
		public static const PRICE_MOD_TRASH:int = 0;
		public static const PRICE_MOD_LOWEST:int = 1;
		public static const PRICE_MOD_LOWER:int = 2;
		public static const PRICE_MOD_LOW:int = 3;
		public static const PRICE_MOD_STANDARD:int = 4;
		public static const PRICE_MOD_HIGH:int = 5;
		public static const PRICE_MOD_HIGHER:int = 6;
		public static const PRICE_MOD_HIGHEST:int = 7;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get time():Time
		{
			return _time;
		}
		
		public function set time(value:Time):void
		{
			_time = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _time:Time;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function ItemPricingService(time:Time = null)
		{
			_time = time;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		// returns the item's price, or -1 if the item cannot be bought or sold
		public function GetItemPrice(item:IItem):int
		{
			if (item == null)
			{
				return -1;
			}
			
			var iPrice:int = -1;
			var iPriceModPercent:int = ItemPricingService.PRICE_MOD_PERCENT[item.priceModifier];
			
			if (item is IConstantPrice)
			{
				var oConstantPriceItem:IConstantPrice = IConstantPrice(item);
				iPrice = oConstantPriceItem.GetPrice();
				iPrice += (iPrice * (iPriceModPercent / 100));
			}
			else if (item is ISeasonalPrice)
			{
				var oSeasonalPriceItem:ISeasonalPrice = ISeasonalPrice(item);
				iPrice = oSeasonalPriceItem.GetPrice(_time.season);
				iPrice += (iPrice * (iPriceModPercent / 100));
			}
			
			return iPrice;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}