package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
		
	//-----------------------
	//Purpose:				Handle UI Display and Events
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class UIManager extends MovieClip
	{
		// Constants //
		
		public static const SCREEN_PIXEL_WIDTH:int = 720;
		public static const SCREEN_PIXEL_HEIGHT:int = 800;
		
		public static const VIEW_RECT_GRID_WIDTH:int = 12;
		public static const VIEW_RECT_GRID_HEIGHT:int = 21;
		
		private static const GRID_LEFT_BUFFER:int = 1;
		private static const GRID_RIGHT_BUFFER:int = 1;
		private static const GRID_TOP_BUFFER:int = 0;
		private static const GRID_BOTTOM_BUFFER:int = 1;
		
		private static const MAX_MAP_MOVE:int = 7;
		
		public static const HORIZON_PIXEL_HEIGHT:int = 120;
		
		private static const ORIENTATION_UP:int = 0;
		private static const ORIENTATION_DOWN:int = 1;
		private static const ORIENTATION_LEFT:int = 2;
		private static const ORIENTATION_RIGHT:int = 3;
		
		public static const FOOTER_PIXEL_WIDTH:int = 60;
		public static const FOOTER_PIXEL_HEIGHT:int = 50;
		
		// pixel location of footer ui grid origin:
		public static const FOOTER_X_PIXEL_OFFSET:int = 0;
		public static const FOOTER_Y_PIXEL_OFFSET:int = 750;
		
		public static const OVERLAY_MENU_PIXEL_X:int = 180;
		public static const OVERLAY_MENU_PIXEL_Y:int = 700;
		public static const OVERLAY_MENU_PIXEL_WIDTH:int = 120;
		public static const OVERLAY_MENU_PIXEL_HEIGHT:int = 50;
		
		// Menu Size Constants
		public static const MENU_INV_ITEM_GRID_WIDTH:int = 2;
		public static const MENU_INV_ITEM_GRID_HEIGHT:int = 2;
		public static const MENU_INV_ITEMS_PER_ROW:int = 8;
		public static const MENU_ACTION_BTN_GRID_HEIGHT:int = 1;
		public static const MENU_INV_GRID_PIXEL_WIDTH:int = 45;
		public static const MENU_INV_GRID_PIXEL_HEIGHT:int = 45;
		
		private static const CALENDAR_NOTIFICATION_PIXEL_X:int = 300;
		private static const WALLET_NOTIFICATION_PIXEL_X:int = 480;
		
		public static const TILE_PIXEL_WIDTH:int = 60;
		public static const TILE_PIXEL_HALF_WIDTH:int = 30;
		public static const TILE_PIXEL_HEIGHT:int = 30;
		public static const TILE_PIXEL_HALF_HEIGHT:int = 15;
		
		
		// remove this stuff:
		public static const GRID_PIXEL_WIDTH:int = 45;
		public static const GRID_PIXEL_HEIGHT:int = 45;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get gridOffset():GridLocation
		{
			return _gridOffset;
		}
		
		public function set gridOffset(offset:GridLocation):void
		{
			if (offset == null)
			{
				_gridOffset = new GridLocation(0, 0);
			}
			else
			{
				_gridOffset = new GridLocation(offset.x, offset.y);
			}
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _gameRoot:GameRoot;
		private var _gameSession:GameSession;
		private var _graphics:MovieClip;
		private var _gridOffset:GridLocation;
		private var _lastBldgPreview:Bldg;
		private var _lastGridLocation:GridLocation;
		private var _lastFooterLocation:FooterLocation;
		private var _mapMoveArrows:Array;
		private var _rectGridOffset:RectGridLocation;
		
		private var _bldgAndPlantGraphics:MovieClip;
		private var _footerUIGraphics:MovieClip;
		private var _horizonGraphics:MovieClip;
		private var _mapMoveArrowGraphics:MovieClip;
		private var _menuGraphics:MovieClip;
		private var _mouseLoadGraphics:MovieClip;
		private var _mouseOverUIGraphics:MovieClip;
		private var _notificationGraphics:MovieClip;
		private var _popUpMenuGraphics:MovieClip;
		private var _precipitationGraphics:MovieClip;
		private var _soilGraphics:MovieClip;
		private var _terrainGraphics:MovieClip;
		private var _tutorialGraphics:MovieClip;
		private var _weatherGraphics:MovieClip;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		
		//Parameters:
		//	
		//Returns:		
		//---------------
		public function UIManager(gameRoot:GameRoot, gameSession:GameSession)
		{
			_gameRoot = gameRoot;
			_gameSession = gameSession;
			
			_gridOffset = new GridLocation(0, 0);
			_rectGridOffset = new RectGridLocation(0, 0);
			_lastBldgPreview = null;
			_lastGridLocation = new GridLocation(-1, -1);
			_lastFooterLocation = new FooterLocation(-1, -1);
			
			_mapMoveArrows = new Array();
			
			_gameRoot.main.stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			_gameRoot.main.stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove, false, 0, true);
			
			_graphics = new MovieClip();
			
			_horizonGraphics = new MovieClip();
			_graphics.addChild(_horizonGraphics);
			
			_soilGraphics = new MovieClip();
			_graphics.addChild(_soilGraphics);
			
			_terrainGraphics = new MovieClip();
			_graphics.addChild(_terrainGraphics);
			
			_bldgAndPlantGraphics = new MovieClip();
			_graphics.addChild(_bldgAndPlantGraphics);
			
			_precipitationGraphics = new MovieClip();
			_graphics.addChild(_precipitationGraphics);
			
			_weatherGraphics = new MovieClip();
			_graphics.addChild(_weatherGraphics);
			
			_footerUIGraphics = new MovieClip();
			_graphics.addChild(_footerUIGraphics);
			
			_menuGraphics = new MovieClip();
			_graphics.addChild(_menuGraphics);
			
			_mouseOverUIGraphics = new MovieClip();
			_graphics.addChild(_mouseOverUIGraphics);
			
			_mapMoveArrowGraphics = new MovieClip();
			_graphics.addChild(_mapMoveArrowGraphics);
			
			_tutorialGraphics = new MovieClip();
			_graphics.addChild(_tutorialGraphics);
			
			_popUpMenuGraphics = new MovieClip();
			_graphics.addChild(_popUpMenuGraphics);
			
			_notificationGraphics = new MovieClip();
			_graphics.addChild(_notificationGraphics);
			
			_mouseLoadGraphics = new MovieClip();
			_graphics.addChild(_mouseLoadGraphics);
			
			_graphics.addEventListener(MouseEvent.CLICK, OnClickPlateGraphics, false, 0, true);
			
			this.addChild(_graphics);
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		/// Core Functionality ///
		
		public static function AssignButtonText(button:SimpleButton, text:String):void
		{
			if (button == null)
			{
				return;
			}
			
			AssignButtonStateText(DisplayObjectContainer(button.upState), text);
			AssignButtonStateText(DisplayObjectContainer(button.downState), text);
			AssignButtonStateText(DisplayObjectContainer(button.overState), text);
		}
		
		private static function AssignButtonStateText(container:DisplayObjectContainer, text:String):void
		{
			for (var child:int = 0; child < container.numChildren; child++)
			{
				var oChild:Object = container.getChildAt(child);
				
				if (oChild is TextField)
				{
					var oText:TextField = TextField(oChild);
					
					oText.text = text;
				}
			}
		}
		
		///- Core Functionality -///
		
		
		/// UI Methods ///
		
		public function GetGraphics():MovieClip
		{
			return _graphics;
		}
		
		public function RepaintAll():void
		{
			RepaintHorizon();
			RepaintTerrain();
			RepaintSoil();
			RepaintBldgAndPlant();
			RepaintWeather();
			RepaintFooterUI();
			RepaintMenu();
			RepaintMouseOverUI();
			RepaintMapMoveArrow();
			RepaintTutorial();
			RepaintPopUpMenu();
			RepaintMouseLoad(new PixelLocation(_gameRoot.main.stage.mouseX, _gameRoot.main.stage.mouseY));
		}
		
		public function RepaintBldgAndPlant():void
		{
			EraseBldgAndPlant();
			PaintBldgAndPlant();
		}
		
		public function RepaintFooterUI():void
		{
			EraseFooterUI();
			PaintFooterUI();
		}
		
		public function RepaintHorizon():void
		{
			EraseHorizon();
			PaintHorizon();
		}
		
		public function RepaintMapMoveArrow():void
		{
			EraseMapMoveArrow();
			PaintMapMoveArrow();
		}
		
		public function RepaintMenu():void
		{
			EraseMenu();
			PaintMenu();
		}
		
		public function RepaintMouseLoad(mouseLocation:PixelLocation):void
		{
			EraseMouseLoad();
			PaintMouseLoad(mouseLocation);
		}
		
		public function RepaintMouseOverUI():void
		{
			EraseMouseOverUI();
			PaintMouseOverUI();
		}
		
		public function RepaintPopUpMenu():void
		{
			ErasePopUpMenu();
			PaintPopUpMenu();
		}
		
		public function RepaintPrecipitation(precipitation:MovieClip):void
		{
			ErasePrecipitation();
			PaintPrecipitation(precipitation);
		}
		
		public function RepaintSoil():void
		{
			EraseSoil();
			PaintSoil();
		}
		
		public function RepaintTerrain():void
		{
			EraseTerrain();
			PaintTerrain();
		}
		
		public function RepaintTutorial():void
		{
			EraseTutorial();
			PaintTutorial();
		}
		
		public function RepaintWeather():void
		{
			EraseWeather();
			PaintWeather();
		}
		
		public function AddNotificationGraphics(container:MovieClip, notificationType:int):void
		{
			// position the new movieClip
			container.x = UIManager.CALENDAR_NOTIFICATION_PIXEL_X;
			container.y = UIManager.FOOTER_Y_PIXEL_OFFSET - container.height;
			
			if (notificationType == Notification.TYPE_WALLET)
			{
				container.x = UIManager.WALLET_NOTIFICATION_PIXEL_X;
			}
			
			// bump all existing notifications in the same column up
			var iNumChildren:int = _notificationGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				var oObject:Object = _notificationGraphics.getChildAt(i);
				
				if (!(oObject is MovieClip))
				{
					continue;
				}
				
				var mcCurrent:MovieClip = MovieClip(oObject);
				
				if (mcCurrent.x == container.x)
				{
					mcCurrent.y -= container.height;
				}
			}
			
			_notificationGraphics.addChild(container);
		}
		
		//---------------
		//Purpose:		Move the view the next step across the world in the direction specified
		//
		//Parameters:
		//	direction:int = the direction to move
		//
		//Returns:		void
		//---------------
		public function MoveMap(direction:int):void
		{
			var iDistanceToEdge:int;
			var iDistanceToMove:int = UIManager.MAX_MAP_MOVE;
			var oMaxOffset:RectGridLocation = GetMaxRectGridOffset();
			
			switch(direction)
			{
				case MapMoveArrow.DIR_UP:
					iDistanceToEdge = _rectGridOffset.y;
					break;
				case MapMoveArrow.DIR_DOWN:
					iDistanceToEdge = oMaxOffset.y - _rectGridOffset.y;
					break;
				case MapMoveArrow.DIR_LEFT:
					iDistanceToEdge = _rectGridOffset.x;
					break;
				case MapMoveArrow.DIR_RIGHT:
					iDistanceToEdge = oMaxOffset.x - _rectGridOffset.x;
					break;
				default:
					break;
			}
			
			if (iDistanceToEdge < iDistanceToMove)
			{
				iDistanceToMove = iDistanceToEdge;
			}
			
			switch(direction)
			{
				case MapMoveArrow.DIR_UP:
					_rectGridOffset.y -= iDistanceToMove;
					_gridOffset.x += iDistanceToMove;
					_gridOffset.y -= iDistanceToMove;
					break;
				case MapMoveArrow.DIR_DOWN:
					_rectGridOffset.y += iDistanceToMove;
					_gridOffset.x -= iDistanceToMove;
					_gridOffset.y += iDistanceToMove;
					break;
				case MapMoveArrow.DIR_LEFT:
					_rectGridOffset.x -= iDistanceToMove;
					_gridOffset.x -= iDistanceToMove;
					_gridOffset.y -= iDistanceToMove;
					break;
				case MapMoveArrow.DIR_RIGHT:
					_rectGridOffset.x += iDistanceToMove;
					_gridOffset.x += iDistanceToMove;
					_gridOffset.y += iDistanceToMove;
					break;
				default:
					break;
			}
			
			RepaintAll();
		}
		
		public function RemoveNotificationGraphics(container:MovieClip):void
		{
			if (_notificationGraphics.contains(container))
			{ 
				// slide all notifications above the given one down by the height of the given one
				var iNumChildren:int = _notificationGraphics.numChildren;
				
				for (var i:int = 0; i < iNumChildren; i++)
				{
					var oObject:Object = _notificationGraphics.getChildAt(i);
					
					if (!(oObject is MovieClip))
					{
						continue;
					}
					
					var mcCurrent:MovieClip = MovieClip(oObject);
					
					if (mcCurrent.y < container.y && mcCurrent.x == container.x)
					{
						mcCurrent.y += container.height;
					}
				}
				
				// remove the given notification from the screen
				_notificationGraphics.removeChild(container);
			}
		}
		
		///- UI Methods -///
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		/// Core Functionality ///
		
		private function GetGridLocationForPixelLocation(pixelLocation:PixelLocation):GridLocation
		{
			var oOffset:PixelLocation = GetDrawOrigin();
			var oPixelLocation:PixelLocation = new PixelLocation(pixelLocation.x - oOffset.x, pixelLocation.y - oOffset.y);
			var oGridLocation:GridLocation = oPixelLocation.GetGridLocation();
			
			return oGridLocation;
		}
		
		// get the pixel location to place the 0,0 isometric tile in order to get the proper tiles to show in the current view
		private function GetDrawOrigin():PixelLocation
		{
			// start with the iso tile coordinates that are in the upper left when the board is at the origin
			var oUpperLeftCorner:GridLocation = GetOriginGridLocation();
			
			// apply the map movement offsets
			oUpperLeftCorner.x += _gridOffset.x;
			oUpperLeftCorner.y += _gridOffset.y;
			
			// translate to pixel location if the origin was 0,0
			var oOriginOffset:PixelLocation = oUpperLeftCorner.GetPixelLocation();
			
			// translate from screen 0,0 to the screen pixel location of the center of the upper-leftmost tile on the screen
			var oOffset:PixelLocation = new PixelLocation(UIManager.TILE_PIXEL_HALF_WIDTH - oOriginOffset.x, (UIManager.HORIZON_PIXEL_HEIGHT + UIManager.TILE_PIXEL_HALF_HEIGHT) - oOriginOffset.y);
			
			return oOffset;
		}
		
		private function GetMaxRectGridOffset():RectGridLocation
		{
			if (_gameSession.world == null)
			{
				var oMaxOffset:RectGridLocation = new RectGridLocation(0, 0);
				return oMaxOffset;
			}
			
			oMaxOffset = new RectGridLocation(_gameSession.world.rectangleWidth - UIManager.GRID_LEFT_BUFFER - UIManager.GRID_RIGHT_BUFFER - VIEW_RECT_GRID_WIDTH,
											  _gameSession.world.rectangleHeight - UIManager.GRID_TOP_BUFFER - UIManager.GRID_BOTTOM_BUFFER - VIEW_RECT_GRID_HEIGHT);
			
			return oMaxOffset;
		}
		
		// return the isometric tile coordinates of the upper-leftmost possible tile, taking buffers into account (but IGNORING current moveMap offsets)
		private function GetOriginGridLocation():GridLocation
		{
			var oOrigin:GridLocation = new GridLocation((_gameSession.world.rectangleHeight - 1) + UIManager.GRID_LEFT_BUFFER - UIManager.GRID_TOP_BUFFER,
														0 + UIManager.GRID_LEFT_BUFFER + UIManager.GRID_TOP_BUFFER);
			
			return oOrigin;
		}
		
		private function GetPixelLocationForGridLocation(worldLocation:GridLocation):PixelLocation
		{
			var oGridLocation:GridLocation = new GridLocation(worldLocation.x, worldLocation.y);
			var oPixelLocation:PixelLocation = oGridLocation.GetPixelLocation();
			var oPixelOffset:PixelLocation = GetDrawOrigin();
			
			oPixelLocation.x += oPixelOffset.x;
			oPixelLocation.y += oPixelOffset.y;
			
			return oPixelLocation;
		}
		
		private function GetTileSection(gridLocation:GridLocation, pixelLocation:PixelLocation):int
		{
			var oGridCenter:PixelLocation = GetPixelLocationForGridLocation(gridLocation);
			
			if (pixelLocation.x <= oGridCenter.x)
			{
				return Tile.SECTION_LEFT_HALF;
			}
			
			return Tile.SECTION_RIGHT_HALF;
		}
		
		private function GetMaxMenuY():Number
		{
			var nMaxY:Number = 0;
			
			for (var i:int = 0; i < _menuGraphics.numChildren; i++)
			{
				var mc:MovieClip = MovieClip(_menuGraphics.getChildAt(i));
				var nY:Number = mc.y + mc.height;
				
				if (nY > nMaxY)
				{
					nMaxY = nY;
				}
			}
			
			return nMaxY;
		}

		private function GetMouseQuadrant():String
		{
			var sQuadrant:String = "";
			
			var iX:int = _gameRoot.main.stage.mouseX;
			var iY:int = _gameRoot.main.stage.mouseY;
			
			var iHalfWidth:int = UIManager.SCREEN_PIXEL_WIDTH / 2;
			var iHalfHeight:int = UIManager.SCREEN_PIXEL_HEIGHT / 2;
			
			if (iX <= iHalfWidth && iY <= iHalfHeight)
			{
				sQuadrant = "UpperLeft";
			}
			else if (iX > iHalfWidth && iY <= iHalfHeight)
			{
				sQuadrant = "UpperRight";
			}
			else if (iX <= iHalfWidth && iY > iHalfHeight)
			{
				sQuadrant = "LowerLeft";
			}
			else if (iX > iHalfWidth && iY > iHalfHeight)
			{
				sQuadrant = "LowerRight";
			}
			
			return sQuadrant;
		}
		
		private function IsBldgHit(bldg:Bldg, mouseLocation:PixelLocation):Boolean
		{
			var oBldgOrigin:GridLocation = new GridLocation(bldg.origin.x, bldg.origin.y);
			var oBldgOriginPixel:PixelLocation = GetPixelLocationForGridLocation(oBldgOrigin);
			var oOriginLocation:PixelLocation = new PixelLocation(mouseLocation.x - oBldgOriginPixel.x, mouseLocation.y - oBldgOriginPixel.y);
			var oRegistrationPoint:PixelLocation = bldg.registrationPoint;
			oOriginLocation.x += oRegistrationPoint.x;
			oOriginLocation.y += oRegistrationPoint.y;
			
			var mcBldg:MovieClip = bldg.GetHitMask();
			var oBitmapData:BitmapData = new BitmapData(bldg.hitMaskWidth, bldg.hitMaskHeight, true, 0x00FFFFFF); // extra params ensure transparency works
			oBitmapData.draw(mcBldg);
			
			var uPixel:uint = oBitmapData.getPixel32(oOriginLocation.x, oOriginLocation.y);
			var uAlpha:uint = uPixel >> 24 & 0xFF;  // don't mess with this, it is MAGIC
			
			if (uAlpha > 0x24) // i picked a random but somewhat smallish threshold, or tried to anyway
			{
				return true;
			}
			
			return false;
		}
		
		private function OnGridClicked(x:int, y:int, tileSection:int, pixelLocation:PixelLocation):void
		{
			var oPlayer:Player = _gameSession.activePlayer;
			
			// see if the location clicked is valid
			if (GridUtil.IsValidTile(_gameSession.world.tiles, new GridLocation(x, y)) == false)
			{
				return;
			}
			
			// find the top-most object that should be acted upon based on the location, objects present, and mouseLoad
			var oTile:Tile = Tile(_gameSession.world.tiles[x][y]);
			var oPlant:Plant = oTile.plant;
			var oSoil:Soil = oTile.soil;
			var oTerrain:Terrain = oTile.terrain;

			var oBldg:Bldg = null;
			var lBldgs:Array = oTile.leftBldgs;
			if (tileSection == Tile.SECTION_RIGHT_HALF)
			{
				lBldgs = oTile.rightBldgs;
			}
			for (var bldg:int = 0; bldg < lBldgs.length; bldg++)
			{
				var oCheckBldg:Bldg = Bldg(lBldgs[bldg]);
				
				if (oCheckBldg.bldgType == Bldg.TYPE_FARM_FENCE)
				{
					continue;
				}
				
				var bIsBldgHit:Boolean = IsBldgHit(oCheckBldg, pixelLocation);
						
				if (bIsBldgHit)
				{
					oBldg = oCheckBldg;
					break;
				}
			}
			
			// dead zone check - on a tile which has part of it obscured by a building, but didn't actually click on the building
			if ((oTile.leftBldgs.length > 0 || oTile.rightBldgs.length > 0) && oBldg == null)
			{
				return;
			}
			
			// A building was clicked on - We return from this no matter what @ the end - nothing falls through
			if (oBldg != null)
			{
				if (TutorialService.IsTutorialActive(_gameSession.tutorialStep) == true)
				{
					var bTestResult:Boolean = TutorialService.IsValidBldgClick(_gameSession.tutorialStep, oBldg.bldgType);
					
					if (bTestResult == false)
					{
						return;
					}
					else if (bTestResult == true)
					{
						_gameSession.tutorialStep++;
					}
				}
				
				// refill watering can at well
				if (oBldg is Well)
				{
					var oWell:Well = Well(oBldg);
					
					if (_gameSession.activePlayer.activeItem is Tool)
					{
						var oTool:Tool = Tool(_gameSession.activePlayer.activeItem);
					
						if (oTool.type == Tool.TYPE_WATERING_CAN)
						{
							WellService.RefillWateringCan(oWell, oTool);
						}
					}
					
					return;
				}
				
				// Item shop needs special handling b/c its contents change a lot
				if (oBldg is ItemShop)
				{
					var oItemShop:ItemShop = ItemShop(oBldg);
					
					if (_gameSession.tutorialStep > -1)
					{
						oItemShop.SetContentsForTutorial();
					}
					else
					{
						oItemShop.SetContents(_gameSession.time.season);
					}
				}
				
				// Get the primary menu for the building clicked on
				var oMenu:ParentMenuFrame = oBldg.GetMenu(_gameRoot.controller);
				
				if (oMenu != null)
				{
					// get the menuState for the active player
					var oMenuState:MenuState = _gameSession.menuState;
					
					// save the parent menu's source bldg
					var oSourceBldg:Bldg = null;
					
					if (oMenuState.parentMenu != null)
					{
						if (oMenuState.parentMenuSource != null && oMenuState.parentMenuSource is Bldg)
						{
							oSourceBldg = Bldg(oMenuState.parentMenuSource);
						}
					}
					
					// clear existing menus
					oMenuState.parentMenu = null;
					oMenuState.childMenu = null;
					
					// if the menu already open is for the same building clicked on now, don't open the menu again
					if (oSourceBldg != null && oSourceBldg == oBldg)
					{
						RepaintAll();
						return;
					}
					
					// set new primary menu
					oMenuState.parentMenu = oMenu;
					oMenuState.parentMenuSource = oBldg;
					
					// set new child menu
					var iActiveTabBldgType:int = oMenu.GetActiveTabBldgType();
					var iActiveTabChildTab:int = oMenu.GetActiveTabChildTab();
					
					if (iActiveTabBldgType > -1 && iActiveTabChildTab > -1)
					{
						var oChildBldg:Bldg = _gameSession.activePlayer.activeFarm.GetBldg(iActiveTabBldgType);
						
						if (oChildBldg != null)
						{
							var oChildMenu:ChildMenuFrame = oChildBldg.GetChildMenu(_gameRoot.controller, iActiveTabChildTab);
							oMenuState.childMenu = oChildMenu;
							
							// link parent and child menus
							oMenuState.childMenu.parentMenu = oMenu;
							oMenuState.parentMenu.childMenu = oChildMenu;
						}
					}
					
					RepaintAll();
				}
				
				return;
			}
			
			// tutorial check - this is only for single tile clicks - bldgs are handled separately
			if (TutorialService.IsTutorialActive(_gameSession.tutorialStep) == true)
			{
				bTestResult = TutorialService.IsValidGridClickForTutorial(_gameSession.tutorialStep, new GridLocation(x, y));
				
				if (bTestResult == false)
				{
					return;
				}
				else if (bTestResult == true)
				{
					_gameSession.tutorialStep++;
				}
			}
			
			// if the soil below is not owned by the player, there's nothing else we can do here
			if (oSoil.isPlayerOwned == false)
			{
				return;
			}			
			
			// place item buildings
			if (_gameSession.activePlayer.activeItem is ItemBldg)
			{
				var oItemBldg:ItemBldg = ItemBldg(_gameSession.activePlayer.activeItem)
				
				var oPlaced:Boolean = FarmService.PlaceItemBldg(_gameSession.activePlayer.activeFarm, oItemBldg, new GridLocation(x, y), _gameSession.world);
				
				if (oPlaced == true)
				{
					PlayerService.ClearActiveItem(_gameSession.activePlayer);
				}
				
				return;
			}
			
			// A plant was clicked on - we can still fall through to the soil, make sure to return if you *don't* want to act as if we clicked on the soil too
			if (oPlant != null)
			{
				if (_gameSession.activePlayer.activeItem == null && oPlant.growthStage == Plant.STAGE_READY_FOR_HARVEST)
				{
					if (oPlant.fruit != null)
					{
						var oFruit:Fruit = oPlant.fruit;
						oPlant.fruit = null;
						_gameSession.activePlayer.activeItem = oFruit;
						_gameSession.statTracker.fruitHarvested++;
						_gameSession.calendarStatTracker.AddEventToday(new FruitHarvestedEvent(oFruit.type, null, 1));
					}
					
					if (oPlant.growthStyle == Plant.GROWSTYLE_NOFLOWER_WHOLE_ONCE || oPlant.growthStyle == Plant.GROWSTYLE_FLOWER_WHOLE_ONCE)
					{
						var oPlantNutrients:NutrientSet = oPlant.GetNutrientsAbsorbedSoFar();
						oTile.plantScrap = new PlantScrap(oPlantNutrients, oPlant.toxicity, 5);
						oTile.plant = null;
						oSoil.DisturbPercent(25);
					}
					else
					{
						oPlant.AdvanceStage(oSoil);
					}
					
					RepaintAll();
					return;
				}
				else if (_gameSession.activePlayer.activeItem is Tool)
				{
					oTool = Tool(_gameSession.activePlayer.activeItem);
					
					if (oTool.type == Tool.TYPE_SICKLE)
					{
						oTool.graphics.play();
						oPlantNutrients = oPlant.GetNutrientsAbsorbedSoFar();
						
						if (Plant.GetClass(oPlant.type) != Plant.CLASS_COVER)
						{
							oTile.plantScrap = new PlantScrap(oPlantNutrients, oPlant.toxicity, 5);
						}
						
						oTile.plant = null;
						oSoil.DisturbPercent(25);
						RepaintAll();
						return;
					}
				}
			}
			
			var oPlantScrap:PlantScrap = oTile.plantScrap;
			
			if (oPlantScrap != null)
			{
				if (_gameSession.activePlayer.activeItem == null)
				{
					_gameSession.activePlayer.activeItem = oPlantScrap;
					oTile.plantScrap = null;
					RepaintAll();
					return;
				}
				
				if (_gameSession.activePlayer.activeItem is Tool)
				{
					oTool = Tool(_gameSession.activePlayer.activeItem);
					
					if (oTool.type == Tool.TYPE_SICKLE)
					{
						oTile.plantScrap = null;
						RepaintAll();
						return;
					}
				}
			}
			
			// The ground-level object was clicked on
			if (oSoil != null)
			{
				if (_gameSession.activePlayer.activeItem != null)
				{
					if (_gameSession.activePlayer.activeItem is Seed && oPlant == null && oPlantScrap == null)
					{
						var oSeed:Seed = Seed(_gameSession.activePlayer.activeItem);
						
						oTile.plant = new Plant(oSeed.type);
						_gameSession.statTracker.plantsPlanted++;
						_gameSession.calendarStatTracker.AddEventToday(new SeedPlantedEvent(oSeed.type, null, 1));
						_gameSession.activePlayer.activeItem = null;

					}
					else if (_gameSession.activePlayer.activeItem is IFertilizerSource && oTile.fertilizer == null)
					{
						var oFertilizerSource:IFertilizerSource = IFertilizerSource(_gameSession.activePlayer.activeItem);
						var oFertilizer:Fertilizer = oFertilizerSource.CreateFertilizer();
						
						oTile.fertilizer = oFertilizer;
						_gameSession.statTracker.fertilizersUsed++;
						_gameSession.activePlayer.activeItem = null;
					}
					else if (_gameSession.activePlayer.activeItem is Tool)
					{
						oTool = Tool(_gameSession.activePlayer.activeItem);
						
						if (oTool.type == Tool.TYPE_WATERING_CAN && oTool.charges > 0)
						{
							oTool.graphics.play();
							oTool.charges--;
							oSoil.AddWater(Tool.WATER_PER_CHARGE);
							_gameSession.statTracker.waterUsed += Tool.WATER_PER_CHARGE;
							_gameSession.activePlayer.activeItem = oTool;
						}
						else if (oTool.type == Tool.TYPE_HOE)
						{
							if (!oSoil.aeratedToday)
							{
								oTool.graphics.play();
								oSoil.aeratedToday = true;
								oSoil.RemoveWater(Tool.HOE_WATER_REMOVAL_AMOUNT[_gameSession.world.weather.current]);
								oSoil.Disturb(1);
							}
						}
					}
					
					RepaintAll();
				}
			}
		}
		
		///- Core Functionality -///
		
		
		/// Event Handlers ///
		
		private function OnClickEndTutorialButton(event:MouseEvent):void
		{
			event.stopPropagation();
			
			if (_gameSession.replayingTutorial == true)
			{
				_gameSession.LoadGame(false);
				_gameSession.tutorialStep = -1;
				_gameSession.replayingTutorial = false;
			}
			else
			{
				_gameSession.InitializeCommonGameState();
				_gameSession.InitializeTheWorldForNewGame();
			}
			
			RepaintAll();
		}
		
		private function OnClickPlateGraphics(event:MouseEvent):void
		{
			var oPixel:PixelLocation = new PixelLocation(event.stageX, event.stageY);
			
			// see if a menu was clicked on
			var oMenuState:MenuState = _gameSession.menuState;
			
			if (oMenuState.popUpMenu != null)
			{
				return;
			}
			
			if (oMenuState.parentMenu != null)
			{
				var iY:int = oMenuState.parentMenu.GetGridHeight() * UIManager.GRID_PIXEL_HEIGHT;
				
				if (oMenuState.childMenu != null)
				{
					iY += oMenuState.childMenu.GetGridHeight() * UIManager.GRID_PIXEL_HEIGHT;
				}
				
				if (oPixel.y <= iY)
				{
					return;
				}
			}
			
			// see if the footer was clicked on
			var oFooterLocation:FooterLocation = oPixel.GetFooterLocation();
			var iFooterIndex:int = FooterService.GetIndexForFooterLocation(oFooterLocation);
			
			if (iFooterIndex > -1)
			{
				var bTestResult:Boolean = true;
				
				if (TutorialService.IsTutorialActive(_gameSession.tutorialStep) == true)
				{
					bTestResult = TutorialService.IsValidFooterIndexForTutorial(_gameSession.tutorialStep, iFooterIndex);
					
					if (bTestResult == true)
					{
						_gameSession.tutorialStep++;
					}
				}
				
				if (bTestResult == true)
				{
					_gameRoot.controller.OnFooterLocationClick(iFooterIndex);
					RepaintAll();
				}
				
				return;
			}
			
			var oGrid:GridLocation = GetGridLocationForPixelLocation(oPixel);
			var iTileSection:int = GetTileSection(oGrid, oPixel);
			
			var oCenter:PixelLocation = GetPixelLocationForGridLocation(oGrid);
			
			if (oGrid.x > -1 && oGrid.y > -1)
			{
				OnGridClicked(oGrid.x, oGrid.y, iTileSection, oPixel);
			}
			
			RepaintAll();
		}
		
		protected function OnKeyDown(event:KeyboardEvent):void 
		{ 
			//trace("Key Pressed: " + String.fromCharCode(event.charCode) + " (character code: " + event.charCode + ")"); 
			
			event.stopPropagation();
			
			if (_gameSession.tutorialStep > -1)
			{
				var bIsValidKey:Boolean = TutorialService.IsValidKeyDownForTutorial(_gameSession.tutorialStep, event.charCode);
				
				if (bIsValidKey == true)
				{
					_gameSession.tutorialStep++;
				}
				else
				{
					return;
				}
			}
			
			var bRecordKey:Boolean = false;
			var sKey:String = String.fromCharCode(event.charCode);
			
			switch (sKey)
			{
				case "1":
				case "2":
				case "3":
					_gameRoot.controller.OnFooterLocationClick(int(sKey) - 1);
					bRecordKey = true;
					break;
				case "`":
					PlayerService.DropActiveItem(_gameSession.activePlayer);
					break;
				default:
					break;
			}
			
			switch (event.charCode)
			{
				case 27:  // escape key
					PlayerService.DropActiveItem(_gameSession.activePlayer);
					break;
				case 32: // spacebar
					_gameSession.AdvanceDay();
					break;
				default:
					break;
			}
			
			if ((_gameSession.activePlayer.activeItem is Tool) && bRecordKey == true)
			{
				var oTool:Tool = Tool(_gameSession.activePlayer.activeItem);
			}
			
			RepaintAll();			
		}
		
		public function OnMouseMove(event:MouseEvent):void
		{
			// get the Pixel Location for the current mouse position
			var oPixelLocation:PixelLocation = new PixelLocation(event.stageX, event.stageY);
			var oGridLocation:GridLocation = GetGridLocationForPixelLocation(oPixelLocation);
			var oFooterLocation:FooterLocation = oPixelLocation.GetFooterLocation();
			
			// footer preview item
			if (oFooterLocation.x != _lastFooterLocation.x || oFooterLocation.y != _lastFooterLocation.y)
			{
				_lastFooterLocation = new FooterLocation(oFooterLocation.x, oFooterLocation.y);
				
				if (oFooterLocation.x > -1 && oFooterLocation.y > -1)
				{
					var oFooterButton:FooterButton = FooterService.GetFooterButtonAtFooterLocation(_gameSession.footer, oFooterLocation);
					var oFooterPixelLocation:PixelLocation = oFooterLocation.GetPixelLocation();
					
					_gameSession.mouseOverUIPanel.footerPreviewItem = oFooterButton;
					_gameSession.mouseOverUIPanel.footerItemAnchor = new PixelLocation(oFooterPixelLocation.x, oFooterPixelLocation.y);
				}
				else
				{
					_gameSession.mouseOverUIPanel.footerPreviewItem = null;
				}
			}
			
			// grid preview item OR bldg preview
			_gameSession.mouseOverUIPanel.gridPreviewItem = null;
			_gameSession.mouseOverUIPanel.gridPreviewBldg = null;
			
			var nMinY:Number = GetMaxMenuY();
			
			// verify this is a valid tile for a grid preview item or building preview
			if (GridUtil.IsValidTile(_gameSession.world.tiles, oGridLocation) == true && oPixelLocation.y >= nMinY && _gameSession.menuState.popUpMenu == null)
			{
				var oTile:Tile = Tile(_gameSession.world.tiles[oGridLocation.x][oGridLocation.y]);
				var oGridCenterLocation:PixelLocation = GetPixelLocationForGridLocation(oGridLocation);
				
				// if no buildings here at all, use the ground
				if (oTile.leftBldgs.length == 0 && oTile.rightBldgs.length == 0)
				{
					_gameSession.mouseOverUIPanel.gridPreviewItem = new GridLocation(oGridLocation.x, oGridLocation.y);
					_gameSession.mouseOverUIPanel.gridItemAnchor = new PixelLocation(oGridCenterLocation.x, oGridCenterLocation.y);
				}
				// otherwise, use the building
				else
				{
					var bInLeftHalf:Boolean = true;
					
					if (oPixelLocation.x > oGridCenterLocation.x)
					{
						bInLeftHalf = false;
					}
					
					var lBldgs:Array = new Array();
					
					if (bInLeftHalf == true && oTile.leftBldgs.length > 0)
					{
						lBldgs = oTile.leftBldgs;
					}
					else if (bInLeftHalf == false && oTile.rightBldgs.length > 0)
					{
						lBldgs = oTile.rightBldgs;
					}
					
					for (var bldg:int = 0; bldg < lBldgs.length; bldg++)
					{
						var oBldg:Bldg = Bldg(lBldgs[bldg]);
						
						if (oBldg.bldgType == Bldg.TYPE_FARM_FENCE)
						{
							continue;
						}
						
						var bIsBldgHit:Boolean = IsBldgHit(oBldg, oPixelLocation);
						
						if (bIsBldgHit)
						{
							_gameSession.mouseOverUIPanel.gridPreviewBldg = oBldg;
							_gameSession.mouseOverUIPanel.gridBldgAnchor = new PixelLocation(oGridCenterLocation.x, oGridCenterLocation.y);
							break;
						}
					}
				}
			}
			
			if (_lastGridLocation.x != oGridLocation.x || _lastGridLocation.y != oGridLocation.y)
			{
				_lastGridLocation = new GridLocation(oGridLocation.x, oGridLocation.y);
				RepaintMouseOverUI();
			}
			if (_gameSession.mouseOverUIPanel.gridPreviewBldg != null)
			{
				RepaintMouseOverUI();
			}
			
			// map move arrows
			_mapMoveArrows = new Array();
			
			var oMenuState:MenuState = _gameSession.menuState;
			
			if (oMenuState.parentMenu == null && oMenuState.childMenu == null && oMenuState.popUpMenu == null)
			{
				var oMaxOffset:RectGridLocation = GetMaxRectGridOffset();
				
				if (oPixelLocation.y > UIManager.HORIZON_PIXEL_HEIGHT && oPixelLocation.y < (UIManager.HORIZON_PIXEL_HEIGHT + MapMoveArrow.PIXEL_SIZE) && _rectGridOffset.y > 0)
				{
					_mapMoveArrows.push(new MapMoveArrow(this, MapMoveArrow.DIR_UP));
				}
				
				if (oPixelLocation.y < UIManager.FOOTER_Y_PIXEL_OFFSET && oPixelLocation.y > (UIManager.FOOTER_Y_PIXEL_OFFSET - MapMoveArrow.PIXEL_SIZE) && _rectGridOffset.y < oMaxOffset.y)
				{
					_mapMoveArrows.push(new MapMoveArrow(this, MapMoveArrow.DIR_DOWN));
				}
				
				if (oPixelLocation.x > 0 && oPixelLocation.x < MapMoveArrow.PIXEL_SIZE && oPixelLocation.y > UIManager.HORIZON_PIXEL_HEIGHT && oPixelLocation.y < UIManager.FOOTER_Y_PIXEL_OFFSET && _rectGridOffset.x > 0)
				{
					_mapMoveArrows.push(new MapMoveArrow(this, MapMoveArrow.DIR_LEFT));
				}
				
				if (oPixelLocation.x < UIManager.SCREEN_PIXEL_WIDTH && oPixelLocation.x > (UIManager.SCREEN_PIXEL_WIDTH - MapMoveArrow.PIXEL_SIZE) && oPixelLocation.y > UIManager.HORIZON_PIXEL_HEIGHT && oPixelLocation.y < UIManager.FOOTER_Y_PIXEL_OFFSET && _rectGridOffset.x < oMaxOffset.x)
				{
					_mapMoveArrows.push(new MapMoveArrow(this, MapMoveArrow.DIR_RIGHT));
				}
			}
			
			RepaintMapMoveArrow();
			
			// update the mouseLoadGraphics if present
			if (_gameSession.activePlayer.activeItem != null)
			{
				RepaintMouseLoad(oPixelLocation);
			}
		}
		
		///- Event Handlers -///
		
		
		/// Graphics ///
		
		private function EraseBldgAndPlant():void
		{
			var iNumChildren:int = _bldgAndPlantGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_bldgAndPlantGraphics.removeChildAt(0);
			}
		}
		
		private function EraseFooterUI():void
		{
			var iNumChildren:int = _footerUIGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_footerUIGraphics.removeChildAt(0);
			}
		}
		
		private function EraseHorizon():void
		{
			var iNumChildren:int = _horizonGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_horizonGraphics.removeChildAt(0);
			}
		}
		
		private function EraseMapMoveArrow():void
		{
			var iNumChildren:int = _mapMoveArrowGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_mapMoveArrowGraphics.removeChildAt(0);
			}
		}
		
		private function EraseMenu():void
		{
			var iNumChildren:int = _menuGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_menuGraphics.removeChildAt(0);
			}
		}
		
		private function EraseMouseLoad():void
		{
			var iNumChildren:int = _mouseLoadGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_mouseLoadGraphics.removeChildAt(0);
			}
		}
		
		private function EraseMouseOverUI():void
		{
			var iNumChildren:int = _mouseOverUIGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_mouseOverUIGraphics.removeChildAt(0);
			}
		}
		
		private function ErasePopUpMenu():void
		{
			var iNumChildren:int = _popUpMenuGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_popUpMenuGraphics.removeChildAt(0);
			}
		}
		
		private function ErasePrecipitation():void
		{
			var iNumChildren:int = _precipitationGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_precipitationGraphics.removeChildAt(0);
			}
		}
		
		private function EraseSoil():void
		{
			var iNumChildren:int = _soilGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_soilGraphics.removeChildAt(0);
			}
		}
		
		private function EraseTerrain():void
		{
			var iNumChildren:int = _terrainGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_terrainGraphics.removeChildAt(0);
			}
		}
		
		private function EraseTutorial():void
		{
			var iNumChildren:int = _tutorialGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_tutorialGraphics.removeChildAt(0);
			}
		}
		
		private function EraseWeather():void
		{
			var iNumChildren:int = _weatherGraphics.numChildren;
			
			for (var i:int = 0; i < iNumChildren; i++)
			{
				_weatherGraphics.removeChildAt(0);
			}
		}
		
		private function GetNextDrawLocation(currentX:int, currentY:int, maxX:int, maxY:int):GridLocation
		{
			var oNextTile:GridLocation = null;
			
			// special case to start up
			if (currentX == -1 && currentY == -1)
			{
				oNextTile = new GridLocation(maxX, 0);
				return oNextTile;
			}
			
			// special case to end
			if (currentX == 0 && currentY == maxY)
			{
				oNextTile = new GridLocation(-1, -1);
				return oNextTile;
			}
			
			var iDifference:int = currentX - currentY;
			
			// if we bottomed out in either direction, transition to the next row
			if (currentX == maxX || currentY == maxY)
			{
				if (iDifference > 0)
				{
					oNextTile = new GridLocation(iDifference - 1, 0);
				}
				else if (iDifference == 0)
				{
					oNextTile = new GridLocation(0, 1);
				}
				else if (iDifference < 0)
				{
					oNextTile = new GridLocation(0, Math.abs(iDifference) + 1);
				}
			}
			// otherwise, go to the next column in this row
			else
			{
				oNextTile = new GridLocation(currentX + 1, currentY + 1);
			}
			
			return oNextTile;
		}
		
		private function GetPreviewGraphicsForGridLocation(gridLocation:GridLocation):MovieClip
		{
			var mcGrid:MovieClip = new MovieClip();
			
			if (GridUtil.IsValidTile(_gameSession.world.tiles, gridLocation) == false)
			{
				return mcGrid;
			}
			
			var oTile:Tile = Tile(_gameSession.world.tiles[gridLocation.x][gridLocation.y]);
			var iSeason:int = _gameSession.time.season;
			
			// We need to pass the plant's tolerances into the Soil preview.
			var iMinSat:int = -1;
			var iLowSat:int = -1;
			var iHighSat:int = -1;
			var iMaxSat:int = -1;
			var iHighTox:int = -1;
			var iMaxTox:int = -1;
			
			// only show further detail if the soil is owned by the player
			var oSoil:Soil = oTile.soil;
			
			if (oSoil == null)
			{
				return mcGrid;
			}
			
			if (oSoil.isPlayerOwned == false)
			{
				return mcGrid;
			}
			
			//1. Plant
			var oPlant:Plant = oTile.plant;
			
			if (oPlant != null)
			{
				if (PlantService.IsPlantInSeason(oPlant, iSeason) == true)
				{
					iMinSat = oPlant.inSeasonMinSaturation;
					iLowSat = oPlant.inSeasonLowSaturation;
					iHighSat = oPlant.inSeasonHighSaturation;
					iMaxSat = oPlant.inSeasonMaxSaturation;
				}
				else
				{
					iMinSat = oPlant.outSeasonMinSaturation;
					iMaxSat = oPlant.outSeasonMaxSaturation;
				}
				
				iHighTox = oPlant.highToxicity;
				iMaxTox = oPlant.maxToxicity;
				
				var mcPlantPreview:MovieClip = oPlant.GetDataPreviewGraphics();
				mcPlantPreview.y = 0;
				mcGrid.addChild(mcPlantPreview);
				
				// 1.5 Fruit
				var oFruit:Fruit = oPlant.fruit;
				
				if (oFruit != null)
				{
					var mcFruitPreview:MovieClip = oFruit.GetPreviewGraphics();
					mcFruitPreview.y = 100;
					mcGrid.addChild(mcFruitPreview);
				}
			}
			
			//2. Standing plant scraps
			var oPlantScrap:PlantScrap = oTile.plantScrap;
			
			if (oPlantScrap != null)
			{
				var mcPlantScrapPreview:MovieClip = oPlantScrap.GetPreviewGraphics();
				mcPlantScrapPreview.x = 0;
				mcPlantScrapPreview.y = 0;
				mcGrid.addChild(mcPlantScrapPreview);
			}
			
			//3. Soil
			var oFertilizer:Fertilizer = oTile.fertilizer;
			
			if (_gameSession.activePlayer.activeItem is Seed)
			{
				var oSeed:Seed = Seed(_gameSession.activePlayer.activeItem);
				var oFakePlant:Plant = new Plant(oSeed.type);
				
				if (PlantService.IsPlantInSeason(oFakePlant, iSeason) == true)
				{
					iMinSat = oFakePlant.inSeasonMinSaturation;
					iLowSat = oFakePlant.inSeasonLowSaturation;
					iHighSat = oFakePlant.inSeasonHighSaturation;
					iMaxSat = oFakePlant.inSeasonMaxSaturation;
				}
				else
				{
					iMinSat = oFakePlant.outSeasonMinSaturation;
					iMaxSat = oFakePlant.outSeasonMaxSaturation;
				}
				
				iHighTox = oFakePlant.highToxicity;
				iMaxTox = oFakePlant.maxToxicity;
			}
			
			if (oSoil != null)
			{
				var mcSoilPreview:MovieClip = oSoil.GetDataPreviewGraphics(iMinSat, iLowSat, iHighSat, iMaxSat, iHighTox, iMaxTox, oFertilizer);
				mcSoilPreview.x = 0;
				mcSoilPreview.y = 0;
				mcGrid.addChild(mcSoilPreview);
				
				if (mcPlantPreview != null)
				{
					mcPlantPreview.x = mcSoilPreview.width;
				}
				
				if (mcFruitPreview != null)
				{
					mcFruitPreview.x = mcSoilPreview.width;
				}
				
				if (mcPlantScrapPreview != null)
				{
					mcPlantScrapPreview.x = mcSoilPreview.width;
				}
			}
			
			//4. Fertilizer
			if (oFertilizer != null)
			{
				var mcFertilizerPreview:MovieClip = oFertilizer.GetDataPreviewGraphics();
				mcFertilizerPreview.x = 0;
				mcFertilizerPreview.y = mcSoilPreview.height;
				mcGrid.addChild(mcFertilizerPreview);
			}
			
			return mcGrid;
		}
		
		private function PaintBldgAndPlant():void
		{
			var oDrawLocation:GridLocation = new GridLocation(-1, -1);
			
			while (true)
			{
				oDrawLocation = GetNextDrawLocation(oDrawLocation.x, oDrawLocation.y, _gameSession.world.width - 1, _gameSession.world.height - 1);
				
				if (oDrawLocation.x == -1 && oDrawLocation.y == -1)
				{
					break;
				}
				
				if (GridUtil.IsValidTile(_gameSession.world.tiles, oDrawLocation) == false)
				{
					continue;
				}
				
				DrawBldgAndPlant(oDrawLocation);
			}
			
			// hills
			var mcHills:Terrain_Hills_MC = new Terrain_Hills_MC();
			mcHills.x = 360;
			mcHills.y = 120;
			_bldgAndPlantGraphics.addChild(mcHills);
		}
		
		private function DrawBldgAndPlant(drawLocation:GridLocation):void
		{
			var oPixelLocation:PixelLocation = GetPixelLocationForGridLocation(drawLocation);
			var oTile:Tile = Tile(_gameSession.world.tiles[drawLocation.x][drawLocation.y]);
			var oSoil:Soil = oTile.soil;
			
			// plant
			var oPlant:Plant = oTile.plant;
			
			if (oPlant != null && (_gameSession.menuState.showPlants == true || (oSoil != null && oSoil.isPlayerOwned == false)))
			{
				var mcPlant:MovieClip = oPlant.GetGraphics();
				
				if (mcPlant != null)
				{
					mcPlant.x = oPixelLocation.x;
					mcPlant.y = oPixelLocation.y;
					_bldgAndPlantGraphics.addChild(mcPlant);
				}
			}
			
			// plant scraps
			var oPlantScrap:PlantScrap = oTile.plantScrap;
			
			if (oPlantScrap != null)
			{
				var mcPlantScrap:MovieClip = oPlantScrap.GetGridGraphics();
				mcPlantScrap.x = oPixelLocation.x - (mcPlantScrap.width / 2);
				mcPlantScrap.y = oPixelLocation.y - (mcPlantScrap.height / 2);
				_bldgAndPlantGraphics.addChild(mcPlantScrap);
			}
			
			// bldg
			for (var i:int = 0; i < oTile.rightBldgs.length; i++)
			{
				var oBldg:Bldg = oTile.rightBldgs[i];
				
				if (oBldg.origin.x == drawLocation.x && oBldg.origin.y == drawLocation.y)
				{
					var mcBldg:MovieClip = oBldg.GetGraphics();
					mcBldg.x = oPixelLocation.x;
					mcBldg.y = oPixelLocation.y;
					_bldgAndPlantGraphics.addChild(mcBldg);
					return;
				}
			}
			
			for (i = 0; i < oTile.leftBldgs.length; i++)
			{
				oBldg = oTile.leftBldgs[i];
				
				if (oBldg.origin.x == drawLocation.x && oBldg.origin.y == drawLocation.y)
				{
					mcBldg = oBldg.GetGraphics();
					mcBldg.x = oPixelLocation.x;
					mcBldg.y = oPixelLocation.y;
					_bldgAndPlantGraphics.addChild(mcBldg);
					return;
				}
			}
		}
		
		private function PaintFooterUI():void
		{
			var mcFooter:FooterUI_MC = new FooterUI_MC();
			mcFooter.x = FOOTER_X_PIXEL_OFFSET;
			mcFooter.y = FOOTER_Y_PIXEL_OFFSET;

			// stats
			mcFooter.Cash.text = String(_gameSession.activePlayer.cash);
			mcFooter.Date.text = String(_gameSession.time.date + 1);
			mcFooter.Day.text = String(Time.DAYS_LONG[_gameSession.time.day]);
			
			if (_gameSession.time.useMonth)
			{
				mcFooter.Month.text = String(Time.MONTHS_SHORT[_gameSession.time.month]);
			}
			
			mcFooter.Season.text = String(Time.SEASONS[_gameSession.time.season]);
			mcFooter.Year.text = String(_gameSession.time.year);
			
			// tool graphics
			var iX:int = (UIManager.FOOTER_PIXEL_WIDTH / 2);
			var iY:int = (UIManager.FOOTER_PIXEL_HEIGHT / 2);
			
			for (var i:int = 0; i < _gameSession.footer.contents.length; i++)
			{
				var oFooterObject:Object = _gameSession.footer.contents[i];
				
				if (oFooterObject is FooterButton)
				{
					var oButton:FooterButton = FooterButton(oFooterObject);
					var mcButton:SimpleButton = oButton.Paint();
					mcButton.x = iX;
					mcButton.y = iY;
					mcFooter.addChild(mcButton);
				}
				
				iX += UIManager.FOOTER_PIXEL_WIDTH;
			}
			
			// end tutorial button
			if (_gameSession.tutorialStep > -1)
			{
				var mcEndTutorial:MenuHeader_Close_Btn = new MenuHeader_Close_Btn();
				mcEndTutorial.x = 692.5;
				mcEndTutorial.y = 25;
				mcEndTutorial.addEventListener(MouseEvent.CLICK, OnClickEndTutorialButton, false, 0, true);
				mcFooter.addChild(mcEndTutorial);
			}
			
			_footerUIGraphics.addChild(mcFooter);
		}
		
		private function PaintHorizon():void
		{
			var mcHorizon:MovieClip = new MovieClip();
			
			// sunrise = 220 degrees
			// dawn ends at 235 degrees
			// noon = 270 degrees
			// dusk begins at 305 degrees
			// sunset = 320 degrees
			
			var iCurrentWeather:int = _gameSession.world.weather.current;
			
			// skybox color panel
			var uiSkyboxColor:uint = _gameSession.world.horizon.skyboxColor;
			mcHorizon.graphics.beginFill(uiSkyboxColor);
			mcHorizon.graphics.drawRect(0, 0, 720, 120);
			mcHorizon.graphics.endFill();
			
			_horizonGraphics.addChild(mcHorizon);
			
			// sun
			var oSun:Sun = _gameSession.world.horizon.sun;
			
			if (oSun != null)
			{
				var mcSun:MovieClip = oSun.Paint();
				
				mcSun.x = oSun.pixelLocation.x;
				mcSun.y = oSun.pixelLocation.y;
				
				_horizonGraphics.addChild(mcSun);
			}
		}
		
		private function PaintMapMoveArrow():void
		{
			for (var i:int = 0; i < _mapMoveArrows.length; i++)
			{
				var oMapMoveArrow:MapMoveArrow = MapMoveArrow(_mapMoveArrows[i]);
				var mcMapMoveArrow:MovieClip = oMapMoveArrow.Paint();
				_mapMoveArrowGraphics.addChild(mcMapMoveArrow);
			}
		}
		
		private function PaintMenu():void
		{
			var oMenuState:MenuState = _gameSession.menuState;
			
			if (oMenuState.parentMenu != null)
			{
				var oMenuGraphics:MovieClip = oMenuState.parentMenu.Paint();
				_menuGraphics.addChild(oMenuGraphics);
				
				if (oMenuState.childMenu != null)
				{
					var oChildMenuGraphics:MovieClip = oMenuState.childMenu.Paint();
					oChildMenuGraphics.y = oMenuGraphics.y + oMenuGraphics.height;
					_menuGraphics.addChild(oChildMenuGraphics);
				}
			}
		}
		
		private function PaintMouseLoad(mouseLocation:PixelLocation):void
		{
			if (_gameSession.activePlayer.activeItem is IItem)
			{
				var oItemGraphics:MovieClip = IItem(_gameSession.activePlayer.activeItem).GetItemGraphics();
				oItemGraphics.x = mouseLocation.x + 20;
				oItemGraphics.y = mouseLocation.y - 25;
				_mouseLoadGraphics.addChild(oItemGraphics);
			}
		}
		
		private function PaintMouseOverUI():void
		{
			var mcPreview:MovieClip = null;
			
			if (TutorialService.IsTutorialActive(_gameSession.tutorialStep) == true)
			{
				if (_gameSession.mouseOverUIPanel.gridPreviewItem != null)
				{
					var oCheckLocation:GridLocation = GridLocation(_gameSession.mouseOverUIPanel.gridPreviewItem);
					var bShowHover:Boolean = TutorialService.IsValidGridHoverForTutorial(_gameSession.tutorialStep, oCheckLocation);
					
					if (bShowHover == false)
					{
						return;
					}
				}
				else
				{
					return;
				}
			}
			
			// 1. menu preview item
			var oPreviewItem:Object = _gameSession.mouseOverUIPanel.menuPreviewItem;
			
			if (oPreviewItem != null)
			{
				mcPreview = GetPreviewItemGraphics(oPreviewItem);
				var oPosition:PixelLocation = UIManager.GetMouseOverUIPosition(_gameSession.mouseOverUIPanel.menuItemAnchor, mcPreview.width, mcPreview.height, 90, 90, UIManager.ORIENTATION_DOWN);
				mcPreview.x = oPosition.x;
				mcPreview.y = oPosition.y;
				_mouseOverUIGraphics.addChild(mcPreview);
				return;
			}		
			
			// 2. footer preview item
			oPreviewItem = _gameSession.mouseOverUIPanel.footerPreviewItem;
			
			if (oPreviewItem != null)
			{
				mcPreview = GetPreviewItemGraphics(oPreviewItem);
				oPosition = UIManager.GetMouseOverUIPosition(_gameSession.mouseOverUIPanel.footerItemAnchor, mcPreview.width, mcPreview.height, UIManager.FOOTER_PIXEL_WIDTH, UIManager.FOOTER_PIXEL_HEIGHT, UIManager.ORIENTATION_UP);
				mcPreview.x = oPosition.x;
				mcPreview.y = oPosition.y;
				_mouseOverUIGraphics.addChild(mcPreview);
				return;
			}
			
			// 3. grid preview item
			oPreviewItem = _gameSession.mouseOverUIPanel.gridPreviewItem;
			
			if (oPreviewItem != null)
			{
				mcPreview = GetPreviewGraphicsForGridLocation(GridLocation(oPreviewItem));
				mcPreview.x = 0;
				mcPreview.y = 0;
				_mouseOverUIGraphics.addChild(mcPreview);
			}
			
			// 4. Bldg
			if (_gameSession.mouseOverUIPanel.gridPreviewBldg != null)
			{
				mcPreview = Bldg(_gameSession.mouseOverUIPanel.gridPreviewBldg).GetPreviewGraphics();
				var mcBldg:MovieClip = Bldg(_gameSession.mouseOverUIPanel.gridPreviewBldg).GetGraphics();
				oPosition = UIManager.GetMouseOverUIPosition(_gameSession.mouseOverUIPanel.gridBldgAnchor, mcPreview.width, mcPreview.height, mcBldg.width, mcBldg.height, UIManager.ORIENTATION_DOWN);
				mcPreview.x = oPosition.x;
				mcPreview.y = oPosition.y;
				_mouseOverUIGraphics.addChild(mcPreview);
			}
		}
		
		private static function GetMouseOverUIPosition(anchor:PixelLocation, previewWidth:int, previewHeight:int, bufferWidth:int, bufferHeight:int, defaultOrientation:int):PixelLocation
		{
			if (anchor == null)
			{
				return null;
			}
			
			var oDefaultUp:PixelLocation = new PixelLocation(anchor.x - (previewWidth / 2), (anchor.y - (bufferHeight / 2)) - previewHeight);
			var oDefaultDown:PixelLocation = new PixelLocation(anchor.x - (previewWidth / 2), anchor.y + (bufferHeight / 2));
			var oDefaultLeft:PixelLocation = new PixelLocation((anchor.x - (bufferWidth / 2)) - previewWidth, anchor.y - (previewHeight / 2));
			var oDefaultRight:PixelLocation = new PixelLocation(anchor.x + (bufferWidth / 2), anchor.y - (previewHeight / 2));
			var oPosition:PixelLocation = new PixelLocation(0, 0);
			
			if (defaultOrientation == UIManager.ORIENTATION_UP)
			{
				if (oDefaultUp.y >= 0)
				{
					oPosition = new PixelLocation(oDefaultUp.x, oDefaultUp.y);
				}
				else
				{
					oPosition = new PixelLocation(oDefaultDown.x, oDefaultDown.y);
				}
				
				if (oPosition.x < 0)
				{
					oPosition.x = 0;
				}
				else if ((oPosition.x + previewWidth) > UIManager.SCREEN_PIXEL_WIDTH)
				{
					oPosition.x = UIManager.SCREEN_PIXEL_WIDTH - previewWidth;
				}
			}
			else if (defaultOrientation == UIManager.ORIENTATION_DOWN)
			{
				if ((oDefaultDown.y + previewHeight) < UIManager.SCREEN_PIXEL_HEIGHT)
				{
					oPosition = new PixelLocation(oDefaultDown.x, oDefaultDown.y);
				}
				else
				{
					oPosition = new PixelLocation(oDefaultUp.x, oDefaultUp.y);
				}
				
				if (oPosition.x < 0)
				{
					oPosition.x = 0;
				}
				else if ((oPosition.x + previewWidth) > UIManager.SCREEN_PIXEL_WIDTH)
				{
					oPosition.x = UIManager.SCREEN_PIXEL_WIDTH - previewWidth;
				}
			}
			else if (defaultOrientation == UIManager.ORIENTATION_LEFT)
			{
				if (oDefaultLeft.x > 0)
				{
					oPosition = new PixelLocation(oDefaultLeft.x, oDefaultLeft.y);
				}
				else
				{
					oPosition = new PixelLocation(oDefaultRight.x, oDefaultRight.y);
				}
				
				if (oPosition.y < 0)
				{
					oPosition.y = 0;
				}
				else if ((oPosition.y + previewHeight) > UIManager.SCREEN_PIXEL_HEIGHT)
				{
					oPosition.y = UIManager.SCREEN_PIXEL_HEIGHT - previewHeight;
				}
			}
			else if (defaultOrientation == UIManager.ORIENTATION_RIGHT)
			{
				if ((oDefaultRight.x + previewWidth) < UIManager.SCREEN_PIXEL_WIDTH)
				{
					oPosition = new PixelLocation(oDefaultRight.x, oDefaultRight.y);
				}
				else
				{
					oPosition = new PixelLocation(oDefaultLeft.x, oDefaultLeft.y);
				}
				
				if (oPosition.y < 0)
				{
					oPosition.y = 0;
				}
				else if ((oPosition.y + previewHeight) > UIManager.SCREEN_PIXEL_HEIGHT)
				{
					oPosition.y = UIManager.SCREEN_PIXEL_HEIGHT - previewHeight;
				}
			}
			
			return oPosition;			
		}
		
		private function PositionMouseOverUIItem(previewGraphics:MovieClip):void
		{
			if (previewGraphics == null)
			{
				return;
			}
			
			var sMouseQuadrant:String = GetMouseQuadrant();
			
			switch (sMouseQuadrant)
			{
				case "UpperLeft":
					previewGraphics.x = UIManager.SCREEN_PIXEL_WIDTH - previewGraphics.width;
					previewGraphics.y = UIManager.FOOTER_Y_PIXEL_OFFSET - previewGraphics.height;
					break;
				case "UpperRight":
					previewGraphics.x = 0;
					previewGraphics.y = UIManager.FOOTER_Y_PIXEL_OFFSET - previewGraphics.height;
					break;
				case "LowerLeft":
					previewGraphics.x = UIManager.SCREEN_PIXEL_WIDTH - previewGraphics.width;
					previewGraphics.y = 0;
					break;
				case "LowerRight":
					previewGraphics.x = 0;
					previewGraphics.y = 0;
					break;
				default:
					break;
			}
		}
		
		private function GetPreviewItemGraphics(previewItem:Object):MovieClip
		{
			var mcPreviewItem:MovieClip = null;
			
			if (previewItem == null)
			{
				return null;
			}
			
			if (previewItem is Seed)
			{
				mcPreviewItem = previewItem.GetPreviewGraphics(_gameSession.time.season);
			}
			else if (previewItem is ItemBldg)
			{
				mcPreviewItem = ItemBldg(previewItem).GetPreviewGraphics();
			}
			else if (previewItem is FooterButton)
			{
				mcPreviewItem = FooterButton(previewItem).GetPreviewGraphics();
			}
			else
			{
				mcPreviewItem = previewItem.GetPreviewGraphics();
			}
			
			return mcPreviewItem;
		}
		
		private function PaintPopUpMenu():void
		{
			var oMenuState:MenuState = _gameSession.menuState;
			
			if (oMenuState.popUpMenu == null)
			{
				return;
			}
			
			var mcPopUpMenu:MovieClip = oMenuState.popUpMenu.Paint();
			mcPopUpMenu.x = UIManager.SCREEN_PIXEL_WIDTH / 2;
			mcPopUpMenu.y = UIManager.SCREEN_PIXEL_HEIGHT / 2;
			
			_popUpMenuGraphics.addChild(mcPopUpMenu);
		}
		
		private function PaintPrecipitation(precipitation:MovieClip):void
		{
			_precipitationGraphics.addChild(precipitation);
		}
		
		private function PaintSoil():void
		{
			for (var x:int = 0; x < _gameSession.world.width; x++)
			{
				for (var y:int = 0; y < _gameSession.world.height; y++)
				{
					var oGridLocation:GridLocation = new GridLocation(x, y);
					var oPixelLocation:PixelLocation = GetPixelLocationForGridLocation(oGridLocation);
					
					if (GridUtil.IsValidTile(_gameSession.world.tiles, new GridLocation(x, y)) == false)
					{
						continue;
					}
					
					var oTile:Tile = Tile(_gameSession.world.tiles[x][y]);
					var oSoil:Soil = oTile.soil;
					
					if (oSoil == null)
					{
						continue;
					}
					
					var oPlant:Plant = oTile.plant;
					var mcSoil:MovieClip = oSoil.Paint(oPlant);
					
					if (mcSoil != null)
					{
						mcSoil.x = oPixelLocation.x;
						mcSoil.y = oPixelLocation.y;
						_soilGraphics.addChild(mcSoil);
					}
				}
			}
		}
		
		private function PaintTerrain():void
		{
			for (var x:int = 0; x < _gameSession.world.width; x++)
			{
				for (var y:int = 0; y < _gameSession.world.height; y++)
				{
					if (GridUtil.IsValidTile(_gameSession.world.tiles, new GridLocation(x, y)) == false)
					{
						continue;
					}
					
					var oTile:Tile = Tile(_gameSession.world.tiles[x][y]);
					var oTerrain:Terrain = oTile.terrain;
					
					if (oTerrain == null)
					{
						continue;
					}
					
					var mcTerrain:MovieClip = oTerrain.Paint();
					var oGridLocation:GridLocation = new GridLocation(x, y);
					var oPixelLocation:PixelLocation = GetPixelLocationForGridLocation(oGridLocation);
					
					mcTerrain.x = oPixelLocation.x;
					mcTerrain.y = oPixelLocation.y;
					_terrainGraphics.addChild(mcTerrain);
				}
			}
		}
		
		private function PaintTutorial():void
		{
			if (_gameSession.tutorialStep < 0)
			{
				return;
			}
			
			var mcTutorial:MovieClip = new MovieClip();
			
			var iId:int = TutorialStep.GetIdForStepNumber(_gameSession.tutorialStep);
			
			var sMCName:String = "TutorialStep" + iId + "_MC";
			var oClass:Class = Class(getDefinitionByName(sMCName));
			mcTutorial = new oClass();
			
			mcTutorial.x = 360;
			mcTutorial.y = 400;
			
			_tutorialGraphics.addChild(mcTutorial);
		}
		
		private function PaintWeather():void
		{
			// sunrise = 220 degrees
			// dawn ends at 235 degrees
			// noon = 270 degrees
			// dusk begins at 305 degrees
			// sunset = 320 degrees
			
			// clouds
			var lClouds:Array = _gameSession.world.horizon.clouds;
			
			for (var i:int = 0; i < lClouds.length; i++)
			{
				var oCloud:Cloud = Cloud(lClouds[i]);
				var mcCloud:MovieClip = oCloud.Paint();
				mcCloud.x = oCloud.pixelLocation.x;
				mcCloud.y = oCloud.pixelLocation.y;
				_weatherGraphics.addChild(mcCloud);
			}
			
			// weather color panel overlay
			var mcWeather:MovieClip = new MovieClip();
			var iCurrentWeather:int = _gameSession.world.weather.current;
			
			if (iCurrentWeather == Weather.TYPE_RAIN)
			{
				mcWeather.graphics.beginFill(0x999999, .4);
				mcWeather.graphics.drawRect(0, 0, 720, 800);
				mcWeather.graphics.endFill();
			}
			else if (iCurrentWeather == Weather.TYPE_STORM)
			{
				mcWeather.graphics.beginFill(0x666666, .4);
				mcWeather.graphics.drawRect(0, 0, 720, 800);
				mcWeather.graphics.endFill();
			}
			
			var nPercentOfDawn:Number = (20 - _gameSession.time.time) / 20;
			var nPercentOfDusk:Number = (_gameSession.time.time - 80) / 20;
			
			if (iCurrentWeather == Weather.TYPE_HOT)
			{
				if (_gameSession.time.time <= 20)
				{
					mcWeather.graphics.beginFill(0xFFFF00, nPercentOfDawn * .3);
					mcWeather.graphics.drawRect(0, 0, 720, 800);
					mcWeather.graphics.endFill();
				}
			}
			
			if (_gameSession.time.time >= 80)
			{
				mcWeather.graphics.beginFill(0x000000, nPercentOfDusk * .4);
				mcWeather.graphics.drawRect(0, 0, 720, 800);
				mcWeather.graphics.endFill();
			}
			
			_weatherGraphics.addChild(mcWeather);
		}
		
		///- Graphics -///
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(UIManager.GetMouseOverUIPositionNullIfAnchorNull());
			lResults = lResults.concat(UIManager.GetMouseOverUIPositionReturnsCorrectPosition());
			
			return lResults;
		}
		
		private static function GetMouseOverUIPositionNullIfAnchorNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("UIManager", "GetMouseOverUIPositionNullIfAnchorNull");
			var oAnchor:PixelLocation = null;
			
			var oActual:PixelLocation = UIManager.GetMouseOverUIPosition(oAnchor, 10, 10, 10, 10, UIManager.ORIENTATION_UP);
			
			oResult.TestNull(oActual);
			
			return oResult;
		}
		
		private static function GetMouseOverUIPositionReturnsCorrectPosition():Array
		{
			var iUp:int = UIManager.ORIENTATION_UP;
			var iDown:int = UIManager.ORIENTATION_DOWN;
			var iLeft:int = UIManager.ORIENTATION_LEFT;
			var iRight:int = UIManager.ORIENTATION_RIGHT;
			
			var lResults:Array = new Array();
			
			var lTestName:Array = [ "Up Default", "Up Flip", "Up Nudge Right", "Up Nudge Left", "Down Default", "Down Flip", "Down Nudge Right", "Down Nudge Left",
								    "Left Default", "Left Flip", "Left Nudge Down", "Left Nudge Up", "Right Default", "Right Flip", "Right Nudge Down", "Right Nudge Up" ];
			var lAnchorX:Array = [ 360, 360, 30, 690, 360, 360, 30, 690, 360, 30, 360, 360, 360, 690, 360, 360 ];
			var lAnchorY:Array = [ 400, 30, 400, 400, 400, 770, 400, 400, 400, 400, 30, 770, 400, 400, 30, 770 ];
			var lPreviewWidth:Array = [ 100, 100, 100, 100, 100, 100, 100, 100, 50, 50, 50, 50, 50, 50, 50, 50 ];
			var lPreviewHeight:Array = [ 50, 50, 50, 50, 50, 50, 50, 50, 100, 100, 100, 100, 100, 100, 100, 100 ];
			var lBufferWidth:Array = [ 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20 ];
			var lBufferHeight:Array = [ 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20 ];
			var lOrientation:Array = [ iUp, iUp, iUp, iUp, iDown, iDown, iDown, iDown, iLeft, iLeft, iLeft, iLeft, iRight, iRight, iRight, iRight ];
			var lExpectedX:Array = [ 310, 310, 0, 620, 310, 310, 0, 620, 300, 40, 300, 300, 370, 630, 370, 370 ];
			var lExpectedY:Array = [ 340, 40, 340, 340, 410, 710, 410, 410, 350, 350, 0, 700, 350, 350, 0, 700 ];
			
			for (var i:int = 0; i < lAnchorX.length; i++)
			{
				var iAnchorX:int = int(lAnchorX[i]);
				var iAnchorY:int = int(lAnchorY[i]);
				var oAnchor:PixelLocation = new PixelLocation(iAnchorX, iAnchorY);
				var iPreviewWidth:int = int(lPreviewWidth[i]);
				var iPreviewHeight:int = int(lPreviewHeight[i]);
				var iBufferWidth:int = int(lBufferWidth[i]);
				var iBufferHeight:int = int(lBufferHeight[i]);
				var iOrientation:int = int(lOrientation[i]);
				var iExpectedX:int = int(lExpectedX[i]);
				var iExpectedY:int = int(lExpectedY[i]);
				var oExpected:PixelLocation = new PixelLocation(iExpectedX, iExpectedY);
				
				var oResult:UnitTestResult = new UnitTestResult("UIManager", "GetMouseOverUIPositionReturnsCorrectPosition - " + String(lTestName[i]));
				oResult.expected = oExpected.PrettyPrint();
				var oActual:PixelLocation = UIManager.GetMouseOverUIPosition(oAnchor, iPreviewWidth, iPreviewHeight, iBufferWidth, iBufferHeight, iOrientation);
				oResult.actual = oActual.PrettyPrint();
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		//- Testing Methods -//
	}
}