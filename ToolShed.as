package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A ToolShed Bldg in the world; it holds Tools
	//
	//Public Properties:
	//	Contents:Inventory { get; } = The toolshed's inventory contents
	//
	//Public Methods:
	//	GetPreviewGraphics():MovieClip = Get a movieclip that represents a preview of the ToolShed for display on the Main UI
	//	Paint():MovieClip = Get a movieclip that represents the ToolShed in the world
	//
	//-----------------------
	public class ToolShed extends FarmBldg
	{
		// Constants //
		
		public static const TAB_TOOL:int = 0;
		
		private static const INVENTORY_SIZE:Array = new Array(16, 24);
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get bldgType():int
		{
			return Bldg.TYPE_FARM_TOOLSHED;
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
		
		public function get tools():Inventory
		{
			return _tools;
		}
		
		public function set tools(value:Inventory):void
		{
			_tools = value;
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
		
		private var _tools:Inventory;
		private var _upgradeLevel:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function ToolShed(origin:GridLocation = null, farm:Farm = null, upgradeLevel:int = 0, tools:Inventory = null)
		{
			super(origin, farm);
			
			_upgradeLevel = upgradeLevel;

			_tools = tools;
			if (_tools == null)
			{
				_tools = new Inventory(ToolShed.INVENTORY_SIZE[ _upgradeLevel ], "Tools", [ "BagFertilizer", "Tool", "CompostBin", "Seed" ]);
			}
		}
		
		//- Initialization -//
	
	
		// Public Methods //
		
		public override function GetChildMenu(gameController:GameController, startTab:int = 0):ChildMenuFrame
		{
			var oBtns:Array = new Array();
			
			var oSellTools:SellMenu = new SellMenu(_tools, gameController);
			var oMenu:ChildMenuFrame = new ChildMenuFrame(gameController, [ oSellTools ], "Tool Shed", 2, oBtns, startTab, true);
			
			return oMenu;
		}
		
		//---------------
		//Purpose:		Return graphics that represent this object
		//
		//Parameters:
		//	none
		//
		//Returns:		a ToolShed_MC representation of this object
		//---------------
		public override function GetGraphics():MovieClip
		{
			var oGraphics:Bldg_ToolShed_MC = new Bldg_ToolShed_MC();
			
			return oGraphics;
		}
		
		public override function GetHitMask():MovieClip
		{
			var mcHitMask:MovieClip = new Bldg_HitMask_MC();
			mcHitMask.gotoAndStop(6);
			
			return mcHitMask;
		}
		
		public override function GetMenu(gameController:GameController):ParentMenuFrame
		{
			var oBtns:Array = [ MenuHeader.HEADER_BUTTON_CANCEL ];
			var oToolMenu:StorageMenu = new StorageMenu(_tools, gameController);
			
			var oMenu:ParentMenuFrame = new ParentMenuFrame(gameController, [ oToolMenu ], null, "Tool Shed", 2, oBtns);
			
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
			oBackgroundGraphics.Building.text = "Tool Shed";
			oBackgroundGraphics.Description.text = "Access to all of your tools and items.";
			oGraphics.addChild(oBackgroundGraphics);
			
			return oGraphics;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
	}
}