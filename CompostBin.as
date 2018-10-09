package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Decomposes organic matter into compost over time
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CompostBin extends ItemBldg
	{
		// Constants //
		
		public static const TAB_COMPOST:int = 0;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get bldgType():int
		{
			return Bldg.TYPE_ITEM_COMPOST_BIN;
		}
		
		public function get compost():Inventory
		{
			return _compost;
		}
		
		public function set compost(value:Inventory):void
		{
			_compost = value;
		}
		
		public override function get gridDepth():int
		{
			return 0;
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
			return 30;
		}
		
		public override function get hitMaskWidth():int
		{
			return 30;
		}
		
		public override function get name():String
		{
			return "Compost Bin";
		}
		
		public override function get registrationPoint():PixelLocation
		{
			var oPoint:PixelLocation = new PixelLocation(15, 15);
			
			return oPoint;
		}
		
		public override function get type():int
		{
			return 0;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _compost:Inventory;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CompostBin(origin:GridLocation = null, priceModifier:int = -1, compost:Inventory = null)
		{
			super(0, origin, priceModifier);
			
			_compost = compost;
			if (_compost == null)
			{
				_compost = new Inventory(16, "Compost", [ "Fruit", "PlantScrap", "Compost" ]);
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
			var mcItemBldg:MovieClip = new Bldg_Compost_Bin_MC();
			
			return mcItemBldg;
		}
		
		public override function GetHitMask():MovieClip
		{
			var mcHitMask:MovieClip = new Bldg_HitMask_MC();
			mcHitMask.gotoAndStop(1);
			
			return mcHitMask;
		}
		
		public override function GetItemGraphics():MovieClip
		{
			var mcItem:MovieClip = new Item_CompostBin_MC();
			
			return mcItem;
		}
		
		public override function GetMenu(gameController:GameController):ParentMenuFrame
		{
			var oBtns:Array = [ MenuHeader.HEADER_BUTTON_CANCEL ];
			var oCompostMenu:StorageMenu = new StorageMenu(_compost, gameController);
			
			var oMenu:ParentMenuFrame = new ParentMenuFrame(gameController, [ oCompostMenu ], null, "Compost Bin", 2, oBtns);
			
			return oMenu;
		}
		
		public override function GetPreviewGraphics():MovieClip
		{
			var mcPreview:MovieClip = new MovieClip();
			
			var mcBackground:BldgPreview_MC = new BldgPreview_MC();
			mcBackground.Building.text = "Compost Bin";
			mcBackground.Description.text = "Composts plant material into fertilizer.";
			mcPreview.addChild(mcBackground);
			
			return mcPreview;
		}
		
		public override function GetPrice():int
		{
			return 200;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}