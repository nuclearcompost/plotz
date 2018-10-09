package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A House Bldg in the world; it acts as a main menu
	//
	//Public Properties:
	//	contents:Inventory { get; } = The building's inventory contents
	//
	//Public Methods:
	//	GetPreviewGraphics():MovieClip = Get a movieclip that represents a preview of the Building for display on the Main UI
	//	Paint():MovieClip = Get a movieclip that represents the Building in the world
	//
	//-----------------------
	public class House extends FarmBldg
	{
		// Constants //
		
		public static const MENU_LABEL_NAME:String = "House";
		
		public static const TAB_GAME:int = 0;
		public static const TAB_GARBAGE:int = 1;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get bldgType():int
		{
			return Bldg.TYPE_FARM_HOUSE;
		}
		
		public function get garbage():Inventory
		{
			return _garbage;
		}
		
		public function set garbage(value:Inventory):void
		{
			_garbage = value;
		}
		
		public override function get gridDepth():int
		{
			return 3;
		}
		
		public override function get gridHeight():int
		{
			return 3;
		}
		
		public override function get gridWidth():int
		{
			return 3;
		}
		
		public override function get hitMaskHeight():int
		{
			return 180;
		}
		
		public override function get hitMaskWidth():int
		{
			return 180;
		}
		
		public override function get registrationPoint():PixelLocation
		{
			var oPoint:PixelLocation = new PixelLocation(90, 165);
			
			return oPoint;
		}
		
		public function get showChildTabs():Array
		{
			return _showChildTabs;
		}
		
		public function set showChildTabs(value:Array):void
		{
			_showChildTabs = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _garbage:Inventory;
		private var _showChildTabs:Array;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function House(origin:GridLocation = null, farm:Farm = null, garbage:Inventory = null, showChildTabs:Array = null)
		{
			super(origin, farm);
			
			_garbage = garbage;
			if (_garbage == null)
			{
				_garbage = new Inventory(8, "Garbage", [ "BagFertilizer", "Compost", "CompostBin", "Fruit", "PlantScrap", "Seed" ], new Array(), true);
			}
			
			_showChildTabs = showChildTabs;
			if (_showChildTabs == null)
			{
				_showChildTabs = [ null, true, null ];
			}
		}
		
		//- Initialization -//
	
	
		// Public Methods //
		
		public override function GetChildMenu(gameController:GameController, startTab:int = 0):ChildMenuFrame
		{
			return null;
		}
		
		public override function GetGraphics():MovieClip
		{
			var oGraphics:MovieClip = new Bldg_House_MC();
			
			return oGraphics;
		}
		
		public override function GetHitMask():MovieClip
		{
			var mcHitMask:MovieClip = new Bldg_HitMask_MC();
			mcHitMask.gotoAndStop(2);
			
			return mcHitMask;
		}
		
		public override function GetMenu(gameController:GameController):ParentMenuFrame
		{
			var oBtns:Array = [ MenuHeader.HEADER_BUTTON_CANCEL ];
			
			var oGarbageMenu:StorageMenu = new StorageMenu(_garbage, gameController);
			
			var oMenuActionButtons:Array = BuildMenuActionButtonList(gameController);
			var oButtonMenu:ActionButtonMenu = new ActionButtonMenu(oMenuActionButtons, "Game");
			
			var iCsaDayType:int = gameController.GetCsaDayType();
			var oCsaMenu:IMenuContent = null;
			
			var oChildTypes:Array = null;
			var oChildTabs:Array = null;
			var lShowChildTabs:Array = null;
			
			switch (iCsaDayType)
			{
				case CsaState.DAY_TYPE_SIGNUP:
					oCsaMenu = new CsaSignupMenu(_farm.owner.csaState, gameController);
					break;
				case CsaState.DAY_TYPE_STATUS:
					oCsaMenu = new CsaStatusMenu(_farm.owner.csaState, gameController);
					break;
				case CsaState.DAY_TYPE_DELIVERY:
					oCsaMenu = new CsaDeliveryMenu(_farm.owner.csaState, gameController);
					oChildTypes = [ -1, Bldg.TYPE_FARM_ROOT_CELLAR ];
					oChildTabs = [ -1, RootCellar.TAB_FOOD ];
					lShowChildTabs = _showChildTabs;
					break;
				default:
					break;			
			}
			
			var oMenu:ParentMenuFrame = new ParentMenuFrame(gameController, [ oButtonMenu, oCsaMenu, oGarbageMenu ], lShowChildTabs, House.MENU_LABEL_NAME, 2, oBtns, 0,
															oChildTypes, oChildTabs);
			
			return oMenu;
		}
		
		public override function GetPreviewGraphics():MovieClip
		{
			var oGraphics:MovieClip = new MovieClip();
			
			var oBackgroundGraphics:BldgPreview_MC = new BldgPreview_MC();
			oBackgroundGraphics.Building.text = "House";
			oBackgroundGraphics.Description.text = "Access for everyday activities and game options.";
			oGraphics.addChild(oBackgroundGraphics);
			
			return oGraphics;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
	
		private function BuildMenuActionButtonList(gameController:GameController):Array
		{
			var lButtons:Array = new Array();
			
			lButtons.push(new MenuActionButton(MenuActionButton.BTN_END_DAY, gameController));
			lButtons.push(new MenuActionButton(MenuActionButton.BTN_SAVE_GAME, gameController));
			
			if (SaveGameService.HasSaveGameData() == true)
			{
				lButtons.push(new MenuActionButton(MenuActionButton.BTN_LOAD_GAME, gameController));
			}
			
			lButtons.push(new MenuActionButton(MenuActionButton.BTN_EXIT_TO_TITLE, gameController));
			
			return lButtons;
		}
		
		//- Private Methods -//
	}
}