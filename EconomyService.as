package
{
	import flash.utils.getQualifiedClassName;
	
	//-----------------------
	//Purpose:				Logic for buying, selling, trading, etc...
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class EconomyService
	{
		// Constants //
		
		// indexed by day, price modifier
		private static const SALE_CART_SELL_PROBABILITY:Array = [ [ 0, 60, 50, 40, 30, 8, 4, 1 ],
																  [ 0, 70, 60, 50, 40, 10, 5, 1 ],
																  [ 0, 70, 60, 50, 40, 10, 5, 1 ],
																  [ 0, 70, 60, 50, 40, 10, 5, 1 ],
																  [ 0, 70, 60, 50, 40, 10, 5, 1 ],
																  [ 0, 80, 75, 65, 55, 15, 10, 2 ],
																  [ 0, 99, 85, 75, 65, 20, 15, 5 ]
																];
		
		private static const ORGANIC_SELL_BUMP:int = 10;
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function EconomyService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		// returns true if the player is able to buy the item; otherwise false
		public static function BuyItem(activePlayer:Player, price:int):Boolean
		{			
			if (activePlayer == null)
			{
				return false;
			}
			
			if (price == -1)
			{
				return false;
			}
			
			var bItemBought:Boolean = false;
			
			if (activePlayer.cash >= price)
			{
				bItemBought = true;
				activePlayer.cash -= price;
			}
			
			return bItemBought;
		}
		
		public static function CanBuyItem(activePlayer:Player, price:int):Boolean
		{
			if (activePlayer == null)
			{
				return false;
			}
			
			if (price == -1)
			{
				return false;
			}
			
			if (activePlayer.cash >= price)
			{
				return true;
			}
			
			return false;
		}
		
		// run logic to see if anything should sell from the given sale cart for the day
		public static function SellFromSaleCart(saleCart:SaleCart, activePlayer:Player, day:int, itemPricingService:ItemPricingService, statTracker:StatTracker = null,
												calendarStatTracker:CalendarStatTracker = null):void
		{
			if (saleCart == null)
			{
				return;
			}
			
			if (activePlayer == null)
			{
				return;
			}
			
			if (day < Time.DAY_MONDAY || day > Time.DAY_SUNDAY)
			{
				return;
			}
			
			for (var slot:int = 0; slot < saleCart.contents.maxSize; slot++)
			{
				var oObject:Object = saleCart.contents.GetItemAt(slot);
				
				if (oObject == null)
				{
					continue;
				}
				
				if (!(oObject is IItem))
				{
					continue;
				}
				
				var oItem:IItem = IItem(oObject);
				
				var iChanceOfSelling:int = EconomyService.SALE_CART_SELL_PROBABILITY[day][oItem.priceModifier];
				
				var iSellRoll:int = Math.floor(Math.random() * 100) + 1;
				
				if (oItem is Fruit)
				{
					var oFruit:Fruit = Fruit(oItem);
					
					if (oFruit.isOrganic == true)
					{
						iChanceOfSelling += EconomyService.ORGANIC_SELL_BUMP;
					}
				}
				
				if (iSellRoll < iChanceOfSelling)
				{
					var iPrice:int = itemPricingService.GetItemPrice(oItem);
					var bSold:Boolean = EconomyService.SellItem(activePlayer, iPrice, statTracker);
					
					if (bSold == true)
					{
						calendarStatTracker.AddEventToday(new SaleCartSaleEvent(getQualifiedClassName(oItem), oItem.type, iPrice, null, 1));
						saleCart.contents.PopItemAt(slot);
					}
				}
			}
		}
		
		// returns true if the player is able to sell the item; otherwise false
		public static function SellItem(activePlayer:Player, price:int, statTracker:StatTracker = null):Boolean
		{
			if (activePlayer == null)
			{
				return false;
			}
			
			if (price == -1)
			{
				return false;
			}
			
			var bItemSold:Boolean = false;
			
			if (price >= 0)
			{
				bItemSold = true;
				activePlayer.cash += price;
				
				if (statTracker != null)
				{
					statTracker.moneyEarned += price;
				}
			}
			
			return bItemSold;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults[lResults.length] = EconomyService.BuyItemFalseIfNotEnoughMoney();
			lResults[lResults.length] = EconomyService.BuyItemTrueIfEnoughMoney();
			lResults[lResults.length] = EconomyService.BuyItemTakesActivePlayerCash();
			lResults[lResults.length] = EconomyService.SellItemTrueIfItemIsSellable();
			lResults[lResults.length] = EconomyService.SellItemFalseIfItemNotSellable();
			lResults[lResults.length] = EconomyService.SellItemGivesActivePlayerCash();
			
			return lResults;
		}
		
		public static function BuyItemFalseIfNotEnoughMoney():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("EconomyService", "BuyItemFalseIfNotEnoughMoney");
			
			var oPlayer:Player = new Player();
			oPlayer.cash = 0;
			
			oResult.TestFalse(EconomyService.BuyItem(oPlayer, 10));
			
			return oResult;
		}
		
		public static function BuyItemTrueIfEnoughMoney():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("EconomyService", "BuyItemTrueIfEnoughMoney");
			
			var oPlayer:Player = new Player();
			oPlayer.cash = 10;
			
			oResult.TestTrue(EconomyService.BuyItem(oPlayer, 10));
			
			return oResult;
		}
		
		public static function BuyItemTakesActivePlayerCash():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("EconomyService", "BuyItemTakesActivePlayerCash");
			
			var oPlayer:Player = new Player();
			var oBag:BagFertilizer = new BagFertilizer(BagFertilizer.TYPE_STEADY_GREEN);
			var oFertilizer:Fertilizer = oBag.CreateFertilizer();
			oPlayer.cash = 20;
			
			EconomyService.BuyItem(oPlayer, 10);
			
			oResult.expected = "10";
			oResult.actual = String(oPlayer.cash);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function SellItemTrueIfItemIsSellable():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("EconomyService", "SellItemTrueIfItemIsSellable");
			
			var oPlayer:Player = new Player();
			
			oResult.TestTrue(EconomyService.SellItem(oPlayer, 10));
			
			return oResult;
		}
		
		public static function SellItemFalseIfItemNotSellable():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("EconomyService", "SellItemFalseIfItemNotSellable");
			
			var oPlayer:Player = new Player();
			
			oResult.TestFalse(EconomyService.SellItem(oPlayer, -1));
			
			return oResult;
		}
		
		public static function SellItemGivesActivePlayerCash():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("EconomyService", "SellItemGivesActivePlayerCash");
			
			var oPlayer:Player = new Player();
			oPlayer.cash = 0;
			
			EconomyService.SellItem(oPlayer, 10);
			
			oResult.expected = "10";
			oResult.actual = String(oPlayer.cash);
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}