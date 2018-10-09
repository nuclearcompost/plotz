package
{
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class Player
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get activeFarm():Farm
		{
			return _activeFarm;
		}
		
		public function set activeFarm(value:Farm):void
		{
			_activeFarm = value;
		}
		
		public function get activeItem():Object
		{
			return _activeItem;
		}
		
		public function set activeItem(value:Object):void
		{
			_activeItem = value;
		}
		
		public function get cash():int
		{
			return _cash;
		}
		
		public function set cash(value:int):void
		{
			_cash = value;
		}
		
		public function get csaState():CsaState
		{
			return _csaState;
		}
		
		public function set csaState(value:CsaState):void
		{
			_csaState = value;
		}
		
		public function get farms():Array
		{
			return _farms;
		}
		
		public function set farms(value:Array):void
		{
			_farms = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _activeFarm:Farm;
		private var _activeItem:Object;  // replaces mouseLoad
		private var _cash:int;
		private var _csaState:CsaState;
		private var _farms:Array;
		private var _name:String;
		
		// HumanPlayer:
		// - menuState = struct of which menus, including pop-ups are open now
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Player(name:String = "", cash:int = 0, activeFarm:Farm = null, activeItem:Object = null, farms:Array = null, csaState:CsaState = null)
		{
			_name = name;
			_cash = cash;
			_activeFarm = activeFarm;
			_activeItem = activeItem;
			
			_farms = farms;
			if (_farms == null)
			{
				_farms = new Array();
			}
			
			_csaState = csaState;
			if (_csaState == null)
			{
				_csaState = new CsaState();
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function AddFarm(farm:Farm):void
		{
			_farms[_farms.length] = farm;
			
			if (_farms.length == 1)
			{
				_activeFarm = _farms[0];
			}
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			lResults[lResults.length] = Player.TestAddFarm();
			lResults[lResults.length] = Player.FirstFarmAddedIsActive();
			
			return lResults;
		}
		
		public static function TestAddFarm():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Player", "TestAddFarm");
			
			var oPlayer:Player = new Player();
			var oFarm:Farm = new Farm("HappyFarm", oPlayer, null, 0, 0, 0, 0);
			oPlayer.AddFarm(oFarm);
			
			oResult.expected = "1";
			oResult.actual = String(oPlayer.farms.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function FirstFarmAddedIsActive():UnitTestResult
		{
			var oNotNullResult:UnitTestResult = new UnitTestResult("Player", "FirstFarmAddedIsActive - Not Null");
			var oResult:UnitTestResult = new UnitTestResult("Player", "FirstFarmAddedIsActive - Correct Active Farm");
			
			var oPlayer:Player = new Player();
			var oFarm:Farm = new Farm("HappyFarm", oPlayer, null, 0, 0, 0, 0);
			oPlayer.AddFarm(oFarm);
			
			oNotNullResult.TestNotNull(oPlayer.activeFarm);
			
			if (oNotNullResult.status == UnitTestResult.STATUS_PASS)
			{
				oResult.expected = "HappyFarm";
				oResult.actual = oPlayer.activeFarm.name;
				oResult.TestEquals();
			}
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}