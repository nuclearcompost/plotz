package
{
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class WorldService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function WorldService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function AddDailyWellWater(world:World):void
		{
			for (var i:int = 0; i < world.farms.length; i++)
			{
				var oFarm:Farm = Farm(world.farms[i]);
				
				WellService.AddDailyWellWater(oFarm.well);
			}
		}
		
		public static function AgeStoredFruit(world:World):void
		{
			for (var i:int = 0; i < world.farms.length; i++)
			{
				var oFarm:Farm = Farm(world.farms[i]);
				
				FarmService.AgeStoredFruit(oFarm);
			}
		}
		
		public static function CanPlayerInteractWithBuilding(player:Player, building:Bldg):Boolean
		{
			if (player == null)
			{
				return false;
			}
			
			if (building == null)
			{
				return false;
			}
			
			if (building is TownBldg)
			{
				return true;
			}
			
			var bCanInteract:Boolean = false;
			
			if (building is FarmBldg)
			{
				var oFarm:Farm = FarmBldg(building).farm;
				
				for (var f:int = 0; f < player.farms.length; f++)
				{
					var oCheckFarm:Farm = Farm(player.farms[f]);
					
					if (oCheckFarm == oFarm)
					{
						bCanInteract = true;
						break;
					}
				}
			}
			
			return bCanInteract;
		}
		
		public static function DailyFertilizerDischarge(world:World, calendarStatTracker:CalendarStatTracker):void
		{
			for (var x:int = 0; x < world.width; x++)
			{
				for (var y:int = 0; y < world.height; y++)
				{
					var oTile:Tile = Tile(world.tiles[x][y]);
					
					if (oTile == null)
					{
						continue;
					}
					
					var oSoil:Soil = oTile.soil;
					var oFertilizer:Fertilizer = oTile.fertilizer;
					
					if (oSoil == null || oFertilizer == null)
					{
						continue;
					}
					
					SoilService.DischargeFertilizer(oSoil, oFertilizer, calendarStatTracker);
					
					if (oFertilizer.daysLeft <= 0)
					{
						oTile.fertilizer = null;
					}
				}
			}
		}
		
		public static function DecomposeCompost(world:World):void
		{
			if (world == null)
			{
				return;
			}
			
			if (world.farms == null)
			{
				return;
			}
			
			for (var i:int = 0; i < world.farms.length; i++)
			{
				var oFarm:Farm = Farm(world.farms[i]);
				
				FarmService.DecomposeCompost(oFarm);
			}
		}
		
		public static function EmptyGarbage(world:World):void
		{
			if (world == null)
			{
				return;
			}
			
			if (world.farms == null)
			{
				return;
			}
			
			for (var i:int = 0; i < world.farms.length; i++)
			{
				var oFarm:Farm = Farm(world.farms[i]);
				
				FarmService.EmptyGarbage(oFarm);
			}
		}
		
		public static function ResetDailySoilAerationFlag(world:World):void
		{
			for (var x:int = 0; x < world.width; x++)
			{
				for (var y:int = 0; y < world.height; y++)
				{
					var oTile:Tile = Tile(world.tiles[x][y]);
					
					if (oTile == null)
					{
						continue;
					}
					
					var oSoil:Soil = oTile.soil;
					
					if (oSoil != null)
					{
						oSoil.aeratedToday = false;
					}
				}
			}
		}
		
		public static function RunMicrobeActions(world:World):void
		{
			for (var x:int = 0; x < world.width; x++)
			{
				for (var y:int = 0; y < world.height; y++)
				{
					var oTile:Tile = Tile(world.tiles[x][y]);
					
					if (oTile == null)
					{
						continue;
					}
					
					var oSoil:Soil = oTile.soil;
					var oPlant:Plant = oTile.plant;
					var oFertilizer:Fertilizer = oTile.fertilizer;
					
					MicrobeService.UpdatePopulation(oSoil, oPlant, oFertilizer);
					MicrobeService.RunActions(oSoil, oFertilizer);
				}
			}
		}
		
		public static function SetFutureHarvestEvents(world:World, player:Player, calendarStatTracker:CalendarStatTracker):void
		{
			// clear all existing FutureHarvestEvents from the tracker
			calendarStatTracker.ClearAllEventsOfType(DayEvent.TYPE_FUTURE_HARVEST);
			
			// set new FutureHarvestEvents
			for (var i:int = 0; i < world.farms.length; i++)
			{
				var oFarm:Farm = Farm(world.farms[i]);
				
				if (oFarm.owner != player)
				{
					continue;
				}
				
				for (var x:int = oFarm.left; x <= oFarm.right; x++)
				{
					for (var y:int = oFarm.top; y <= oFarm.bottom; y++)
					{
						var oTile:Tile = Tile(world.tiles[x][y]);
						
						if (oTile == null)
						{
							continue;
						}
						
						var oPlant:Plant = oTile.plant;
						
						if (oPlant == null)
						{
							continue;
						}
						
						var iDaysToHarvest:int = oPlant.GetPredictedDaysToHarvest();
						
						if (iDaysToHarvest < 1)
						{
							continue;
						}
						
						var oHarvestTime:Time = TimeService.GetFutureDate(calendarStatTracker.gameTime, iDaysToHarvest);
						
						var oFutureHarvestEvent:FutureHarvestEvent = new FutureHarvestEvent(oPlant.type, oHarvestTime, 1);
						calendarStatTracker.AddEvent(oFutureHarvestEvent);
					}
				}
			}
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(WorldService.CanPlayerInteractWithBuildingFalseIfNoPlayer());
			lResults.push(WorldService.CanPlayerInteractWithBuildingFalseIfNoBldg());
			lResults.push(WorldService.CanPlayerInteractWithBuildingTrueForTownBldg());
			lResults.push(WorldService.CanPlayerInteractWithBuildingTrueForOwnFarmBldg());
			lResults.push(WorldService.CanPlayerInteractWithBuildingFalseForOtherFarmBldg());
			
			lResults = lResults.concat(WorldService.TestAddDailyWellWater());
			
			lResults = lResults.concat(WorldService.SetFutureHarvestEventsClearsExistingFutureHarvestEvents());
			lResults.push(WorldService.SetFutureHarvestEventsErrorsIfWorldNull());
			lResults.push(WorldService.SetFutureHarvestEventsErrorsIfCalendarStatTrackerNull());
			lResults.push(WorldService.SetFutureHarvestEventsDoesNothingForNonOwnedFarm());
			lResults.push(WorldService.SetFutureHarvestEventsDoesNothingForReadyToHarvestPlants());
			lResults = lResults.concat(WorldService.SetFutureHarvestEventsAddsEvents());
			
			return lResults;
		}
		
		private static function CanPlayerInteractWithBuildingFalseIfNoBldg():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("WorldService", "CanPlayerInteractWithBuildingFalseIfNoBldg");
			
			var oBldg:Bldg = null;
			
			var oPlayer:Player = new Player();
			
			oResult.TestFalse(WorldService.CanPlayerInteractWithBuilding(oPlayer, oBldg));
			
			return oResult;
		}
		
		private static function CanPlayerInteractWithBuildingFalseIfNoPlayer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("WorldService", "CanPlayerInteractWithBuildingFalseIfNoPlayer");
			
			var oBldg:Bldg = new ItemShop();
			
			var oPlayer:Player = null;
			
			oResult.TestFalse(WorldService.CanPlayerInteractWithBuilding(oPlayer, oBldg));
			
			return oResult;
		}
		
		private static function CanPlayerInteractWithBuildingTrueForTownBldg():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("WorldService", "CanPlayerInteractWithBuildingTrueForTownBldg");
			
			var oBldg:Bldg = new ItemShop();
			
			var oPlayer:Player = new Player();
			
			oResult.TestTrue(WorldService.CanPlayerInteractWithBuilding(oPlayer, oBldg));
			
			return oResult;
		}
		
		private static function CanPlayerInteractWithBuildingTrueForOwnFarmBldg():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("WorldService", "CanPlayerInteractWithBuildingTrueForOwnFarmBldg");
			
			var oFarm:Farm = new Farm();
			var oBldg:Bldg = new ToolShed(null, oFarm);
			var oFarmBldg:FarmBldg = FarmBldg(oBldg);
			oFarmBldg.farm = oFarm;
			var oPlayer:Player = new Player("", 0, oFarm, null, [ oFarm ]);
			oFarm.owner = oPlayer;
			
			oResult.TestTrue(WorldService.CanPlayerInteractWithBuilding(oPlayer, oBldg));
			
			return oResult;
		}
		
		private static function CanPlayerInteractWithBuildingFalseForOtherFarmBldg():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("WorldService", "CanPlayerInteractWithBuildingFalseForOtherFarmBldg");
			
			var oFarm:Farm = new Farm();
			var oBldg:Bldg = new ToolShed(null, oFarm);
			var oFarmBldg:FarmBldg = FarmBldg(oBldg);
			oFarmBldg.farm = oFarm;
			var oPlayer:Player = new Player();
			var oOtherPlayer:Player = new Player("", 0, oFarm, null, [ oFarm ]);
			oFarm.owner = oOtherPlayer;
			
			oResult.TestFalse(WorldService.CanPlayerInteractWithBuilding(oPlayer, oBldg));
			
			return oResult;
		}
		
		private static function TestAddDailyWellWater():Array
		{
			var oFirstWellResult:UnitTestResult = new UnitTestResult("WorldService", "TestAddDailyWellWater - First Well");
			var oSecondWellResult:UnitTestResult = new UnitTestResult("WorldService", "TestAddDailyWellWater - Second Well");
			var lResults:Array = [ oFirstWellResult, oSecondWellResult ];
			
			var oWorld:World = new World();
			var oFirstFarm:Farm = new Farm();
			var oFirstWell:Well = new Well();
			oFirstWell.amount = 0;
			oFirstFarm.AddBldg(oFirstWell);
			oWorld.AddFarm(oFirstFarm);
			
			var oSecondFarm:Farm = new Farm();
			var oSecondWell:Well = new Well();
			oSecondWell.amount = 1;
			oSecondFarm.AddBldg(oSecondWell);
			oWorld.AddFarm(oSecondFarm);
			
			oFirstWellResult.expected = String(oFirstWell.amount + WellService.GetDailyAmount(oFirstWell));
			oSecondWellResult.expected = String(oSecondWell.amount + WellService.GetDailyAmount(oSecondWell));
			
			WorldService.AddDailyWellWater(oWorld);
			
			oFirstWellResult.actual = String(oFirstWell.amount);
			oFirstWellResult.TestEquals();
			
			oSecondWellResult.actual = String(oSecondWell.amount);
			oSecondWellResult.TestEquals();
			
			return lResults;
		}
		
		// WorldService.SetFutureHarvestEvents(world, player, calendarStatTracker);
		
		private static function SetFutureHarvestEventsClearsExistingFutureHarvestEvents():Array
		{
			var oNumEventsResult:UnitTestResult = new UnitTestResult("WorldService", "SetFutureHarvestEventsClearsExistingFutureHarvestEvents - Number of Events");
			var oEvent1Result:UnitTestResult = new UnitTestResult("WorldService", "SetFutureHarvestEventsClearsExistingFutureHarvestEvents - Event 1");
			var lResults:Array = [ oNumEventsResult, oEvent1Result ];
			
			var oWorld:World = new World();
			var oPlayer:Player = new Player();
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			oCalendarStatTracker.events.push(new FutureHarvestEvent(Fruit.TYPE_ASPARAGUS));
			oCalendarStatTracker.events.push(new WeatherEvent(Weather.TYPE_HOT));
			
			WorldService.SetFutureHarvestEvents(oWorld, oPlayer, oCalendarStatTracker);
			
			oNumEventsResult.expected = "1";
			oNumEventsResult.actual = String(oCalendarStatTracker.events.length);
			oNumEventsResult.TestEquals();
			
			oEvent1Result.expected = String(DayEvent.TYPE_WEATHER);
			oEvent1Result.actual = "No events";
			
			if (oCalendarStatTracker.events.length > 0)
			{
				var oDayEvent:DayEvent = DayEvent(oCalendarStatTracker.events[0]);
				oEvent1Result.actual = String(oDayEvent.eventType);
			}
			
			oEvent1Result.TestEquals();
			
			return lResults;
		}
		
		private static function SetFutureHarvestEventsErrorsIfWorldNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("WorldService", "SetFutureHarvestEventsErrorsIfWorldNull");
			var oWorld:World = null;
			var oPlayer:Player = new Player();
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			
			oResult.expected = "Got exception";
			oResult.actual = "No exception";
			
			try
			{
				WorldService.SetFutureHarvestEvents(oWorld, oPlayer, oCalendarStatTracker);
			}
			catch (e:Error)
			{
				oResult.actual = "Got exception";
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function SetFutureHarvestEventsErrorsIfCalendarStatTrackerNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("WorldService", "SetFutureHarvestEventsErrorsIfCalendarStatTrackerNull");
			var oWorld:World = new World();
			var oPlayer:Player = new Player();
			var oCalendarStatTracker:CalendarStatTracker = null;
			
			oResult.expected = "Got exception";
			oResult.actual = "No exception";
			
			try
			{
				WorldService.SetFutureHarvestEvents(oWorld, oPlayer, oCalendarStatTracker);
			}
			catch (e:Error)
			{
				oResult.actual = "Got exception";
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function SetFutureHarvestEventsDoesNothingForNonOwnedFarm():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("WorldService", "SetFutureHarvestEventsDoesNothingForNonOwnedFarm");
			var oWorld:World = new World(5, 6);
			var oPlayer:Player = new Player();
			var oOtherPlayer:Player = new Player();
			var oFarm:Farm = new Farm("", oOtherPlayer, oWorld, 5, 7, 2, 4);
			oWorld.AddFarm(oFarm);
			var oTile:Tile = Tile(oWorld.tiles[2][7]);
			oTile.plant = new Plant(Plant.TYPE_ASPARAGUS, Plant.STAGE_GROWING);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			
			WorldService.SetFutureHarvestEvents(oWorld, oPlayer, oCalendarStatTracker);
			
			oResult.expected = "0";
			oResult.actual = String(oCalendarStatTracker.events.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function SetFutureHarvestEventsDoesNothingForReadyToHarvestPlants():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("WorldService", "SetFutureHarvestEventsDoesNothingForReadyToHarvestPlants");
			var oWorld:World = new World(5, 6);
			var oPlayer:Player = new Player();
			var oOtherPlayer:Player = new Player();
			var oFarm:Farm = new Farm("", oOtherPlayer, oWorld, 5, 7, 2, 4);
			oWorld.AddFarm(oFarm);
			var oTile:Tile = Tile(oWorld.tiles[2][7]);
			oTile.plant = new Plant(Plant.TYPE_ASPARAGUS, Plant.STAGE_READY_FOR_HARVEST);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			
			WorldService.SetFutureHarvestEvents(oWorld, oPlayer, oCalendarStatTracker);
			
			oResult.expected = "0";
			oResult.actual = String(oCalendarStatTracker.events.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function SetFutureHarvestEventsAddsEvents():Array
		{
			var oNumEventsResult:UnitTestResult = new UnitTestResult("WorldService", "SetFutureHarvestEventsAddsEvents - Number of Events");
			var oEvent1Result:UnitTestResult = new UnitTestResult("WorldService", "SetFutureHarvestEventsAddsEvents - Event 1");
			var lResults:Array = [ oNumEventsResult, oEvent1Result ];
			
			var oWorld:World = new World(5, 6);
			var oPlayer:Player = new Player();
			var oFarm:Farm = new Farm("", oPlayer, oWorld, 5, 7, 2, 4);
			oWorld.AddFarm(oFarm);
			var oTile:Tile = Tile(oWorld.tiles[2][7]);
			oTile.plant = new Plant(Plant.TYPE_ASPARAGUS, Plant.STAGE_GROWING);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			
			WorldService.SetFutureHarvestEvents(oWorld, oPlayer, oCalendarStatTracker);
			
			oNumEventsResult.expected = "1";
			oNumEventsResult.actual = String(oCalendarStatTracker.events.length);
			oNumEventsResult.TestEquals();
			
			oEvent1Result.expected = String(DayEvent.TYPE_FUTURE_HARVEST);
			oEvent1Result.actual = "No events";
			
			if (oCalendarStatTracker.events.length > 0)
			{
				var oDayEvent:DayEvent = DayEvent(oCalendarStatTracker.events[0]);
				oEvent1Result.actual = String(oDayEvent.eventType);
			}
			
			oEvent1Result.TestEquals();
			
			return lResults;
		}
		
		//- Testing Methods -//
	}
}