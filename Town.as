package
{
	//-----------------------
	//Purpose:				A group of buildings acting as one economic area
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class Town extends GridArea
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get bldgs():Array
		{
			return _bldgs;
		}
		
		public function set bldgs(value:Array):void
		{
			_bldgs = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get world():World
		{
			return _world;
		}
		
		public function set world(value:World):void
		{
			_world = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _bldgs:Array;
		private var _name:String;
		private var _world:World;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Town(name:String = "", world:World = null, top:int = 0, bottom:int = 0, left:int = 0, right:int = 0, bldgs:Array = null)
		{
			super(top, bottom, left, right);
			
			_name = name;
			_world = world;
			
			_bldgs = bldgs;
			if (_bldgs == null)
			{
				_bldgs = new Array();
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function AddBldg(bldg:TownBldg):void
		{
			_bldgs.push(bldg);
			
			if (_world != null)
			{
				_world.AddBldg(bldg);
			}
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			lResults[lResults.length] = TestAddBldg();
			lResults[lResults.length] = TestAddBldgToWorld();
			return lResults;
		}
		
		public static function TestAddBldg():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Town", "TestAddBldg");
			var oTown:Town = new Town("HappyTown", null, 0, 0, 0, 0);
			var oBldg:ItemShop = new ItemShop(new GridLocation(0, 0), oTown);
			oTown.AddBldg(oBldg);
			
			oResult.expected = "1";
			oResult.actual = String(oTown.bldgs.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function TestAddBldgToWorld():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Town", "TestAddBldgToWorld");
			var oWorld:World = new World(5, 6);
			var oTown:Town = new Town("HappyTown", oWorld, 5, 7, 2, 4);
			var oBldg:ItemShop = new ItemShop(new GridLocation(2, 7), oTown);
			oTown.AddBldg(oBldg);
			
			var oTile:Tile = Tile(oWorld.tiles[2][7]);
			oResult.TestNotNull(oTile.leftBldgs[0]);
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}