package
{
	import flash.utils.getQualifiedClassName;
	
	//-----------------------
	//Purpose:				Service logic for the Farm
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class FarmService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function FarmService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function AgeStoredFruit(farm:Farm):void
		{
			if (farm == null)
			{
				return;
			}
			
			if (farm.saleCart != null)
			{
				AgeFruitInInventoryByAmount(farm.saleCart.contents, 2);
			}
			
			if (farm.rootCellar != null)
			{
				AgeFruitInInventoryByAmount(farm.rootCellar.food, 1);
			}
		}
		
		private static function AgeFruitInInventoryByAmount(inventory:Inventory, ageAmount:int):void
		{
			if (inventory == null)
			{
				return;
			}
			
			for (var slot:int = 0; slot < inventory.maxSize; slot++)
			{
				var oItem:Object = inventory.GetItemAt(slot);
				
				if (!(oItem is Fruit))
				{
					continue;
				}
				
				var oFruit:Fruit = Fruit(oItem);
				
				oFruit.IncrementAge(ageAmount);
			}
		}
		
		public static function CreateBasicFarm(owner:Player, world:World, top:int, bottom:int, left:int, right:int):Farm
		{
			var oFarm:Farm = new Farm("Happy Farm", owner, world, top, bottom, left, right);
				
			var oWell:Well = new Well(new GridLocation(right - 1, top + 4), oFarm);
			oFarm.AddBldg(oWell);
			
			var oShed:ToolShed = new ToolShed(new GridLocation(left + 1, top + 1), oFarm);
			oFarm.AddBldg(oShed);
			
			var oSaleCart:SaleCart = new SaleCart(new GridLocation(right - 2, bottom), oFarm);
			oFarm.AddBldg(oSaleCart);
			
			var oHouse:House = new House(new GridLocation(left + 7, top + 2), oFarm);
			oFarm.AddBldg(oHouse);
			
			var oRootCellar:RootCellar = new RootCellar(new GridLocation(left + 5, top + 1), oFarm);
			oFarm.AddBldg(oRootCellar);
			
			return oFarm;
		}
		
		public static function DecomposeCompost(farm:Farm):void
		{
			if (farm == null || farm.itemBldgs == null)
			{
				return;
			}
			
			for (var i:int = 0; i < farm.itemBldgs.length; i++)
			{
				var oItemBldg:ItemBldg = ItemBldg(farm.itemBldgs[i]);
				
				if (oItemBldg is CompostBin)
				{
					var oCompostBin:CompostBin = CompostBin(oItemBldg);
					
					DecomposeCompostForCompostBin(oCompostBin);
				}
			}
		}
		
		private static function DecomposeCompostForCompostBin(compostBin:CompostBin):void
		{
			if (compostBin == null)
			{
				return;
			}
			
			for (var slot:int = 0; slot < compostBin.compost.maxSize; slot++)
			{
				var oItem:Object = compostBin.compost.GetItemAt(slot);
				
				if (oItem == null)
				{
					continue;
				}
				
				if (!(oItem is IDecomposes))
				{
					continue;
				}
				
				var oDecomposeItem:IDecomposes = IDecomposes(oItem);
				
				var iDaysLeft:int = oDecomposeItem.GetDecomposeDaysLeft();
				
				if (iDaysLeft > 1)
				{
					// decompose more
					oDecomposeItem.SetDecomposeDaysLeft(iDaysLeft - 1);
				}
				else
				{
					// convert to compost
					var oCompost:Compost = oDecomposeItem.CreateCompost();
					compostBin.compost.PopItemAt(slot);
					compostBin.compost.AddItemAt(oCompost, slot);
				}
			}
		}
		
		public static function DoesPlayerOwnFarm(player:Player, farm:Farm):Boolean
		{
			if (player == null)
			{
				return false;
			}
			
			if (player.farms == null)
			{
				return false;
			}
			
			if (farm == null)
			{
				return false;
			}
			
			var bPlayerOwnsFarm:Boolean = false;
			
			for (var i:int = 0; i < player.farms.length; i++)
			{
				var oFarm:Farm = Farm(player.farms[i]);
				
				if (oFarm == farm)
				{
					bPlayerOwnsFarm = true;
					break;
				}
			}
			
			return bPlayerOwnsFarm;
		}
		
		public static function DropItemOnFarm(farm:Farm, item:Object):Boolean
		{
			if (item == null)
			{
				return true;
			}
			
			if (farm == null)
			{
				return false;
			}
			
			// build list of inventories in priority order
			var lInventories:Array = new Array();
			
			if (farm.toolShed != null)
			{
				lInventories.push(farm.toolShed.tools);
			}
			
			if (farm.rootCellar != null)
			{
				lInventories.push(farm.rootCellar.food);
			}
			
			if (farm.saleCart != null)
			{
				lInventories.push(farm.saleCart.contents);
			}
			
			if (farm.itemBldgs != null)
			{
				for (var i:int = 0; i < farm.itemBldgs.length; i++)
				{
					var oItemBldg:ItemBldg = ItemBldg(farm.itemBldgs[i]);
					
					if (!(oItemBldg is CompostBin))
					{
						continue;
					}
					
					var oCompostBin:CompostBin = CompostBin(oItemBldg);
					
					lInventories.push(oCompostBin.compost);
				}
			}
			
			if (farm.house != null)
			{
				lInventories.push(farm.house.garbage);
			}
			
			// try to add the item to each of the farm's available inventories, in priority order
			var bCanAddItem:Boolean = false;
			var oInventory:Inventory = null;
			
			for (i = 0; i < lInventories.length; i++)
			{
				oInventory = Inventory(lInventories[i]);
				bCanAddItem = oInventory.AddItem(item);
				
				if (bCanAddItem == true)
				{
					break;
				}
			}
			
			return bCanAddItem;
		}
		
		public static function EmptyGarbage(farm:Farm):void
		{
			if (farm == null)
			{
				return;
			}
			
			if (farm.house == null)
			{
				return;
			}
			
			HouseService.EmptyGarbage(farm.house);
		}
		
		public static function PlaceItemBldg(farm:Farm, bldg:ItemBldg, clickLocation:GridLocation, world:World):Boolean
		{
			if (farm == null)
			{
				return false;
			}
			
			if (bldg == null)
			{
				return false;
			}
			
			if (clickLocation == null)
			{
				return false;
			}
			
			if (world == null)
			{
				return false;
			}
			
			var oTile:Tile = Tile(world.tiles[clickLocation.x][clickLocation.y]);
			
			if (oTile == null)
			{
				return false;
			}
			
			var oPlant:Plant = oTile.plant;
			
			// kill any plants except for wild grass
			if (oPlant != null && oPlant.type != Plant.TYPE_WILD_GRASS)
			{
				oTile.plant = null;
			}
			
			// set the ItemBldg's origin
			if (bldg.origin == null)
			{
				bldg.origin = new GridLocation();
			}
			
			bldg.origin.x = clickLocation.x;
			bldg.origin.y = clickLocation.y;
			
			// add the ItemBldg to the farm
			farm.AddBldg(bldg);
			
			return true;
		}
		
		public static function PopTool(farm:Farm, toolType:int):Tool
		{
			if (farm == null)
			{
				return null;
			}
			
			if (farm.toolShed == null)
			{
				return null;
			}
			
			var oInventory:Inventory = farm.toolShed.tools;
			
			for (var i:int = 0; i < oInventory.maxSize; i++)
			{
				var oObject:Object = oInventory.GetItemAt(i);
				
				if (!(oObject is Tool))
				{
					continue;
				}
				
				var oTool:Tool = Tool(oObject);
				
				if (oTool.type == toolType)
				{
					oTool = Tool(oInventory.PopItemAt(i));
					return oTool;
				}
			}
			
			return null;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults = lResults.concat(FarmService.TestCreateBasicFarm());
			lResults.push(FarmService.PopToolNoFarmReturnsNull());
			lResults.push(FarmService.PopToolNoToolShedReturnsNull());
			lResults.push(FarmService.PopToolNonExistantToolNumberReturnsNull());
			lResults.push(FarmService.PopToolNotFoundReturnsNull());
			lResults.push(FarmService.TestPopTool());
			lResults.push(FarmService.AgeStoredFruitAffectsSaleCart());
			lResults.push(FarmService.AgeStoredFruitAffectsRootCellar());
			
			lResults.push(FarmService.PlaceItemBldgFalseIfNoFarm());
			lResults.push(FarmService.PlaceItemBldgFalseIfNoBldg());
			lResults.push(FarmService.PlaceItemBldgFalseIfNoLocation());
			lResults.push(FarmService.PlaceItemBldgKillsNonGrass());
			lResults.push(FarmService.PlaceItemBldgKeepsGrassAlive());
			lResults.push(FarmService.PlaceItemBldgSetsBldgOrigin());
			lResults.push(FarmService.PlaceItemBldgAddsBldgToFarm());
			lResults.push(FarmService.PlaceItemBldgTrueIfSuccessful());
			
			lResults.push(FarmService.DecomposeCompostOkIfNoFarm());
			lResults.push(FarmService.DecomposeCompostDecrementsDecomposeDaysLeft());
			lResults.push(FarmService.DecomposeCompostCreatesCompost());
			
			lResults.push(FarmService.DropItemOnFarmTrueIfItemNull());
			lResults.push(FarmService.DropItemOnFarmFalseIfNoFarm());
			lResults.push(FarmService.DropItemOnFarmTrueForFruit());
			lResults.push(FarmService.DropItemOnFarmFalseForFruit());
			lResults.push(FarmService.DropItemOnFarmTrueForSeed());
			lResults.push(FarmService.DropItemOnFarmFalseForSeed());
			lResults.push(FarmService.DropItemOnFarmTrueForTool());
			lResults.push(FarmService.DropItemOnFarmFalseForTool());
			lResults.push(FarmService.DropItemOnFarmTrueForBagFertilizer());
			lResults.push(FarmService.DropItemOnFarmFalseForBagFertilizer());
			lResults.push(FarmService.DropItemOnFarmFalseForPlant());
			lResults.push(FarmService.DropItemOnFarmTrueForItemBldg());
			lResults.push(FarmService.DropItemOnFarmFalseForItemBldg());
			lResults.push(FarmService.DropItemOnFarmTrueForPlantScrap());
			lResults.push(FarmService.DropItemOnFarmFalseForPlantScrap());
			lResults.push(FarmService.DropItemOnFarmTrueForCompost());
			lResults.push(FarmService.DropItemOnFarmFalseForCompost());
			
			lResults.push(FarmService.DropItemOnFarmPutsFruitInRootCellarFirst());
			lResults.push(FarmService.DropItemOnFarmPutsFruitInSaleCartSecond());
			lResults.push(FarmService.DropItemOnFarmPutsFruitInCompostThird());
			lResults.push(FarmService.DropItemOnFarmPutsFruitInGarbageFourth());
			lResults.push(FarmService.DropItemOnFarmPutsPlantScrapInCompostFirst());
			lResults.push(FarmService.DropItemOnFarmPutsPlantScrapInGarbageSecond());
			
			return lResults;
		}
		
		private static function TestCreateBasicFarm():Array
		{
			var oHouseNotNullResult:UnitTestResult = new UnitTestResult("FarmService", "TestCreateBasicFarm - House Not Null");
			var oRootCellarNotNullResult:UnitTestResult = new UnitTestResult("FarmService", "TestCreateBasicFarm - Root Cellar Not Null");
			var oSaleCartNotNullResult:UnitTestResult = new UnitTestResult("FarmService", "TestCreateBasicFarm - SaleCart Not Null");
			var oToolShedNotNullResult:UnitTestResult = new UnitTestResult("FarmService", "TestCreateBasicFarm - ToolShed Not Null");
			var oWellNotNullResult:UnitTestResult = new UnitTestResult("FarmService", "TestCreateBasicFarm - Well Not Null");
			
			var oHouseLocationResult:UnitTestResult = new UnitTestResult("FarmService", "TestCreateBasicFarm - House Location");
			var oRootCellarLocationResult:UnitTestResult = new UnitTestResult("FarmService", "TestCreateBasicFarm - Root Cellar Location");
			var oSaleCartLocationResult:UnitTestResult = new UnitTestResult("FarmService", "TestCreateBasicFarm - SaleCart Location");
			var oWellLocationResult:UnitTestResult = new UnitTestResult("FarmService", "TestCreateBasicFarm - Well Location");
			var oToolShedLocationResult:UnitTestResult = new UnitTestResult("FarmService", "TestCreateBasicFarm - ToolShed Location");
			
			var lResults:Array = [ oHouseNotNullResult, oRootCellarNotNullResult, oSaleCartNotNullResult, oToolShedNotNullResult, oWellNotNullResult, 
								   oHouseLocationResult, oRootCellarLocationResult, oSaleCartLocationResult, oToolShedLocationResult, oWellLocationResult ];
			
			var iTop:int = 5;
			var iBottom:int = 13;
			var iLeft:int = 0;
			var iRight:int = 11;
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, iTop, iBottom, iLeft, iRight);
			
			oHouseNotNullResult.TestNotNull(oFarm.house);
			oRootCellarNotNullResult.TestNotNull(oFarm.rootCellar);
			oSaleCartNotNullResult.TestNotNull(oFarm.saleCart);
			oToolShedNotNullResult.TestNotNull(oFarm.toolShed);
			oWellNotNullResult.TestNotNull(oFarm.well);
			
			var oLocation:GridLocation = null;
			
			if (oHouseNotNullResult.status == UnitTestResult.STATUS_PASS)
			{
				oLocation = new GridLocation(7, 13);
				oHouseLocationResult.expected = oLocation.PrettyPrint();
				oHouseLocationResult.actual = oFarm.house.origin.PrettyPrint();
				oHouseLocationResult.TestEquals();
			}
			
			if (oRootCellarNotNullResult.status == UnitTestResult.STATUS_PASS)
			{
				oLocation = new GridLocation(7, 9);
				oRootCellarLocationResult.expected = oLocation.PrettyPrint();
				oRootCellarLocationResult.actual = oFarm.rootCellar.origin.PrettyPrint();
				oRootCellarLocationResult.TestEquals();
			}
			
			if (oSaleCartNotNullResult.status == UnitTestResult.STATUS_PASS)
			{
				oLocation = new GridLocation(5, 13);
				oSaleCartLocationResult.expected = oLocation.PrettyPrint();
				oSaleCartLocationResult.actual = oFarm.saleCart.origin.PrettyPrint();
				oSaleCartLocationResult.TestEquals();
			}
			
			if (oToolShedNotNullResult.status == UnitTestResult.STATUS_PASS)
			{
				oLocation = new GridLocation(3, 13);
				oToolShedLocationResult.expected = oLocation.PrettyPrint();
				oToolShedLocationResult.actual = oFarm.toolShed.origin.PrettyPrint();
				oToolShedLocationResult.TestEquals();
			}
			
			if (oWellNotNullResult.status == UnitTestResult.STATUS_PASS)
			{
				oLocation = new GridLocation(1, 13);
				oWellLocationResult.expected = oLocation.PrettyPrint();
				oWellLocationResult.actual = oFarm.well.origin.PrettyPrint();
				oWellLocationResult.TestEquals();
			}
			
			return lResults;
		}
		
		private static function PopToolNoFarmReturnsNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PopToolNoFarmReturnsNull");
			
			oResult.TestNull(FarmService.PopTool(null, 1));
			
			return oResult;
		}
		
		private static function PopToolNoToolShedReturnsNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PopToolNoToolShedReturnsNull");
			
			var oFarm:Farm = new Farm();
			
			oResult.TestNull(FarmService.PopTool(oFarm, 1));
			
			return oResult;
		}
		
		private static function PopToolNonExistantToolNumberReturnsNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PopToolNonExistantToolNumberReturnsNull");
			
			var oFarm:Farm = new Farm();
			var oToolShed:ToolShed = new ToolShed(null, oFarm);
			oFarm.AddBldg(oToolShed);
			oToolShed.tools.AddItem(new Tool(Tool.TYPE_WATERING_CAN));
			oToolShed.tools.AddItem(new Tool(Tool.TYPE_SICKLE));
			oToolShed.tools.AddItem(new Tool(Tool.TYPE_HOE));
			
			oResult.TestNull(FarmService.PopTool(oFarm, 834739));
			
			return oResult;
		}
		
		private static function PopToolNotFoundReturnsNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PopToolNotFoundReturnsNull");
			
			var oFarm:Farm = new Farm();
			var oToolShed:ToolShed = new ToolShed(null, oFarm);
			oFarm.AddBldg(oToolShed);
			oToolShed.tools.AddItem(new Tool(Tool.TYPE_WATERING_CAN));
			oToolShed.tools.AddItem(new Tool(Tool.TYPE_HOE));
			
			oResult.TestNull(FarmService.PopTool(oFarm, Tool.TYPE_SICKLE));
			
			return oResult;
		}
		
		private static function TestPopTool():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "TestPopTool");
			
			var oFarm:Farm = new Farm();
			var oToolShed:ToolShed = new ToolShed(null, oFarm);
			oFarm.AddBldg(oToolShed);
			oToolShed.tools.AddItem(new Tool(Tool.TYPE_WATERING_CAN));
			oToolShed.tools.AddItem(new Tool(Tool.TYPE_SICKLE));
			oToolShed.tools.AddItem(new Tool(Tool.TYPE_HOE));
			
			oResult.TestNotNull(FarmService.PopTool(oFarm, Tool.TYPE_SICKLE));
			
			return oResult;
		}
		
		private static function AgeStoredFruitAffectsSaleCart():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "AgeStoredFruitAffectsSaleCart");
			
			var oFarm:Farm = new Farm();
			var oSaleCart:SaleCart = new SaleCart(null, oFarm);
			oFarm.AddBldg(oSaleCart);
			oSaleCart.contents.AddItem(new Fruit(Fruit.TYPE_ASPARAGUS, 2, Fruit.CONDITION_RIPE));
			
			FarmService.AgeStoredFruit(oFarm);
			
			var oFruit:Fruit = Fruit(oSaleCart.contents.GetItemAt(0));
			
			oResult.expected = "4";
			oResult.actual = String(oFruit.age);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function AgeStoredFruitAffectsRootCellar():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "AgeStoredFruitAffectsRootCellar");
			
			var oFarm:Farm = new Farm();
			var oRootCellar:RootCellar = new RootCellar(null, oFarm);
			oFarm.AddBldg(oRootCellar);
			oRootCellar.food.AddItem(new Fruit(Fruit.TYPE_ASPARAGUS, 2, Fruit.CONDITION_RIPE));
			
			FarmService.AgeStoredFruit(oFarm);
			
			var oFruit:Fruit = Fruit(oRootCellar.food.GetItemAt(0));
			
			oResult.expected = "3";
			oResult.actual = String(oFruit.age);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function PlaceItemBldgFalseIfNoFarm():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PlaceItemBldgFalseIfNoFarm");
			
			var oFarm:Farm = null;
			var oBldg:ItemBldg = new CompostBin();
			var oLocation:GridLocation = new GridLocation(0, 0);
			var oWorld:World = new World(1, 1);
			
			oResult.TestFalse(FarmService.PlaceItemBldg(oFarm, oBldg, oLocation, oWorld));
			
			return oResult;
		}
		
		private static function PlaceItemBldgFalseIfNoBldg():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PlaceItemBldgFalseIfNoBldg");
			
			var oFarm:Farm = new Farm();
			var oBldg:ItemBldg = null;
			var oLocation:GridLocation = new GridLocation(0, 0);
			var oWorld:World = new World(1, 1);
			
			oResult.TestFalse(FarmService.PlaceItemBldg(oFarm, oBldg, oLocation, oWorld));
			
			return oResult;
		}
		
		private static function PlaceItemBldgFalseIfNoLocation():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PlaceItemBldgFalseIfNoLocation");
			
			var oFarm:Farm = new Farm();
			var oBldg:ItemBldg = new CompostBin();
			var oLocation:GridLocation = null;
			var oWorld:World = new World(1, 1);
			
			oResult.TestFalse(FarmService.PlaceItemBldg(oFarm, oBldg, oLocation, oWorld));
			
			return oResult;
		}
		
		private static function PlaceItemBldgKillsNonGrass():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PlaceItemBldgKillsNonGrass");
			
			var oFarm:Farm = new Farm();
			var oBldg:ItemBldg = new CompostBin();
			var oLocation:GridLocation = new GridLocation(1, 1);
			var oWorld:World = new World(2, 2);
			var oPlant:Plant = new Plant(Plant.TYPE_ALFALFA);
			var oTile:Tile = Tile(oWorld.tiles[1][1]);
			oTile.plant = oPlant;
			
			FarmService.PlaceItemBldg(oFarm, oBldg, oLocation, oWorld);
			
			oResult.TestNull(oTile.plant);
			
			return oResult;
		}
		
		private static function PlaceItemBldgKeepsGrassAlive():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PlaceItemBldgKeepsGrassAlive");
			
			var oFarm:Farm = new Farm();
			var oBldg:ItemBldg = new CompostBin();
			var oLocation:GridLocation = new GridLocation(0, 0);
			var oWorld:World = new World(1, 1);
			var oPlant:Plant = new Plant(Plant.TYPE_WILD_GRASS);
			var oTile:Tile = Tile(oWorld.tiles[0][0]);
			oTile.plant = oPlant;
			
			FarmService.PlaceItemBldg(oFarm, oBldg, oLocation, oWorld);
			
			oResult.TestNotNull(oTile.plant);
			
			return oResult;
		}
		
		private static function PlaceItemBldgSetsBldgOrigin():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PlaceItemBldgSetsBldgOrigin");
			
			var oFarm:Farm = new Farm();
			var oBldg:ItemBldg = new CompostBin();
			var oLocation:GridLocation = new GridLocation(0, 1);
			var oWorld:World = new World(2, 2);
			
			FarmService.PlaceItemBldg(oFarm, oBldg, oLocation, oWorld);
			
			oResult.expected = oLocation.PrettyPrint();
			
			if (oBldg.origin == null)
			{
				oResult.actual = "ItemBldg origin not set.";
			}
			else
			{
				oResult.actual = oBldg.origin.PrettyPrint();
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function PlaceItemBldgAddsBldgToFarm():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PlaceItemBldgAddsBldgToFarm");
			
			var oFarm:Farm = new Farm();
			var oBldg:ItemBldg = new CompostBin();
			var oLocation:GridLocation = new GridLocation(0, 1);
			var oWorld:World = new World(2, 2);
			
			FarmService.PlaceItemBldg(oFarm, oBldg, oLocation, oWorld);
			
			oResult.expected = "1";
			oResult.actual = String(oFarm.itemBldgs.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function PlaceItemBldgTrueIfSuccessful():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "PlaceItemBldgTrueIfSuccessful");
			
			var oFarm:Farm = new Farm();
			var oBldg:ItemBldg = new CompostBin();
			var oLocation:GridLocation = new GridLocation(0, 1);
			var oWorld:World = new World(2, 2);
			
			oResult.TestTrue(FarmService.PlaceItemBldg(oFarm, oBldg, oLocation, oWorld));
			
			return oResult;
		}
		
		private static function DecomposeCompostOkIfNoFarm():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DecomposeCompostOkIfNoFarm");
			
			var oFarm:Farm = null;
			
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			try
			{
				FarmService.DecomposeCompost(oFarm);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DecomposeCompostDecrementsDecomposeDaysLeft():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DecomposeCompostDecrementsDecomposeDaysLeft");
			
			var oFarm:Farm = new Farm();
			var oCompostBin:CompostBin = new CompostBin();
			oFarm.AddBldg(oCompostBin);
			var oItem:PlantScrap = new PlantScrap(null, 0, 10);
			oCompostBin.compost.AddItemAt(oItem, 3);
			
			FarmService.DecomposeCompost(oFarm);
			
			oResult.expected = "9";
			oResult.actual = String(oItem.GetDecomposeDaysLeft());
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DecomposeCompostCreatesCompost():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DecomposeCompostCreatesCompost");
			
			var oFarm:Farm = new Farm();
			var oCompostBin:CompostBin = new CompostBin();
			oFarm.AddBldg(oCompostBin);
			var oItem:PlantScrap = new PlantScrap(new NutrientSet(50, 50, 50), 0, 1);
			oCompostBin.compost.AddItemAt(oItem, 3);
			
			FarmService.DecomposeCompost(oFarm);
			
			oResult.expected = "Compost";
			
			var oNewItem:Object = oCompostBin.compost.GetItemAt(3);
			
			oResult.actual = getQualifiedClassName(oNewItem);
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmTrueIfItemNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmTrueIfItemNull");
			var oFarm:Farm = null;
			var oItem:Item = null;
			
			oResult.expected = "true";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmFalseIfNoFarm():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmFalseIfNoFarm");
			var oFarm:Farm = null;
			var oItem:Item = new Fruit(Fruit.TYPE_PUMPKIN);
			
			oResult.expected = "false";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmTrueForFruit():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmTrueForFruit");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			var oItem:Item = new Fruit(Fruit.TYPE_PUMPKIN);
			
			oResult.expected = "true";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmFalseForFruit():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmFalseForFruit");
			var oFarm:Farm = new Farm();
			var oItem:Item = new Fruit(Fruit.TYPE_PUMPKIN);
			
			oResult.expected = "false";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmTrueForSeed():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmTrueForSeed");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			var oItem:Item = new Seed(Seed.TYPE_PUMPKIN);
			
			oResult.expected = "true";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmFalseForSeed():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmFalseForSeed");
			var oFarm:Farm = new Farm();
			var oItem:Item = new Seed(Seed.TYPE_PUMPKIN);
			
			oResult.expected = "false";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmTrueForTool():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmTrueForTool");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			var oItem:Item = new Tool(Tool.TYPE_HOE);
			
			oResult.expected = "true";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmFalseForTool():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmFalseForTool");
			var oFarm:Farm = new Farm();
			var oItem:Item = new Tool(Tool.TYPE_HOE);
			
			oResult.expected = "false";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmTrueForBagFertilizer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmTrueForBagFertilizer");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			var oItem:Item = new BagFertilizer(BagFertilizer.TYPE_STEADY_GREEN);
			
			oResult.expected = "true";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmFalseForBagFertilizer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmFalseForBagFertilizer");
			var oFarm:Farm = new Farm();
			var oItem:Item = new BagFertilizer(BagFertilizer.TYPE_STEADY_GREEN);
			
			oResult.expected = "false";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmFalseForPlant():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmFalseForPlant");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			var oItem:Item = new Plant(Plant.TYPE_PUMPKIN);
			
			oResult.expected = "false";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmTrueForItemBldg():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmTrueForItemBldg");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			var oItem:CompostBin = new CompostBin();
			
			oResult.expected = "true";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmFalseForItemBldg():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmFalseForItemBldg");
			var oFarm:Farm = new Farm();
			var oItem:CompostBin = new CompostBin();
			
			oResult.expected = "false";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmTrueForPlantScrap():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmTrueForPlantScrap");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			var oItem:Item = new PlantScrap();
			
			oResult.expected = "true";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmFalseForPlantScrap():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmFalseForPlantScrap");
			var oFarm:Farm = new Farm();
			var oItem:Item = new PlantScrap();
			
			oResult.expected = "false";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmTrueForCompost():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmTrueForCompost");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			oFarm.itemBldgs.push(new CompostBin());
			var oItem:Item = new Compost();
			
			oResult.expected = "true";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmFalseForCompost():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmFalseForCompost");
			var oFarm:Farm = new Farm();
			var oItem:Item = new Compost();
			
			oResult.expected = "false";
			oResult.actual = String(FarmService.DropItemOnFarm(oFarm, oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmPutsFruitInRootCellarFirst():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmPutsFruitInRootCellarFirst");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			var oItem:Item = new Fruit(Fruit.TYPE_PUMPKIN);
			
			FarmService.DropItemOnFarm(oFarm, oItem)
			
			oResult.expected = "1";
			oResult.actual = String(oFarm.rootCellar.food.GetNumItems());
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmPutsFruitInSaleCartSecond():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmPutsFruitInSaleCartSecond");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			oFarm.rootCellar = null;
			var oItem:Item = new Fruit(Fruit.TYPE_PUMPKIN);
			
			FarmService.DropItemOnFarm(oFarm, oItem)
			
			oResult.expected = "1";
			oResult.actual = String(oFarm.saleCart.contents.GetNumItems());
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmPutsFruitInCompostThird():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmPutsFruitInCompostThird");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			oFarm.rootCellar = null;
			oFarm.saleCart = null;
			var oCompostBin:CompostBin = new CompostBin();
			oFarm.itemBldgs.push(oCompostBin);
			var oItem:Item = new Fruit(Fruit.TYPE_PUMPKIN);
			
			FarmService.DropItemOnFarm(oFarm, oItem)
			
			oResult.expected = "1";
			oResult.actual = String(oCompostBin.compost.GetNumItems());
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmPutsFruitInGarbageFourth():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmPutsFruitInGarbageFourth");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			oFarm.rootCellar = null;
			oFarm.saleCart = null;
			var oItem:Item = new Fruit(Fruit.TYPE_PUMPKIN);
			
			FarmService.DropItemOnFarm(oFarm, oItem)
			
			oResult.expected = "1";
			oResult.actual = String(oFarm.house.garbage.GetNumItems());
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmPutsPlantScrapInCompostFirst():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmPutsPlantScrapInCompostFirst");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			var oCompostBin:CompostBin = new CompostBin();
			oFarm.itemBldgs.push(oCompostBin);
			var oItem:Item = new PlantScrap();
			
			FarmService.DropItemOnFarm(oFarm, oItem)
			
			oResult.expected = "1";
			oResult.actual = String(oCompostBin.compost.GetNumItems());
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropItemOnFarmPutsPlantScrapInGarbageSecond():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FarmService", "DropItemOnFarmPutsPlantScrapInGarbageSecond");
			var oFarm:Farm = FarmService.CreateBasicFarm(null, null, 0, 0, 0, 0);
			var oItem:Item = new PlantScrap();
			
			FarmService.DropItemOnFarm(oFarm, oItem);
			
			oResult.expected = "1";
			oResult.actual = String(oFarm.house.garbage.GetNumItems());
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}