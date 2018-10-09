package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A Mailbox in the world; it sells Goods for moneys
	//
	//Public Properties:
	//	none
	//
	//Public Methods:
	//	GetPreviewGraphics():MovieClip = Get a movieclip that represents a preview of the Building for display on the Main UI
	//	Paint():MovieClip = Get a movieclip that represents the Building in the world
	//-----------------------
	public class Mailbox extends FarmBldg
	{
		// Constants //
		
		//* Constants *//
		
		
		// Public Properties //
		public override function get bldgType():int
		{
			return Bldg.TYPE_FARM_MAILBOX;
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
			return 0;
		}
		
		public override function get hitMaskWidth():int
		{
			return 0;
		}
		
		public override function get registrationPoint():PixelLocation
		{
			return null;
		}
		
		//* Public Properties *//
		
		
		// Private Properties //
		
		//* Private Properties *//
		
	
		// Initialization //
		public function Mailbox(origin:GridLocation = null, farm:Farm = null)
		{
			super(origin, farm);
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
		//	none
		//
		//Returns:		a movieClip representation of this object
		//---------------
		public override function GetGraphics():MovieClip
		{
			var oGraphics:MovieClip = new Bldg_Mailbox_MC();
			return oGraphics;
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
			oBackgroundGraphics.Building.text = "Mailbox";
			oBackgroundGraphics.Description.text = "Drop harvested crops in here to sell them for cash.";
			oGraphics.addChild(oBackgroundGraphics);
			
			return oGraphics;
		}
		
		//* Public Methods *//
		
		
		// Protected Methods //
		
		//* Protected Methods *//
	}
}