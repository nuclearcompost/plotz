package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Holds goods ready to be sold
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class SaleCart extends FarmBldg
	{
		// Constants //
		
		public static const TAB_FOR_SALE:int = 0;
		
		private static const INVENTORY_SIZE:Array = [ 8 ];
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get bldgType():int
		{
			return Bldg.TYPE_FARM_SALE_CART;
		}
		
		public function get contents():Inventory
		{
			return _contents;
		}
		
		public function set contents(value:Inventory):void
		{
			_contents = value;
		}
		
		public override function get gridDepth():int
		{
			return 2;
		}
		
		public override function get gridHeight():int
		{
			return 2;
		}
		
		public override function get gridWidth():int
		{
			return 2;
		}
		
		public override function get hitMaskHeight():int
		{
			return 120;
		}
		
		public override function get hitMaskWidth():int
		{
			return 120;
		}
		
		public override function get registrationPoint():PixelLocation
		{
			var oPoint:PixelLocation = new PixelLocation(60, 105);
			
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
		
		public function get upgradeLevel():int
		{
			return _upgradeLevel;
		}
		
		public function set upgradeLevel(value:int):void
		{
			_upgradeLevel = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _contents:Inventory;
		private var _showChildTabs:Array;
		private var _upgradeLevel:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function SaleCart(origin:GridLocation = null, farm:Farm = null, upgradeLevel:int = 0, contents:Inventory = null, showChildTabs:Array = null)
		{
			super(origin, farm);
			
			_upgradeLevel = upgradeLevel;
			
			_contents = contents;
			if (_contents == null)
			{
				_contents = new Inventory(SaleCart.INVENTORY_SIZE[ _upgradeLevel ], "For Sale", [ "Fruit" ]);
			}
			
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
		
		public override function GetGraphics():MovieClip
		{
			var oGraphics:Bldg_SaleCart_MC = new Bldg_SaleCart_MC();
			
			return oGraphics;
		}
		
		public override function GetHitMask():MovieClip
		{
			var mcHitMask:MovieClip = new Bldg_HitMask_MC();
			mcHitMask.gotoAndStop(5);
			
			return mcHitMask;
		}
		
		public override function GetMenu(gameController:GameController):ParentMenuFrame
		{
			var oBtns:Array = [ MenuHeader.HEADER_BUTTON_CANCEL ];
			var oChildTypes:Array = [ Bldg.TYPE_FARM_ROOT_CELLAR ];
			var oChildTabs:Array = [ RootCellar.TAB_FOOD ];
			var oMarketMenu:MarketMenu = new MarketMenu(_contents, gameController);
			
			var oMenu:ParentMenuFrame = new ParentMenuFrame(gameController, [ oMarketMenu ], _showChildTabs, "Sale Cart", 2, oBtns, 0, oChildTypes, oChildTabs);
			
			return oMenu;
		}
		
		public override function GetPreviewGraphics():MovieClip
		{
			var oGraphics:MovieClip = new MovieClip();
			
			var oBackgroundGraphics:BldgPreview_MC = new BldgPreview_MC();
			oBackgroundGraphics.Building.text = "Sale Cart";
			oBackgroundGraphics.Description.text = "Sell your harvested goods here.";
			oGraphics.addChild(oBackgroundGraphics);
			
			return oGraphics;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}