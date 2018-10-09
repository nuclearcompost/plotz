package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A residence in a Town
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class Home extends TownBldg
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get address():Address
		{
			return _address;
		}
		
		public function set address(value:Address):void
		{
			_address = value;
		}
		
		public override function get bldgType():int
		{
			return Bldg.TYPE_TOWN_HOME;
		}
		
		public override function get gridDepth():int
		{
			return 0;
		}
		
		public override function get gridHeight():int
		{
			return 0;
		}
		
		public override function get gridWidth():int
		{
			return 0;
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
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _address:Address;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Home(origin:GridLocation = null, town:Town = null, address:Address = null)
		{
			super(origin, town);
			
			_address = address;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function GetChildMenu(gameController:GameController, startTab:int = 0):ChildMenuFrame
		{
			return null;
		}
		
		public override function GetGraphics():MovieClip
		{
			return null;
		}
		
		public override function GetMenu(gameController:GameController):ParentMenuFrame
		{
			return null;
		}
		
		public override function GetPreviewGraphics():MovieClip
		{
			return null;
		}
		
		public override function GetHitMask():MovieClip
		{
			return null;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}