package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A Fence Bldg in the world; it establishes the border around farms
	//
	//Public Properties:
	//
	//Public Methods:
	//	GetPreviewGraphics():MovieClip = Get a movieclip that represents a preview of the Building for display on the Main UI
	//	Paint():MovieClip = Get a movieclip that represents the Building in the world
	//
	//-----------------------
	public class Fence extends FarmBldg
	{
		// Constants //
		
		//* Constants *//
		
		
		// Public Properties //
		public override function get bldgType():int
		{
			return Bldg.TYPE_FARM_FENCE;
		}
		
		public function get bottom():Boolean
		{
			return _bottom;
		}
		
		public function set bottom(value:Boolean):void
		{
			_bottom = value;
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
			return 0;
		}
		
		public override function get hitMaskWidth():int
		{
			return 0;
		}
		
		public function get left():Boolean
		{
			return _left;
		}
		
		public function set left(value:Boolean):void
		{
			_left = value;
		}
		
		public override function get registrationPoint():PixelLocation
		{
			return null;
		}
		
		public function get right():Boolean
		{
			return _right;
		}
		
		public function set right(value:Boolean):void
		{
			_right = value;
		}
		
		public function get top():Boolean
		{
			return _top;
		}
		
		public function set top(value:Boolean):void
		{
			_top = value;
		}
		
		//* Public Properties *//
		
		
		// Private Properties //
		
		private var _bottom:Boolean;
		private var _left:Boolean;
		private var _right:Boolean;
		private var _top:Boolean;
		
		//* Private Properties *//
		
	
		// Initialization //
		//---------------
		//Purpose:		Construct a new Fence object
		//
		//Parameters:
		//	origin:Location = the World Location of this Fence's origin
		//
		//Returns:		reference to the new object
		//---------------
		public function Fence(origin:GridLocation = null, farm:Farm = null, top:Boolean = false, bottom:Boolean = false, left:Boolean = false, right:Boolean = false)
		{
			super(origin, farm);
			
			_top = top;
			_bottom = bottom;
			_left = left;
			_right = right;
		}
		
		//* Initialization *//
	
	
		// Public Methods //
		
		public override function GetChildMenu(gameController:GameController, startTab:int = 0):ChildMenuFrame
		{
			return null;
		}
		
		//---------------
		//Purpose:		Return graphics that represent this object
		//
		//Parameters:
		//
		//Returns:		a movieClip representation of this object
		//---------------
		public override function GetGraphics():MovieClip
		{
			var mcGraphics:MovieClip = new MovieClip();
			
			if (_top == true)
			{
				var mcFence:Bldg_Fence_MC = new Bldg_Fence_MC();
				mcGraphics.addChild(mcFence);
			}
			
			if (_bottom == true)
			{
				mcFence = new Bldg_Fence_MC();
				mcFence.gotoAndStop(2);
				mcGraphics.addChild(mcFence);
			}
			
			if (_left == true)
			{
				mcFence = new Bldg_Fence_MC();
				mcFence.gotoAndStop(3);
				mcGraphics.addChild(mcFence);
			}
			
			if (_right == true)
			{
				mcFence = new Bldg_Fence_MC();
				mcFence.gotoAndStop(4);
				mcGraphics.addChild(mcFence);
			}
			
			return mcGraphics;
		}
		
		public override function GetHitMask():MovieClip
		{
			return null;
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
			oBackgroundGraphics.Building.text = "Fence";
			oBackgroundGraphics.Description.text = "The boundary of your farm.";
			oGraphics.addChild(oBackgroundGraphics);
			
			return oGraphics;
		}
		
		//* Public Methods *//
		
		
		// Protected Methods //
		
		//* Protected Methods *//
	}
}