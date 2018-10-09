package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				An ItemShop Bldg in the world; it allows the player to buy and sell Items
	//
	//Public Properties:
	//	Contents:Inventory { get; } = The building's inventory contents
	//
	//Public Methods:
	//	GetPreviewGraphics():MovieClip = Get a movieclip that represents a preview of the Building for display on the Main UI
	//	Paint():MovieClip = Get a movieclip that represents the Building in the world
	//
	//-----------------------
	public class ItemShop extends TownBldg
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get bldgType():int
		{
			return Bldg.TYPE_TOWN_ITEM_SHOP;
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
			var oPoint:PixelLocation = new PixelLocation(90, 180);
			
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
		
		private var _items:Inventory;
		private var _showChildTabs:Array;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		Construct a new ItemShop object
		//
		//Parameters:
		//	origin:Location = the World Location of this building's origin
		//
		//Returns:		reference to the new object
		//---------------
		public function ItemShop(origin:GridLocation = null, town:Town = null, showChildTabs:Array = null)
		{
			super(origin, town);
			
			_showChildTabs = showChildTabs;
			if (_showChildTabs == null)
			{
				_showChildTabs = [ true ];
			}
		}
		
		//- Initialization -//
	
	
		// Public Methods //
		
		public override function GetChildMenu(gameController:GameController, startTab:int = 0):ChildMenuFrame
		{
			return null;
		}
		
		//---------------
		//Purpose:		Return graphics that represent this object
		//
		//Parameters:
		//	none
		//
		//Returns:		a movieClip representation of this object
		//---------------
		public override function GetGraphics():MovieClip
		{
			var oGraphics:MovieClip = new Bldg_ItemShop_MC();
			
			return oGraphics;
		}
		
		public override function GetHitMask():MovieClip
		{
			var mcHitMask:MovieClip = new Bldg_HitMask_MC();
			mcHitMask.gotoAndStop(3);
			
			return mcHitMask;
		}
		
		public override function GetMenu(gameController:GameController):ParentMenuFrame
		{
			var oBtns:Array = [ MenuHeader.HEADER_BUTTON_CANCEL ];
			var oChildTypes:Array = [ Bldg.TYPE_FARM_TOOLSHED ];
			var oChildTabs:Array = [ ToolShed.TAB_TOOL ];
			
			var oBuyMenu:BuyMenu = new BuyMenu(_items, gameController);
			
			var oMenu:ParentMenuFrame = new ParentMenuFrame(gameController, [ oBuyMenu ], _showChildTabs, "Item Shop", 2, oBtns, 0, oChildTypes, oChildTabs);
			
			return oMenu;
		}
				
		//---------------
		//Purpose:		Get a movieclip to display on the MainUI panel that represents the preview of this object
		//
		//Parameters:
		//	none
		//
		//Returns:		a movieClip representation of a preview of this object for display on the Main UI panel
		//---------------
		public override function GetPreviewGraphics():MovieClip
		{
			var oGraphics:MovieClip = new MovieClip();
			
			var oBackgroundGraphics:BldgPreview_MC = new BldgPreview_MC();
			oBackgroundGraphics.Building.text = "Item Shop";
			oBackgroundGraphics.Description.text = "Purchase all your farming needs here!";
			oGraphics.addChild(oBackgroundGraphics);
			
			return oGraphics;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		public function SetContents(season:int):void
		{
			_items = new Inventory(16, "Items", [ "Seed", "BagFertilizer", "CompostBin" ]);
			
			// add seeds for current season
			for (var p:int = 0; p < Plant.NAME.length; p++)
			{
				var iSeason:int = Plant.GetPreferredSeason(p);
				
				if (iSeason == season)
				{
					_items.AddItem(new Seed(p));
				}
			}
			
			// add seeds for all seasons
			for (p = 0; p < Plant.NAME.length; p++)
			{
				iSeason = Plant.GetPreferredSeason(p);
				
				if (iSeason == Time.SEASON_ANY)
				{
					_items.AddItem(new Seed(p));
				}
			}
			
			// add other items for all seasons
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_STEADY_GREEN));
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_RAPID_GREEN));
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_STEADY_ORANGE));
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_RAPID_ORANGE));
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_STEADY_BLUE));
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_RAPID_BLUE));
			_items.AddItem(new CompostBin());
		}
		
		// we'll be adding items all the time, which will throw the tutorial off, so use this function to provide a fixed set of items for the tutorial
		public function SetContentsForTutorial():void
		{
			_items = new Inventory(16, "Items", [ "Seed", "BagFertilizer", "CompostBin" ]);
			
			_items.AddItem(new Seed(Seed.TYPE_ASPARAGUS));
			_items.AddItem(new Seed(Seed.TYPE_LETTUCE));
			_items.AddItem(new Seed(Seed.TYPE_ONION));
			_items.AddItem(new Seed(Seed.TYPE_WILD_GRASS));
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_STEADY_GREEN));
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_RAPID_GREEN));
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_STEADY_ORANGE));
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_RAPID_ORANGE));
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_STEADY_BLUE));
			_items.AddItem(new BagFertilizer(BagFertilizer.TYPE_RAPID_BLUE));
		}
		
		//- Private Methods -//
	}
}