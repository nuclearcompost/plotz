package
{
	//-----------------------
	//Purpose:				Service logic for the Footer
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class FooterService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function FooterService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function ActivateToolForPlayer(footer:Footer, index:int, player:Player):void
		{
			var oFooterButton:FooterButton = FooterService.GetFooterButtonAtIndex(footer, index);
			
			if (oFooterButton == null)
			{
				return;
			}
			
			var iToolType:int = FooterService.GetToolTypeForFooterButtonType(oFooterButton.type);
			
			if (iToolType < 0)
			{
				return;
			}
			
			// first, yank the tool out of the player's toolshed if it's in there
			var oTool:Tool = FarmService.PopTool(player.activeFarm, iToolType);
			
			// second, set the tool as the active item
			if (oTool != null)
			{
				var bCanSetActive:Boolean = PlayerService.SetActiveItem(player, oTool);
				
				// if we can't set it to active for some reason, put it back in the toolshed
				if (bCanSetActive == false)
				{
					player.activeFarm.toolShed.tools.AddItem(oTool);
				}
			}
		}
		
		public static function GetFooterButtonAtFooterLocation(footer:Footer, location:FooterLocation):FooterButton
		{
			if (footer == null)
			{
				return null;
			}
			
			if (location == null)
			{
				return null;
			}
			
			var iIndex:int = GetIndexForFooterLocation(location);
			
			if (iIndex < 0 || iIndex >= footer.contents.length)
			{
				return null;
			}
			
			var oObject:Object = Object(footer.contents[iIndex]);
			
			if (oObject == null)
			{
				return null;
			}
			
			if (!(oObject is FooterButton))
			{
				return null;
			}
			
			var oFooterButton:FooterButton = FooterButton(oObject);
			
			return oFooterButton;
		}
		
		public static function GetFooterButtonAtIndex(footer:Footer, index:int):FooterButton
		{
			if (footer == null)
			{
				return null;
			}
			
			if (index < 0 || index >= footer.contents.length)
			{
				return null;
			}
			
			var oObject:Object = Object(footer.contents[index]);
			
			if (oObject == null)
			{
				return null;
			}
			
			if (!(oObject is FooterButton))
			{
				return null;
			}
			
			var oFooterButton:FooterButton = FooterButton(oObject);
			
			return oFooterButton;
		}
		
		public static function GetIndexForFooterLocation(location:FooterLocation):int
		{
			if (location == null)
			{
				return -1;
			}
			
			var iIndex:int = location.x + (Footer.MAX_X * location.y);
			
			return iIndex;
		}
		
		public static function GetToolTypeForFooterButtonType(footerButtonType:int):int
		{
			var iToolType:int = -1;
			
			switch (footerButtonType)
			{
				case FooterButton.TYPE_WATERING_CAN:
					iToolType = Tool.TYPE_WATERING_CAN;
					break;
				case FooterButton.TYPE_SICKLE:
					iToolType = Tool.TYPE_SICKLE;
					break;
				case FooterButton.TYPE_HOE:
					iToolType = Tool.TYPE_HOE;
					break;
				default:
					break;
			}
			
			return iToolType;
		}
		
		public static function ToggleCalendarMenu(menuState:MenuState, calendarState:CalendarState, gameController:GameController):void
		{
			if (menuState == null)
			{
				return;
			}
			
			if (calendarState == null)
			{
				return;
			}
			
			if (gameController == null)
			{
				return;
			}
			
			// toggle menu off if it was created by a calendar footer button
			if (menuState.parentMenuSource != null && (menuState.parentMenuSource is FooterButton))
			{
				var oFooterButton:FooterButton = FooterButton(menuState.parentMenuSource);
				
				if (oFooterButton.type == FooterButton.TYPE_CALENDAR)
				{
					menuState.parentMenuSource = null;
					menuState.parentMenu = null;
					return;
				}
			}
			
			// toggle menu on
			MenuService.CloseParentAndChildMenus(menuState);
			
			/// reset/update calendarState month to be the current month
			var oCalendarTime:Time = calendarState.time.GetClone();
			calendarState.calendarTime = oCalendarTime;
			
			/// always start in month mode
			calendarState.dayMode = false;
			
			var oCalendarMenu:CalendarMenu = new CalendarMenu(gameController, calendarState);
			var lButtons:Array = [ MenuHeader.HEADER_BUTTON_CANCEL ];
			menuState.parentMenu = new ParentMenuFrame(gameController, [ oCalendarMenu ], null, "Calendar", 2, lButtons, 0, null, null, false, false);
			menuState.parentMenuSource = new FooterButton(FooterButton.TYPE_CALENDAR);
		}
		
		public static function ToggleShowPlants(menuState:MenuState):void
		{
			menuState.showPlants = !(menuState.showPlants);
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(FooterService.GetFooterButtonAtFooterLocationNullIfFooterNull());
			lResults.push(FooterService.GetFooterButtonAtFooterLocationNullIfLocationNull());
			lResults.push(FooterService.GetFooterButtonAtFooterLocationNullIfLocationTooSmall());
			lResults.push(FooterService.GetFooterButtonAtFooterLocationNullIfLocationTooLarge());
			lResults.push(FooterService.GetFooterButtonAtFooterLocationNullIfNoFooterButtonAtLocation());
			lResults.push(FooterService.GetFooterButtonAtFooterLocationReturnsFooterButtonAtLocation());
			lResults.push(FooterService.GetFooterButtonAtIndexNullIfFooterNull());
			lResults.push(FooterService.GetFooterButtonAtIndexNullIfIndexTooSmall());
			lResults.push(FooterService.GetFooterButtonAtIndexNullIfIndexTooLarge());
			lResults.push(FooterService.GetFooterButtonAtIndexNullIfNoFooterButtonAtIndex());
			lResults.push(FooterService.GetFooterButtonAtIndexReturnsFooterButtonAtIndex());
			lResults.push(FooterService.TestGetIndexForFooterLocation());
			lResults.push(FooterService.ToggleCalendarMenuOkIfNullMenuState());
			lResults.push(FooterService.ToggleCalendarMenuOkIfNullCalendarState());
			lResults.push(FooterService.ToggleCalendarMenuOkIfNullGameController());
			lResults.push(FooterService.ToggleCalendarMenuOnSetsMenu());
			lResults.push(FooterService.ToggleCalendarMenuOnSetsMenuSource());
			lResults.push(FooterService.ToggleCalendarMenuOffClearsMenu());
			lResults.push(FooterService.ToggleCalendarMenuOffClearsMenuSource());
			
			return lResults;
		}
		
		private static function GetFooterButtonAtFooterLocationNullIfFooterNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "GetFooterButtonAtFooterLocationNullIfFooterNull");
			var oFooter:Footer = null;
			var oLocation:FooterLocation = new FooterLocation(0, 0);
			
			var oActual:FooterButton = FooterService.GetFooterButtonAtFooterLocation(oFooter, oLocation);
			
			oResult.TestNull(oActual);
			
			return oResult;
		}
		
		private static function GetFooterButtonAtFooterLocationNullIfLocationNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "GetFooterButtonAtFooterLocationNullIfLocationNull");
			var oFooter:Footer = new Footer();
			var oLocation:FooterLocation = null;
			
			var oActual:FooterButton = FooterService.GetFooterButtonAtFooterLocation(oFooter, oLocation);
			
			oResult.TestNull(oActual);
			
			return oResult;
		}
		
		private static function GetFooterButtonAtFooterLocationNullIfLocationTooSmall():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "GetFooterButtonAtFooterLocationNullIfLocationTooSmall");
			var oFooter:Footer = new Footer();
			var oLocation:FooterLocation = new FooterLocation(-1, -1);
			
			var oActual:FooterButton = FooterService.GetFooterButtonAtFooterLocation(oFooter, oLocation);
			
			oResult.TestNull(oActual);
			
			return oResult;
		}
		
		private static function GetFooterButtonAtFooterLocationNullIfLocationTooLarge():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "GetFooterButtonAtFooterLocationNullIfLocationTooLarge");
			var oFooter:Footer = new Footer();
			var oLocation:FooterLocation = new FooterLocation(10, 10);
			
			var oActual:FooterButton = FooterService.GetFooterButtonAtFooterLocation(oFooter, oLocation);
			
			oResult.TestNull(oActual);
			
			return oResult;
		}
		
		private static function GetFooterButtonAtFooterLocationNullIfNoFooterButtonAtLocation():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "GetFooterButtonAtFooterLocationNullIfNoFooterButtonAtLocation");
			var lContents:Array = [ null, new FooterButton(FooterButton.TYPE_CALENDAR) ];
			var oFooter:Footer = new Footer(lContents);
			var oLocation:FooterLocation = new FooterLocation(0, 0);
			
			var oActual:FooterButton = FooterService.GetFooterButtonAtFooterLocation(oFooter, oLocation);
			
			oResult.TestNull(oActual);
			
			return oResult;
		}
		
		private static function GetFooterButtonAtFooterLocationReturnsFooterButtonAtLocation():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "GetFooterButtonAtFooterLocationReturnsFooterButtonAtLocation");
			var lContents:Array = [ null, new FooterButton(FooterButton.TYPE_CALENDAR) ];
			var oFooter:Footer = new Footer(lContents);
			var oLocation:FooterLocation = new FooterLocation(1, 0);
			
			var oActual:FooterButton = FooterService.GetFooterButtonAtFooterLocation(oFooter, oLocation);
			
			oResult.TestNotNull(oActual);
			
			return oResult;
		}
		
		private static function GetFooterButtonAtIndexNullIfFooterNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "GetFooterButtonAtIndexNullIfFooterNull");
			var oFooter:Footer = null;
			var iIndex:int = 0;
			
			var oActual:FooterButton = FooterService.GetFooterButtonAtIndex(oFooter, iIndex);
			
			oResult.TestNull(oActual);
			
			return oResult;
		}
		
		private static function GetFooterButtonAtIndexNullIfIndexTooSmall():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "GetFooterButtonAtIndexNullIfIndexTooSmall");
			var oFooter:Footer = new Footer();
			var iIndex:int = -1;
			
			var oActual:FooterButton = FooterService.GetFooterButtonAtIndex(oFooter, iIndex);
			
			oResult.TestNull(oActual);
			
			return oResult;
		}
		
		private static function GetFooterButtonAtIndexNullIfIndexTooLarge():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "GetFooterButtonAtIndexNullIfIndexTooLarge");
			var oFooter:Footer = new Footer();
			var iIndex:int = 10;
			
			var oActual:FooterButton = FooterService.GetFooterButtonAtIndex(oFooter, iIndex);
			
			oResult.TestNull(oActual);
			
			return oResult;
		}
		
		private static function GetFooterButtonAtIndexNullIfNoFooterButtonAtIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "GetFooterButtonAtIndexNullIfNoFooterButtonAtIndex");
			var lContents:Array = [ new FooterButton(FooterButton.TYPE_CALENDAR), null ];
			var oFooter:Footer = new Footer(lContents);
			var iIndex:int = 1;
			
			var oActual:FooterButton = FooterService.GetFooterButtonAtIndex(oFooter, iIndex);
			
			oResult.TestNull(oActual);
			
			return oResult;
		}
		
		private static function GetFooterButtonAtIndexReturnsFooterButtonAtIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "GetFooterButtonAtIndexReturnsFooterButtonAtIndex");
			var lContents:Array = [ new FooterButton(FooterButton.TYPE_CALENDAR), null ];
			var oFooter:Footer = new Footer(lContents);
			var iIndex:int = 0;
			
			var oActual:FooterButton = FooterService.GetFooterButtonAtIndex(oFooter, iIndex);
			
			oResult.TestNotNull(oActual);
			
			return oResult;
		}
		
		public static function TestGetIndexForFooterLocation():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "TestGetIndexForFooterLocation");
			
			var oFooter:Footer = new Footer([ new Tool(Tool.TYPE_WATERING_CAN), new Tool(Tool.TYPE_HOE) ]);
			
			oResult.expected = "1";
			oResult.actual = String(FooterService.GetIndexForFooterLocation(new FooterLocation(1, 0)));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ToggleCalendarMenuOkIfNullMenuState():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "ToggleCalendarMenuOkIfNullMenuState");
			var oMenuState:MenuState = null
			var oCalendarState:CalendarState = new CalendarState();
			var oGameController:GameController = new GameController();
			
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			try
			{
				FooterService.ToggleCalendarMenu(oMenuState, oCalendarState, oGameController);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ToggleCalendarMenuOkIfNullCalendarState():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "ToggleCalendarMenuOkIfNullCalendarState");
			var oMenuState:MenuState = new MenuState();
			var oCalendarState:CalendarState = null;
			var oGameController:GameController = new GameController();
			
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			try
			{
				FooterService.ToggleCalendarMenu(oMenuState, oCalendarState, oGameController);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ToggleCalendarMenuOkIfNullGameController():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "ToggleCalendarMenuOkIfNullGameController");
			var oMenuState:MenuState = new MenuState();
			var oCalendarState:CalendarState = new CalendarState();
			var oGameController:GameController = null;
			
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			try
			{
				FooterService.ToggleCalendarMenu(oMenuState, oCalendarState, oGameController);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ToggleCalendarMenuOnSetsMenu():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "ToggleCalendarMenuOnSetsMenu");
			var oMenuState:MenuState = new MenuState();
			var oCalendarState:CalendarState = new CalendarState();
			var oGameController:GameController = new GameController();
			
			FooterService.ToggleCalendarMenu(oMenuState, oCalendarState, oGameController);
			
			oResult.TestNotNull(oMenuState.parentMenu);
			
			return oResult;
		}
		
		private static function ToggleCalendarMenuOnSetsMenuSource():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "ToggleCalendarMenuOnSetsMenuSource");
			var oMenuState:MenuState = new MenuState();
			var oCalendarState:CalendarState = new CalendarState();
			var oGameController:GameController = new GameController();
			
			FooterService.ToggleCalendarMenu(oMenuState, oCalendarState, oGameController);
			
			oResult.TestNotNull(oMenuState.parentMenuSource);
			
			return oResult;
		}
		
		private static function ToggleCalendarMenuOffClearsMenu():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "ToggleCalendarMenuOffClearsMenu");
			var oMenuState:MenuState = new MenuState();
			oMenuState.parentMenuSource = new FooterButton(FooterButton.TYPE_CALENDAR);
			var oCalendarState:CalendarState = new CalendarState();
			var oGameController:GameController = new GameController();
			
			FooterService.ToggleCalendarMenu(oMenuState, oCalendarState, oGameController);
			
			oResult.TestNull(oMenuState.parentMenu);
			
			return oResult;
		}
		
		private static function ToggleCalendarMenuOffClearsMenuSource():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("FooterService", "ToggleCalendarMenuOffClearsMenuSource");
			var oMenuState:MenuState = new MenuState();
			oMenuState.parentMenuSource = new FooterButton(FooterButton.TYPE_CALENDAR);
			var oCalendarState:CalendarState = new CalendarState();
			var oGameController:GameController = new GameController();
			
			FooterService.ToggleCalendarMenu(oMenuState, oCalendarState, oGameController);
			
			oResult.TestNull(oMenuState.parentMenuSource);
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}