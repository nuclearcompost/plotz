package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				An item in the game
	//
	//Public Properties:
	//	Price:int = the Price of the item
	//
	//Public Methods:
	/// Static Methods:
	/// 	GetCopyOfItem(item):Item = gets a duplicate of the same type of Item
	///
	/// Instance Methods:
	/// 	GetGraphics():MovieClip = gets a movieClip representation of this Item
	//
	// Extended By:
	//		BagFertilizer
	//		Compost
	//		Fruit
	//		Plant
	//		PlantScrap
	//		Seed
	//		Tool
	//-----------------------
	public class Item implements IItem
	{
		// Constants //
		
		public static const SUBCAT_NONE:int = -2;
		public static const SUBCAT_ALL:int = -1;
		public static const SUBCAT_FRUIT:int = 0;
		public static const SUBCAT_SEED:int = 1;
		public static const SUBCAT_TOOL:int = 2;
		public static const SUBCAT_BAG_FERTILIZER:int = 3;
		public static const SUBCAT_PLANT:int = 4;
		public static const SUBCAT_ITEMBLDG:int = 5;
		public static const SUBCAT_PLANT_SCRAP:int = 6;
		public static const SUBCAT_COMPOST:int = 7;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get name():String
		{
			trace("item name property accessed!");
			return "";
		}
		
		public function get priceModifier():int
		{
			trace("Item class' priceModifier getter accessed!");
			return -1;
		}
		
		public function set priceModifier(value:int):void
		{
			trace("Item class' priceModifier setter accessed!");
		}
		
		public function get type():int
		{
			trace("item type property accessed!");
			return 0;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		Construct a new Item object
		//
		//Parameters:
		//	iType:int = the item type
		//
		//Returns:		reference to the new object
		//---------------
		public function Item()
		{

		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		//---------------
		//Purpose:		Get a duplicate of the given item
		//
		//Parameters:
		//	item:Item = the Item to duplicate
		//
		//Returns:		a duplicate of the given Item
		//---------------
		public static function GetCopyOfItem(item):IItem
		{
			var oReturn:IItem;
			
			if (item is BagFertilizer)
			{
				oReturn = new BagFertilizer(item.type);
			}
			if (item is Fruit)
			{
				oReturn = new Fruit(item.type);
			}
			else if (item is Seed)
			{
				oReturn = new Seed(item.type);
			}
			else if (item is Tool)
			{
				oReturn = new Tool(item.type);
			}
			else if (item is CompostBin)
			{
				oReturn = new CompostBin();
			}
			else if (item is PlantScrap)
			{
				var oScrap:PlantScrap = PlantScrap(item);
				oReturn = new PlantScrap(oScrap.nutrientSet.GetCopy());
			}
			
			return oReturn;
		}
		
		//---------------
		//Purpose:		Get a movieclip representation of this Item
		//
		//Parameters:
		//	none
		//
		//Returns:		a movieclip representation of this Item
		//---------------
		public function GetItemGraphics():MovieClip
		{
			trace("Item GetItemGraphics function called");
			return null;
		}
		
		
		// Don't make GetPreviewGraphics here b/c Seed needs the current season for its preview. Unless you can think of a good way around that. //
		
		
		public static function IsConcreteItemCategory(itemCategory:int):Boolean
		{
			var bIsConcrete:Boolean = false;
			
			switch (itemCategory)
			{
				case Item.SUBCAT_FRUIT:
				case Item.SUBCAT_SEED:
				case Item.SUBCAT_TOOL:
				case Item.SUBCAT_BAG_FERTILIZER:
				case Item.SUBCAT_PLANT:
				case Item.SUBCAT_ITEMBLDG:
				case Item.SUBCAT_PLANT_SCRAP:
				case Item.SUBCAT_COMPOST:
					bIsConcrete = true;
					break;
				default:
					bIsConcrete = false;
					break;
			}
			
			return bIsConcrete;
		}
		
		//- Public Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(IsConcreteItemCategoryFalseForNone());
			lResults.push(IsConcreteItemCategoryFalseForAll());
			lResults.push(IsConcreteItemCategoryTrueForFruit());
			lResults.push(IsConcreteItemCategoryTrueForSeed());
			lResults.push(IsConcreteItemCategoryTrueForTool());
			lResults.push(IsConcreteItemCategoryTrueForBagFertilizer());
			lResults.push(IsConcreteItemCategoryTrueForPlant());
			lResults.push(IsConcreteItemCategoryTrueForItemBldg());
			lResults.push(IsConcreteItemCategoryTrueForPlantScrap());
			lResults.push(IsConcreteItemCategoryTrueForCompost());
			
			return lResults;
		}
		
		public static function IsConcreteItemCategoryFalseForNone():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Item", "IsConcreteItemCategoryFalseForNone");
			
			oResult.expected = "false";
			oResult.actual = String(Item.IsConcreteItemCategory(Item.SUBCAT_NONE));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsConcreteItemCategoryFalseForAll():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Item", "IsConcreteItemCategoryFalseForAll");
			
			oResult.expected = "false";
			oResult.actual = String(Item.IsConcreteItemCategory(Item.SUBCAT_ALL));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsConcreteItemCategoryTrueForFruit():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Item", "IsConcreteItemCategoryTrueForFruit");
			
			oResult.expected = "true";
			oResult.actual = String(Item.IsConcreteItemCategory(Item.SUBCAT_FRUIT));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsConcreteItemCategoryTrueForSeed():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Item", "IsConcreteItemCategoryTrueForSeed");
			
			oResult.expected = "true";
			oResult.actual = String(Item.IsConcreteItemCategory(Item.SUBCAT_SEED));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsConcreteItemCategoryTrueForTool():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Item", "IsConcreteItemCategoryTrueForTool");
			
			oResult.expected = "true";
			oResult.actual = String(Item.IsConcreteItemCategory(Item.SUBCAT_TOOL));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsConcreteItemCategoryTrueForBagFertilizer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Item", "IsConcreteItemCategoryTrueForBagFertilizer");
			
			oResult.expected = "true";
			oResult.actual = String(Item.IsConcreteItemCategory(Item.SUBCAT_BAG_FERTILIZER));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsConcreteItemCategoryTrueForPlant():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Item", "IsConcreteItemCategoryTrueForPlant");
			
			oResult.expected = "true";
			oResult.actual = String(Item.IsConcreteItemCategory(Item.SUBCAT_PLANT));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsConcreteItemCategoryTrueForItemBldg():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Item", "IsConcreteItemCategoryTrueForItemBldg");
			
			oResult.expected = "true";
			oResult.actual = String(Item.IsConcreteItemCategory(Item.SUBCAT_ITEMBLDG));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsConcreteItemCategoryTrueForPlantScrap():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Item", "IsConcreteItemCategoryTrueForPlantScrap");
			
			oResult.expected = "true";
			oResult.actual = String(Item.IsConcreteItemCategory(Item.SUBCAT_PLANT_SCRAP));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsConcreteItemCategoryTrueForCompost():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Item", "IsConcreteItemCategoryTrueForCompost");
			
			oResult.expected = "true";
			oResult.actual = String(Item.IsConcreteItemCategory(Item.SUBCAT_COMPOST));
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}