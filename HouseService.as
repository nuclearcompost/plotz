package
{
	//-----------------------
	//Purpose:				Service logic for the House
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class HouseService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function HouseService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function EmptyGarbage(house:House):void
		{
			if (house == null)
			{
				return;
			}
			
			house.garbage.ClearAllItems();
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(HouseService.EmptyGarbageClearsItemsOnGarbageTab());
			
			return lResults;
		}
		
		private static function EmptyGarbageClearsItemsOnGarbageTab():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("HouseService", "EmptyGarbageClearsItemsOnGarbageTab");
			var oHouse:House = new House();
			oHouse.garbage.AddItem(new Fruit(Fruit.TYPE_ASPARAGUS));
			
			oResult.expected = "0";
			HouseService.EmptyGarbage(oHouse);
			oResult.actual = String(oHouse.garbage.GetNumItems());
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}