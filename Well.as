package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A Well Bldg in the world; it holds water
	//
	//Public Properties:
	//	Contents:Inventory { get; } = returns null since the Well has no inventory
	//
	//Public Methods:
	//	GetPreviewGraphics():MovieClip = Get a movieclip that represents a preview of the Well for display on the Main UI
	//	Paint():MovieClip = Get a movieclip that represents the Well in the world
	//-----------------------
	public class Well extends FarmBldg
	{
		// Constants //
		
		private static const MAX_AMOUNT:Array = [ 500 ];
		
		//* Constants *//
		
		
		// Public Properties //
		public function get amount():int
		{
			return _amount;
		}
		
		public function set amount(value:int):void
		{
			_amount = value;
		}
		
		public override function get bldgType():int
		{
			return Bldg.TYPE_FARM_WELL;
		}
		
		public override function get gridDepth():int
		{
			return 2;
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
		
		public function get upgradeLevel():int
		{
			return _upgradeLevel;
		}
		
		public function set upgradeLevel(value:int):void
		{
			_upgradeLevel = value;
		}
		
		//* Public Properties *//
		
		
		// Private Properties //
		private var _amount:int;
		private var _upgradeLevel:int;
		
		//* Private Properties *//
		
	
		// Initialization //
		public function Well(origin:GridLocation = null, farm:Farm = null, upgradeLevel:int = 0, amount:int = -1)
		{
			super(origin, farm);
			
			_upgradeLevel = upgradeLevel;
			
			_amount = amount;
			if (_amount == -1)
			{
				_amount = Well.MAX_AMOUNT[_upgradeLevel];
			}
		}
		
		//* Initialization *//
	
	
		// Public Methods //
		
		//---------------
		//Purpose:		Add some amount of water to the well
		//
		//Parameters:
		//	amount:int = the amount of water to add to the well
		//
		//Returns:		void
		//---------------
		public function AddWater(amount:int):void
		{
			_amount += amount;
						
			if (_amount > Well.MAX_AMOUNT[_upgradeLevel])
			{
				_amount = Well.MAX_AMOUNT[_upgradeLevel];
			}
		}
		
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
		//Returns:		a movieclip representation of this object
		//---------------
		public override function GetGraphics():MovieClip
		{
			var oGraphics:Bldg_Well_MC = new Bldg_Well_MC();
			
			return oGraphics;
		}
		
		public override function GetHitMask():MovieClip
		{
			var mcHitMask:MovieClip = new Bldg_HitMask_MC();
			mcHitMask.gotoAndStop(7);
			
			return mcHitMask;
		}
		
		public override function GetMenu(gameController:GameController):ParentMenuFrame
		{
			return null;
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
			oBackgroundGraphics.gotoAndStop(2);
			oBackgroundGraphics.Building.text = "Well";
			oBackgroundGraphics.Description.text = "Your store of water.\nRefill your watering can here.";
			oGraphics.addChild(oBackgroundGraphics);
						
			var oSliderBar:SliderBar = new SliderBar(SliderBar.SIZE_NORMAL, _amount, Well.MAX_AMOUNT[_upgradeLevel]);
			var oSliderGraphics:MovieClip = oSliderBar.Paint();
			oSliderGraphics.x = 30;
			oSliderGraphics.y = 115;
			oGraphics.addChild(oSliderGraphics);
			
			return oGraphics;
		}
		
		//* Public Methods *//
		
		
		// Protected Methods //
		
		//* Protected Methods *//
	}
}