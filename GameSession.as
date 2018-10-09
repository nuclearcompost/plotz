package
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	import flash.utils.Timer;
	
	//-----------------------
	//Purpose:				A single session of the game
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class GameSession
	{
		registerClassAlias("Address", Address);
		registerClassAlias("BagFertilizer", BagFertilizer);
		registerClassAlias("Bldg", Bldg);
		registerClassAlias("CalendarState", CalendarState);
		registerClassAlias("CalendarStatTracker", CalendarStatTracker);
		registerClassAlias("ChildMenuFrame", ChildMenuFrame);
		registerClassAlias("Cloud", Cloud);
		registerClassAlias("Compost", Compost);
		registerClassAlias("CompostBin", CompostBin);
		registerClassAlias("CsaCustomer", CsaCustomer);
		registerClassAlias("CsaState", CsaState);
		registerClassAlias("CustomDayEvent", CustomDayEvent);
		registerClassAlias("CustomHarvestEvent", CustomHarvestEvent);
		registerClassAlias("CustomPlantEvent", CustomPlantEvent);
		registerClassAlias("DayEvent", DayEvent);
		registerClassAlias("Farm", Farm);
		registerClassAlias("FarmBldg", FarmBldg);
		registerClassAlias("Fence", Fence);
		registerClassAlias("Fertilizer", Fertilizer);
		registerClassAlias("Fruit", Fruit);
		registerClassAlias("FruitHarvestedEvent", FruitHarvestedEvent);
		registerClassAlias("FutureHarvestEvent", FutureHarvestEvent);
		registerClassAlias("GridArea", GridArea);
		registerClassAlias("GridLocation", GridLocation);
		registerClassAlias("Home", Home);
		registerClassAlias("Horizon", Horizon);
		registerClassAlias("House", House);
		registerClassAlias("IFertilizerSource", IFertilizerSource);
		registerClassAlias("Inventory", Inventory);
		registerClassAlias("Item", Item);
		registerClassAlias("ItemBldg", ItemBldg);
		registerClassAlias("ItemShop", ItemShop);
		registerClassAlias("ItemShopPurchaseEvent", ItemShopPurchaseEvent);
		registerClassAlias("ItemShopSaleEvent", ItemShopSaleEvent);
		registerClassAlias("Mailbox", Mailbox);
		registerClassAlias("MenuState", MenuState);
		registerClassAlias("Microbe", Microbe);
		registerClassAlias("NutrientSet", NutrientSet);
		registerClassAlias("ParentMenuFrame", ParentMenuFrame);
		registerClassAlias("PixelLocation", PixelLocation);
		registerClassAlias("Plant", Plant);
		registerClassAlias("PlantKilledEvent", PlantKilledEvent);
		registerClassAlias("PlantScrap", PlantScrap);
		registerClassAlias("Player", Player);
		registerClassAlias("PopUpMenu", PopUpMenu);
		registerClassAlias("RectGridLocation", RectGridLocation);
		registerClassAlias("RootCellar", RootCellar);
		registerClassAlias("SaleCart", SaleCart);
		registerClassAlias("SaleCartSaleEvent", SaleCartSaleEvent);
		registerClassAlias("Seed", Seed);
		registerClassAlias("SeedPlantedEvent", SeedPlantedEvent);
		registerClassAlias("Soil", Soil);
		registerClassAlias("StatTracker", StatTracker);
		registerClassAlias("Sun", Sun);
		registerClassAlias("Terrain", Terrain);
		registerClassAlias("Tile", Tile);
		registerClassAlias("Time", Time);
		registerClassAlias("Tool", Tool);
		registerClassAlias("ToolShed", ToolShed);
		registerClassAlias("Town", Town);
		registerClassAlias("TownBldg", TownBldg);
		registerClassAlias("Weather", Weather);
		registerClassAlias("WeatherEvent", WeatherEvent);
		registerClassAlias("Well", Well);
		registerClassAlias("WellAmountEvent", WellAmountEvent);
		registerClassAlias("World", World);
		
		// Programming Metadata //
		public static const CURRENT_REVISION_NUMBER:String = "17";
		public static const SAVE_GAME_NAME:String = "PlotzCoreData6.1";
		
		// Other Constants
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get activePlayer():Player
		{
			return _activePlayer;
		}
		
		public function set activePlayer(value:Player):void
		{
			_activePlayer = value;
		}
		
		public function get calendarState():CalendarState
		{
			return _calendarState;
		}
		
		public function set calendarState(value:CalendarState):void
		{
			_calendarState = value;
		}
		
		public function get calendarStatTracker():CalendarStatTracker
		{
			return _calendarStatTracker;
		}
		
		public function set calendarStatTracker(value:CalendarStatTracker):void
		{
			_calendarStatTracker = value;
		}
		
		public function get dayTimer():Timer
		{
			return _dayTimer;
		}
		
		public function get footer():Footer
		{
			return _footer;
		}
		
		public function get gameRoot():GameRoot
		{
			return _gameRoot;
		}
		
		public function get itemPricingService():ItemPricingService
		{
			return _itemPricingService;
		}
		
		public function get menuState():MenuState
		{
			return _menuState;
		}
		
		public function set menuState(value:MenuState):void
		{
			_menuState = value;
		}
		
		public function get mouseOverUIPanel():MouseOverUIPanel
		{
			return _mouseOverUIPanel;
		}
		
		public function set mouseOverUIPanel(value:MouseOverUIPanel):void
		{
			_mouseOverUIPanel = value;
		}
		
		public function get players():Array
		{
			return _players;
		}
		
		public function set players(value:Array):void
		{
			_players = value;
		}
		
		public function get replayingTutorial():Boolean
		{
			return _replayingTutorial;
		}
		
		public function set replayingTutorial(value:Boolean):void
		{
			_replayingTutorial = value;
		}
		
		public function get statTracker():StatTracker
		{
			return _statTracker;
		}
		
		public function get time():Time
		{
			return _time;
		}
		
		public function set time(value:Time):void
		{
			_time = value;
		}
		
		public function get tutorialStep():int
		{
			return _tutorialStep;
		}
		
		public function set tutorialStep(value:int):void
		{
			_tutorialStep = value;
		}
		
		public function get uiManager():UIManager
		{
			return _uiManager;
		}
		
		public function get world():World
		{
			return _world;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		/// Data Properties ///
		
		private var _activePlayer:Player;
		private var _calendarState:CalendarState;
		private var _calendarStatTracker:CalendarStatTracker;
		private var _dayTimer:Timer;
		private var _footer:Footer;
		private var _gameRoot:GameRoot;
		private var _itemPricingService:ItemPricingService;
		private var _menuState:MenuState;
		private var _mouseOverUIPanel:MouseOverUIPanel;
		private var _notificationService:NotificationService;
		private var _players:Array;
		private var _precipitationService:PrecipitationService;
		private var _replayingTutorial:Boolean;
		private var _statTracker:StatTracker;
		private var _time:Time;
		private var _tutorialStep:int;
		private var _uiManager:UIManager;
		private var _world:World;
		
		///- Data Properties -///
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		Construct a new GameSession object
		//
		//Parameters:
		//	gameRoot:GameRoot = back-pointer to the root
		//	newGame:Boolean = true if we should start a new game; false if we should load a saved game
		//	useMonth:Boolean { true } = if true, have each season be 3 months long; if false, have each season be only 1 month long
		//
		//Returns:		reference to the new object
		//---------------
		public function GameSession(gameRoot:GameRoot, newGame:Boolean, useMonth:Boolean = true)
		{
			_gameRoot = gameRoot;
			
			InitializeGameSession();
			
			InitializeCommonGameState();
			
			if (newGame)
			{
				 InitializeTheWorldForTutorial();
			}
			else
			{
				LoadGame(false);
				_tutorialStep = -1;
			}
			
			_uiManager.RepaintAll();
		}
		
		//---------------
		//Purpose:		Set up all data for the game session needed whether starting a new game or loading an existing game
		//
		//Parameters:
		//	none
		//
		//Returns:		void
		//---------------
		private function InitializeGameSession():void
		{
			_uiManager = new UIManager(_gameRoot, this);
			
			_notificationService = new NotificationService(_uiManager);
			_precipitationService = new PrecipitationService(this, _uiManager);
			
			_mouseOverUIPanel = new MouseOverUIPanel();
			
			var oCalendarButton:FooterButton = new FooterButton(FooterButton.TYPE_CALENDAR);
			_footer = new Footer([ new FooterButton(FooterButton.TYPE_WATERING_CAN), new FooterButton(FooterButton.TYPE_SICKLE), new FooterButton(FooterButton.TYPE_HOE),
									new FooterButton(FooterButton.TYPE_MAGNIFYING_GLASS), new FooterButton(FooterButton.TYPE_CALENDAR), null, null, null ]);
			
		}
		
		public function InitializeCommonGameState():void
		{
			_menuState = new MenuState();
			
			InitializePlayers();
			
			InitializeWorld();
			
			InitializeTime();
			
			_tutorialStep = -1;
			_replayingTutorial = false;
		}
		
		private function InitializePlayers():void
		{
			_players = new Array();
			var oHuman:Player = new Player("Billie Jean", 200);
			_players.push(oHuman);
			
			_activePlayer = oHuman;
		}
		
		private function InitializeWorld():void
		{
			_world = new World(14, 22);
			
			InitializeTowns();
			InitializeFarms();
		}
		
		private function InitializeTowns():void
		{
			var iTop:int = 17;
			var iBottom:int = 19;
			var iLeft:int = 22;
			var iRight:int = 25;
			
			var oTown:Town = new Town("Springtown", _world, iTop, iBottom, iLeft, iRight);
			_world.AddTown(oTown);
			
			// Item Shop
			var oItemShop:ItemShop = new ItemShop(new GridLocation(iLeft, iBottom), oTown);			
			oTown.AddBldg(oItemShop);
			
			// Homes
			var lStreetNames:Array = [ "Oak Street", "Ash Lane", "Elm Avenue", "Willow Road" ];
			
			for (var street:int = 0; street < lStreetNames.length; street++)
			{
				for (var number:int = 101; number < 111; number++)
				{
					var oAddress:Address = new Address(String(number), lStreetNames[street], oTown);
					var oHome:Home = new Home(new GridLocation(0, 0), oTown, oAddress);
					oTown.AddBldg(oHome);
				}
			}
		}
		
		private function InitializeFarms():void
		{
			var iTop:int = 13;
			var iBottom:int = 24;
			var iLeft:int = 10;
			var iRight:int = 20;
			
			// human player's farm
			var oFarm:Farm = FarmService.CreateBasicFarm(_activePlayer, _world, iTop, iBottom, iLeft, iRight);
			_activePlayer.AddFarm(oFarm);
			_world.AddFarm(oFarm);
			
			for (var x:int = iLeft; x <= iRight; x++)
			{
				for (var y:int = iTop; y <= iBottom; y++)
				{
					var oTile:Tile = Tile(_world.tiles[x][y]);
					oTile.soil.isPlayerOwned = true;
				}
			}
		}
		
		private function InitializeTime():void
		{
			_time = new Time();
			_itemPricingService = new ItemPricingService(_time);
			
			// day timer - fire every 1/3 second
			_dayTimer = new Timer(333);
			_dayTimer.addEventListener(TimerEvent.TIMER, OnDayTimer, false, 0, true);
			_dayTimer.start();
		}
		
		private function InitializeTheWorldForTutorial():void
		{
			// General stats
			_activePlayer.cash = 0;
			
			_time = new Time(50, 0, Time.MONTH_APR, 1, Time.DAY_MONDAY, Time.SEASON_SPRING, false);

			_world.weather = new Weather(new Array(9, 8, 6, 3, 1, 0), 4.5, 1, 0, 0);
			_world.horizon = new Horizon();
			
			// Stat Tracking
			_statTracker = new StatTracker();
			_calendarStatTracker = new CalendarStatTracker();
			
			// soil initialization
			SoilSubstrateInitializer.InitializeSoil(_world.tiles);
			SoilNutrientInitializer.InitializeSoil(_world.tiles);
			
			// block of soil for tutorial plant:
			var oTile:Tile = Tile(_world.tiles[11][18]);
			var oSoil:Soil = oTile.soil;
			oSoil.substrate = Substrate.TYPE_LOAM;
			oSoil.nutrient1 = 350;
			oSoil.nutrient2 = 350;
			oSoil.nutrient3 = 350;
			
			// Bldgs
			var oShed:ToolShed = _activePlayer.activeFarm.toolShed;
			oShed.tools.ClearAllItems();
			oShed.tools.AddItem(new Tool(Tool.TYPE_WATERING_CAN));
			oShed.tools.AddItem(new Tool(Tool.TYPE_SICKLE));
			oShed.tools.AddItem(new Tool(Tool.TYPE_HOE));
			oShed.tools.AddItem(new Seed(Seed.TYPE_ONION));
			oShed.tools.AddItem(new BagFertilizer(BagFertilizer.TYPE_STEADY_GREEN));
			
			_tutorialStep = 0;
			_dayTimer.stop();
			
			// Run beginning-of-day logic for the first day
			BeginDay();
		}
	
		//---------------
		//Purpose:		Set up all data for the world at the beginning of a new game.
		//
		//Parameters:
		//	none
		//
		//Returns:		void
		//---------------
		public function InitializeTheWorldForNewGame():void
		{
			// General stats
			_activePlayer.cash = 200;
			
			// start of new game
			_time = new Time(0, 0, Time.SEASON_SPRING, 1, Time.DAY_MONDAY, Time.SEASON_SPRING, false);

			// start of summer
			//_time = new Time(0, 0, Time.SEASON_SUMMER, 1, Time.DAY_MONDAY, Time.SEASON_SUMMER, false);
			
			// start of fall
			//_time = new Time(0, 0, Time.SEASON_FALL, 1, Time.DAY_MONDAY, Time.SEASON_FALL, false);
			
			//end of season date:
			// time, date, month, year, day, season, useMonth
			//_time = new Time(0, 26, Time.SEASON_FALL, 1, Time.DAY_SATURDAY, Time.SEASON_FALL, false);
			
			_world.weather = new Weather(new Array(9, 8, 6, 3, 1, 0), 4.5);
			_world.horizon = new Horizon();
			
			// Stat Tracking
			_statTracker = new StatTracker();
			_calendarStatTracker = new CalendarStatTracker(_time);
			
			// Calendar
			var oCalendarTime:Time = _time.GetClone();
			_calendarState = new CalendarState(_time, _calendarStatTracker, oCalendarTime);
			
			// soil initialization
			SoilSubstrateInitializer.InitializeSoil(_world.tiles);
			SoilNutrientInitializer.InitializeSoil(_world.tiles);
			
			// Bldgs
			var oShed:ToolShed = _activePlayer.activeFarm.toolShed;
			oShed.tools.ClearAllItems();
			oShed.tools.AddItem(new Tool(Tool.TYPE_WATERING_CAN, 20));
			oShed.tools.AddItem(new Tool(Tool.TYPE_SICKLE));
			oShed.tools.AddItem(new Tool(Tool.TYPE_HOE));
			oShed.tools.AddItem(new Seed(Seed.TYPE_ALFALFA));
			oShed.tools.AddItem(new Seed(Seed.TYPE_ALFALFA));
			oShed.tools.AddItem(new Seed(Seed.TYPE_LETTUCE));
			oShed.tools.AddItem(new Seed(Seed.TYPE_LETTUCE));
			oShed.tools.AddItem(new BagFertilizer(BagFertilizer.TYPE_STEADY_GREEN));
			oShed.tools.AddItem(new BagFertilizer(BagFertilizer.TYPE_STEADY_ORANGE));
			oShed.tools.AddItem(new BagFertilizer(BagFertilizer.TYPE_STEADY_BLUE));
			
			// Run beginning-of-day logic for the first day
			BeginDay();
		}
		
		// This function is very fucked up because Flash likes to suck.
		// Somehow the game gets saved correctly (and the save file is flushed and closed), but then the Initialize function changes the save file values,
		//  like there's somehow a reference between a closed file and local memory or some shit.
		// The exact same save and load code seems to work under other conditions with user events firing it at different times.
		// I tested the shit out of every possibility I could think of but could not come up with any coherent logic to explain WTFBBQ is going on, and
		//  interwebs searches proved equally worthless.
		// The only possibly thread of hope I could find was the IExternalizable interface,  but it would require reworking the save and load logic for
		//  every single custom object.
		public function ReplayTutorial():void
		{
			_replayingTutorial = true;
			MenuService.CloseParentAndChildMenus(_menuState);
			
			SaveGame(false);
			
			InitializeTheWorldForTutorial();
			
			_uiManager.RepaintAll();
		}
		
		//- Initialization -//
		
		
		// Public Methods //
		
		/// Core Gameplay Methods ///
		
		public function AdvanceDay():void
		{
			EndDay();
			BeginDay();
			_uiManager.RepaintAll();
		}
		
		//---------------
		//Purpose:		Run logic for the beginning of the current day
		//
		//Parameters:
		//	none
		//
		//Returns:		void
		//---------------
		public function BeginDay():void
		{
			// reset the daily timer
			if (_tutorialStep == -1)
			{
				_time.time = 0;
			}
			
			// daily amount of water added to the well
			WorldService.AddDailyWellWater(_world);
			
			// set weather for the new day
			SetupTodaysWeather();
			_world.horizon.SetUpForWeather(_world.weather.current, _time.time);
			
			// handle daily changes to the soil
			WorldService.ResetDailySoilAerationFlag(_world);
			WorldService.DailyFertilizerDischarge(_world, _calendarStatTracker);
			
			// handle special CSA days
			var iCsaDayType:int = CsaService.GetCsaDayType(_time);
			
			for (var p:int = 0; p < _players.length; p++)
			{
				var oPlayer:Player = Player(_players[p]);
				
				if (iCsaDayType == CsaState.DAY_TYPE_SIGNUP)
				{
					CsaService.CreateNewCustomers(oPlayer.csaState, _world.towns);
				}
			}
			
			// predict harvest days for current plants
			WorldService.SetFutureHarvestEvents(_world, _activePlayer, _calendarStatTracker);
			
			// show notifications for the new day
			if (_tutorialStep == -1)
			{
				_notificationService.AddNotificationsForToday(_time, _calendarStatTracker, _activePlayer.csaState);
			}
			
			// special updates for the tutorial
			var iId:int = TutorialStep.GetIdForStepNumber(_tutorialStep);
			var oTile:Tile = Tile(_world.tiles[11][18]);
			
			switch (iId)
			{
				case 8:
					oTile.soil.saturation = 42.9;
					break;
				case 13:
					oTile.soil.saturation = 64.1;
					break;
				case 18:
					PlayerService.DropActiveItem(_activePlayer);
					oTile.soil.nutrient2 = 0.2;
					break;
				case 26:
					oTile.plant.growthStage = Plant.STAGE_READY_FOR_HARVEST;
					oTile.plant.fruit = new Fruit(Fruit.TYPE_ONION, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
					_uiManager.RepaintAll();
					break;
				case 35:
					_activePlayer.cash = 56;
					break;
				default:
					break;
			}
		}
		
		//---------------
		//Purpose:		End the current day and advance to the next one
		//
		//Parameters:
		//	none
		//
		//Returns:		void
		//---------------
		public function EndDay():void
		{
			var lDeadPlants:Array = new Array();
			
			WorldService.RunMicrobeActions(_world);
			
			for (var x:int = 0; x < _world.width; x++)
			{
				for (var y:int = 0; y < _world.height; y++)
				{
					var oTile:Tile = Tile(_world.tiles[x][y]);
					
					if (oTile == null)
					{
						continue;
					}
					
					var oSoil:Soil = oTile.soil;
					var oFertilizer:Fertilizer = oTile.fertilizer;
					var oPlant:Plant = oTile.plant;
					
					// plant growth
					if (oPlant != null)
					{
						// have plants try to grow
						var bStillAlive:int = oPlant.Grow(oSoil, _time.season);
						
						if (bStillAlive < 0)
						{
							lDeadPlants[lDeadPlants.length] = new PixelLocation(x, y);
							oTile.plant = null;
							
							if (Plant.GetClass(oPlant.type) != Plant.CLASS_COVER)
							{
								_statTracker.plantsKilled++;
								
								if (bStillAlive == -1)
								{
									_calendarStatTracker.AddEventToday(new PlantKilledEvent(oPlant.type, -1, null, 1));
								}
								else if (bStillAlive == -2)
								{
									_calendarStatTracker.AddEventToday(new PlantKilledEvent(oPlant.type, -2, null, 1));
								}
								else if (bStillAlive == -3)
								{
									_calendarStatTracker.AddEventToday(new PlantKilledEvent(oPlant.type, -3, null, 1));
								}
							}
						}
						else
						{
							// have growing fruit grow older
							if (oPlant.fruit != null)
							{
								oPlant.fruit.Grow(oSoil);
							}
						}
					}
					
					// natural soil drainage
					oSoil.Drain();
				}
			}
			
			// for soil with no current plant, roll to start growing wild grass there
			for (x = 0; x < _world.width; x++)
			{
				for (y = 0; y < _world.height; y++)
				{
					oTile = Tile(_world.tiles[x][y]);
					
					if (oTile == null)
					{
						continue;
					}
					
					var oTerrain:Terrain = oTile.terrain;
					var oPlantScrap:PlantScrap = oTile.plantScrap;
					oPlant = oTile.plant;
					
					if (oTerrain != null)
					{
						continue;
					}
					
					if (oPlantScrap != null)
					{
						continue;
					}
					
					if (oPlant == null)
					{
						var bDiedThisTurn:Boolean = false;
						
						// make sure the plant didn't die this turn, b/c we never want an instant respawn
						for (var i:int = 0; i < lDeadPlants.length; i++)
						{
							var oDeadPlantLocation:PixelLocation = PixelLocation(lDeadPlants[i]);
							
							if (x == oDeadPlantLocation.x && y == oDeadPlantLocation.y)
							{
								bDiedThisTurn = true;
								break;
							}
						}
						
						if (bDiedThisTurn == false)
						{
							var iChanceForRespawn:int = Math.floor(Math.random() * 10);
							
							if (iChanceForRespawn == 3)
							{
								oTile.plant = new Plant(Plant.TYPE_WILD_GRASS);
							}
						}
					}
				}
			}
					
			// count total well water
			var nWellWater:Number = _activePlayer.activeFarm.well.amount;			
			_calendarStatTracker.AddEventToday(new WellAmountEvent(nWellWater));

			// sell things from the sale cart
			EconomyService.SellFromSaleCart(_activePlayer.activeFarm.saleCart, _activePlayer, _time.day, _itemPricingService, _statTracker, _calendarStatTracker);
			
			// age all fruit stored in sale carts and root cellars
			WorldService.AgeStoredFruit(_world);
			
			// have compost break down a bit more
			WorldService.DecomposeCompost(_world);
			
			// do garbage collection on fridays
			if (_time.day == Time.DAY_FRIDAY)
			{
				WorldService.EmptyGarbage(_world);
			}
			
			// handle special csa days
			var iCsaDayType:int = CsaService.GetCsaDayType(_time);
			
			for (var p:int = 0; p < _players.length; p++)
			{
				var oPlayer:Player = Player(_players[p]);
				
				if (iCsaDayType == CsaState.DAY_TYPE_SIGNUP)
				{
					var iHalfPayment:int = CsaService.GetHalfPaymentAmount(_time.season);
					var iNumCustomers:int = CsaService.GetNumCustomersSignedUp(oPlayer.csaState);
					oPlayer.cash += (iHalfPayment * iNumCustomers);
				}
				else if (iCsaDayType == CsaState.DAY_TYPE_DELIVERY)
				{
					CsaService.DoFinalDelivery(oPlayer.csaState);
					CsaService.PrepareNextRound(oPlayer.csaState);
				}
			}
			
			// remove custom events from the current day
			_calendarStatTracker.ClearCustomEventsForDay(_time);
			
			// advance the date
			TimeService.AdvanceDate(_time);
			
			MenuService.CloseParentAndChildMenus(_menuState);
		}
		
		///- Core Gameplay Methods -///
		
		
		/// File Operation Methods ///
		
		public function DeleteGame():void
		{
			var saveFile:SharedObject = SharedObject.getLocal(GameSession.SAVE_GAME_NAME);
			
			saveFile.clear();
		}
		
		public function LoadGame(showCompletionMessage:Boolean = true):void
		{
			// need everything back in the inventory - stuff loaded into the cursor could get duplicated otherwise
			PlayerService.DropActiveItem(_activePlayer);
			
			var saveFile:SharedObject = SharedObject.getLocal(GameSession.SAVE_GAME_NAME);
			
			// time
			_time = saveFile.data._time;
			_calendarState = saveFile.data._calendarState;
			
			// stat tracking
			_statTracker = saveFile.data._statTracker;
			_calendarStatTracker = saveFile.data._calendarStatTracker;
			
			// world
			_world = saveFile.data._world;
			
			// players
			_players = saveFile.data._players;
			_activePlayer = saveFile.data._activePlayer;
			
			saveFile.close();
			
			if (showCompletionMessage == true)
			{
				var oPopUpMenu:PopUpMenu = new PopUpMenu(this, PopUpMenu.TYPE_GAME_LOADED);
				_menuState.popUpMenu = oPopUpMenu;
			}
			
			_uiManager.RepaintAll();
			UpdatePrecipitation();
		}
		
		public function SaveGame(showCompletionMessage:Boolean = true):void
		{
			// need everything back in the inventory - stuff loaded into the cursor doesn't get saved
			PlayerService.DropActiveItem(_activePlayer);
			
			var saveFile:SharedObject = SharedObject.getLocal(GameSession.SAVE_GAME_NAME);
			
			saveFile.clear();
			
			// time
			saveFile.data._time = _time;
			saveFile.data._calendarState = _calendarState;
			
			// stat tracking
			saveFile.data._statTracker = _statTracker;
			saveFile.data._calendarStatTracker = _calendarStatTracker;
			
			// save world
			saveFile.data._world = _world;
			
			// save player data
			saveFile.data._players = _players;
			saveFile.data._activePlayer = _activePlayer;
			
			var sFlushResult:String = saveFile.flush();
			saveFile.close();
			
			if (showCompletionMessage == true)
			{
				var oPopUpMenu:PopUpMenu = new PopUpMenu(this, PopUpMenu.TYPE_GAME_SAVED);
				_menuState.popUpMenu = oPopUpMenu;
			}
			
			_uiManager.RepaintAll();
		}
		
		///- File Operation Methods -///
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		/// Core Gameplay Methods ///
		
		private function SetupTodaysWeather():void
		{
			_world.weather.SetNewWeather();
			UpdatePrecipitation();
			
			_calendarStatTracker.AddEventToday(new WeatherEvent(_world.weather.current));
			
			// adjust soil properties based on the weather
			for (var x:int = 0; x < _world.width; x++)
			{
				for (var y:int = 0; y < _world.height; y++)
				{
					var oTile:Tile = Tile(_world.tiles[x][y]);
					
					if (oTile == null)
					{
						continue;
					}
					
					var oSoil:Soil = oTile.soil;
					var oPlant:Plant = oTile.plant;
					
					var nWaterAmount:Number = Weather.WATER_AMOUNT[_world.weather.current];
					
					// hot weather evaporates a % of water in the soil
					if (nWaterAmount < 0)
					{
						nWaterAmount *= (Weather.EVAPORATION_FACTOR * (oSoil.saturation / oSoil.GetMaxSaturation()));
					}
					
					oSoil.AddWater(nWaterAmount);
					
					if (nWaterAmount > 0)
					{
						// rain washes nutrients out of the soil if there's no plant there
						if (oPlant == null || (oPlant != null && oPlant.growthStage == Plant.STAGE_SEED))
						{
							oSoil.RemoveNutrient1(3);
							oSoil.RemoveNutrient2(3);
							oSoil.RemoveNutrient3(3);
						}
						
						// rain spreads toxicity to surrounding soil
						if (oSoil.toxicity >= 2)
						{
							SpreadToxicity(x, y, oSoil);
						}
					}
				}
			}
		}
		
		private function SpreadToxicity(sourceX:int, sourceY:int, sourceSoil:Soil):void
		{
			var lXOffset:Array = [ -1, 1, 0, 0 ];
			var lYOffset:Array = [ 0, 0, -1, 1 ];
			
			for (var i:int = 0; i < 4; i++)
			{
				var oTargetLocation:GridLocation = new GridLocation(sourceX + lXOffset[i], sourceY + lYOffset[i]);
				var bIsValidLocation:Boolean = GridUtil.IsValidTile(_world.tiles, oTargetLocation);
				
				if (bIsValidLocation == false)
				{
					continue;
				}
				
				var oTargetTile:Tile = Tile(_world.tiles[oTargetLocation.x][oTargetLocation.y]);
				var oTargetSoil:Soil = oTargetTile.soil;
				
				sourceSoil.RemoveToxicity(.25);
				oTargetSoil.AddToxicity(.25);
			}
		}
		
		private function UpdatePrecipitation():void
		{
			if (_world.weather.current == Weather.TYPE_RAIN)
			{
				_precipitationService.StartPrecipitation(PrecipitationService.SPEED_RAIN);
			}
			else if (_world.weather.current == Weather.TYPE_STORM)
			{
				_precipitationService.StartPrecipitation(PrecipitationService.SPEED_STORM);
			}
			else
			{
				_precipitationService.StopPrecipitation();
			}
		}
		
		///* Core Gameplay Methods *///
		
		
		/// Event Handlers ///
		
		private function OnDayTimer(event:TimerEvent):void
		{
			// timer fires 3 times per second
			// time += 1/3 = 1 time per second
			
			// pause timer if house menu is open
			if (_menuState.parentMenu != null)
			{
				if (_menuState.parentMenu.header.label == House.MENU_LABEL_NAME)
				{
					return;
				}
			}
			
			_time.time += (1/6);
			
			if (_time.time >= 100)
			{
				EndDay();
				BeginDay();
				_uiManager.RepaintAll();
			}
			else
			{
				_world.horizon.Update(_time.time);
				_uiManager.RepaintHorizon();
				_uiManager.RepaintWeather();
			}
		}
		
		///- Event Handlers -///
		
		//* Private Methods *//
	}	
}