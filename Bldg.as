package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Base class for buildings
	//
	//Public Properties:
	//
	//Public Methods:
	//	
	//Extended By:
	//	FarmBldg
	//	ItemBldg
	//	TownBldg
	//-----------------------
	public class Bldg
	{
		// Constants //
		
		public static const MAX_TYPE:int = 9;
		
		public static const TYPE_FARM_HOUSE:int = 0;
		public static const TYPE_FARM_TOOLSHED:int = 1;
		public static const TYPE_TOWN_ITEM_SHOP:int = 3;
		public static const TYPE_FARM_MAILBOX:int = 4;
		public static const TYPE_FARM_WELL:int = 5;
		public static const TYPE_FARM_FENCE:int = 6;
		public static const TYPE_FARM_SALE_CART:int = 7;
		public static const TYPE_FARM_ROOT_CELLAR:int = 8;
		public static const TYPE_ITEM_COMPOST_BIN:int = 9;
		public static const TYPE_TOWN_HOME:int = 10;
		
		private static const DESCRIPTION:Array = [ "House", "Tool Shed", "", "Item Shop", "Mailbox", "Well", "Fence", "Sale Cart", "Root Cellar", "Compost Bin", "Home" ];
		
		//- Constants -//
		
		
		// Public Properties //
		
		// this property needs to be overridden by each Bldg subClass
		public function get bldgType():int
		{
			trace("Bldg get bldgType called");
			return -1;
		}
		
		// this property needs to be overridden by each Bldg subClass
		public function get gridDepth():int
		{
			trace("Bldg gridDepth getter called");
			return -1;
		}
		
		// this property needs to be overridden by each Bldg subClass
		public function get gridHeight():int
		{
			trace("Bldg get gridHeight called");
			return -1;
		}
		
		// this property needs to be overridden by each Bldg subClass
		public function get gridWidth():int
		{
			trace("Bldg get gridWidth called");
			return -1;
		}
		
		public function get hitMaskHeight():int
		{
			trace("Bldg get hitMaskHeight called");
			return -1;
		}
		
		public function get hitMaskWidth():int
		{
			trace("Bldg get hitMaskWidth called");
			return -1;
		}
		
		public function get origin():GridLocation
		{
			return _origin;
		}
		
		public function set origin(value:GridLocation):void
		{
			_origin = value;
		}
		
		// override in each child class
		public function get registrationPoint():PixelLocation
		{
			trace("Bldg registrationPoint getter called");
			return null;
		}
		
		//- Public Properties -//
		
		
		// Protected Properties //
		
		protected var _origin:GridLocation;
		
		//- Protected Properties -//
	
	
		// Initialization //
		
		//---------------
		//Purpose:		Construct a new Bldg object
		//
		//Parameters:
		//	origin:Location = the World Location of this building's origin
		//
		//Returns:		reference to the new object
		//---------------
		public function Bldg(origin:GridLocation = null)
		{
			_origin = origin;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function GetDescription(bldgType:int):String
		{
			var sDescription:String = String(Bldg.DESCRIPTION[bldgType]);
			
			return sDescription;
		}
		
		// this function needs to be overridden by each Bldg subClass
		public function GetChildMenu(gameController:GameController, startTab:int = 0):ChildMenuFrame
		{
			trace("Bldg GetChildMenu called");
			return null;
		}
		
		// this function needs to be overridden by each Bldg subClass
		public function GetMenu(gameController:GameController):ParentMenuFrame
		{
			trace("Bldg GetMenu called");
			return null;
		}
		
		// this function needs to be overridden by each Bldg subClass
		public function GetPreviewGraphics():MovieClip
		{
			trace("Bldg GetPreviewGraphics called");
			return null;
		}
		
		// this function needs to be overridden by each Bldg subClass
		public function GetGraphics():MovieClip
		{
			trace("Bldg GetGraphics called");
			return null;
		}
		
		// this function needs to be overridden by each Bldg subClass
		public function GetHitMask():MovieClip
		{
			trace("Bldg GetHitMask called");
			return null;
		}
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		//- Protected Methods -//
	}
	
}