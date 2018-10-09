package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Holds Fruit, keeping it fresher for longer than other storage places
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class RootCellar extends FarmBldg
	{
		// Constants //
		
		public static const TAB_FOOD:int = 0;
		
		private static const INVENTORY_SIZE:int = 24;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get bldgType():int
		{
			return Bldg.TYPE_FARM_ROOT_CELLAR;
		}
		
		public function get food():Inventory
		{
			return _food;
		}
		
		public function set food(value:Inventory):void
		{
			_food = value;
		}
		
		public override function get gridDepth():int
		{
			return 1;
		}
		
		public override function get gridHeight():int
		{
			return 1;
		}
		
		public override function get gridWidth():int
		{
			return 1;
		}
		
		public override function get hitMaskHeight():int
		{
			return 60;
		}
		
		public override function get hitMaskWidth():int
		{
			return 60;
		}
		
		public override function get registrationPoint():PixelLocation
		{
			var oPoint:PixelLocation = new PixelLocation(30, 45);
			
			return oPoint;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _food:Inventory;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function RootCellar(origin:GridLocation = null, farm:Farm = null, food:Inventory = null)
		{
			super(origin, farm);
			
			_food = food;
			if (_food == null)
			{
				_food = new Inventory(RootCellar.INVENTORY_SIZE, "Food", [ "Fruit" ]);
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function GetChildMenu(gameController:GameController, startTab:int = 0):ChildMenuFrame
		{
			var oBtns:Array = new Array();
			var oFoodMenu:StorageMenu = new StorageMenu(_food, gameController);
			
			var oMenu:ChildMenuFrame = new ChildMenuFrame(gameController, [ oFoodMenu ], "Root Cellar", 2, oBtns);
			
			return oMenu;
		}
		
		public override function GetGraphics():MovieClip
		{
			var oGraphics:Bldg_RootCellar_MC = new Bldg_RootCellar_MC();
			
			return oGraphics;
		}
		
		public override function GetHitMask():MovieClip
		{
			var mcHitMask:MovieClip = new Bldg_HitMask_MC();
			mcHitMask.gotoAndStop(4);
			
			return mcHitMask;
		}
		
		public override function GetMenu(gameController:GameController):ParentMenuFrame
		{
			var oBtns:Array = [ MenuHeader.HEADER_BUTTON_CANCEL ];
			var oFoodMenu:StorageMenu = new StorageMenu(_food, gameController);
			
			var oMenu:ParentMenuFrame = new ParentMenuFrame(gameController, [ oFoodMenu ], null, "Root Cellar", 2, oBtns, 0);
			
			return oMenu;
		}
		
		public override function GetPreviewGraphics():MovieClip
		{
			var oGraphics:MovieClip = new MovieClip();
			
			var oBackgroundGraphics:BldgPreview_MC = new BldgPreview_MC();
			oBackgroundGraphics.Building.text = "Root Cellar";
			oBackgroundGraphics.Description.text = "Keeps food fresh for longer.";
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