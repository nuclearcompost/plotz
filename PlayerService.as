package
{
	//-----------------------
	//Purpose:				Service logic for the Player
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class PlayerService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function PlayerService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function ClearActiveItem(player:Player):void
		{
			if (player == null)
			{
				return;
			}
			
			player.activeItem = null;
		}
		
		// returns true if able to drop the current active item; otherwise false
		public static function DropActiveItem(player:Player):Boolean
		{
			if (player == null)
			{
				return false;
			}
			
			if (player.activeItem == null)
			{
				return true;
			}
			
			var bCanDropItem:Boolean = FarmService.DropItemOnFarm(player.activeFarm, player.activeItem);
			
			if (bCanDropItem == true)
			{
				player.activeItem = null;
			}
			
			return bCanDropItem;
		}
		
		// Drop the current active item, if any.  Then set the given item to the active item.
		public static function SetActiveItem(player:Player, item:Object):Boolean
		{
			if (player == null)
			{
				return false;
			}
			
			var bCanDropItem:Boolean = PlayerService.DropActiveItem(player);
			
			if (bCanDropItem == true)
			{
				player.activeItem = item;
				return true;
			}
			
			return false;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(PlayerService.ClearActiveItemFalseIfNoPlayer());
			lResults.push(PlayerService.ClearActiveItemClearsItem());
			
			lResults.push(PlayerService.DropActiveItemFalseIfNoPlayer());
			lResults.push(PlayerService.DropActiveItemTrueIfNoItem());
			lResults.push(PlayerService.DropActiveItemFalseIfCantDropItem());
			lResults.push(PlayerService.DropActiveItemTrueIfCanDropItem());
			lResults.push(PlayerService.DropActiveItemClearsActiveItemIfTrue());
			
			lResults.push(PlayerService.SetActiveItemFalseIfNoPlayer());
			lResults.push(PlayerService.SetActiveItemFalse());
			lResults.push(PlayerService.SetActiveItemTrue());
			
			return lResults;
		}
		
		private static function ClearActiveItemFalseIfNoPlayer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlayerService", "ClearActiveItemFalseIfNoPlayer");
			
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			try
			{
				PlayerService.ClearActiveItem(null);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ClearActiveItemClearsItem():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlayerService", "ClearActiveItemClearsItem");
			
			var oPlayer:Player = new Player();
			oPlayer.activeItem = new Plant(Plant.TYPE_ALFALFA);
			
			PlayerService.ClearActiveItem(oPlayer);
			
			oResult.TestNull(oPlayer.activeItem);
			
			return oResult;
		}
		
		private static function DropActiveItemFalseIfNoPlayer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlayerService", "DropActiveItemFalseIfNoPlayer");
			
			oResult.expected = "false";
			oResult.actual = String(PlayerService.DropActiveItem(null));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropActiveItemTrueIfNoItem():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlayerService", "DropActiveItemTrueIfNoItem");
			var oPlayer:Player = new Player();
			
			oResult.expected = "true";
			oResult.actual = String(PlayerService.DropActiveItem(oPlayer));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropActiveItemFalseIfCantDropItem():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlayerService", "DropActiveItemFalseIfCantDropItem");
			var oPlayer:Player = new Player();
			oPlayer.activeItem = new Player();
			
			oResult.expected = "false";
			oResult.actual = String(PlayerService.DropActiveItem(oPlayer));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropActiveItemTrueIfCanDropItem():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlayerService", "DropActiveItemTrueIfCanDropItem");
			var oPlayer:Player = new Player();
			oPlayer.activeItem = new Seed(Seed.TYPE_ASPARAGUS);
			oPlayer.activeFarm = FarmService.CreateBasicFarm(oPlayer, null, 0, 0, 0, 0);
			
			oResult.expected = "true";
			oResult.actual = String(PlayerService.DropActiveItem(oPlayer));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DropActiveItemClearsActiveItemIfTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlayerService", "DropActiveItemClearsActiveItemIfTrue");
			var oPlayer:Player = new Player();
			oPlayer.activeItem = new Seed(Seed.TYPE_ASPARAGUS);
			oPlayer.activeFarm = FarmService.CreateBasicFarm(oPlayer, null, 0, 0, 0, 0);
			
			PlayerService.DropActiveItem(oPlayer);
			oResult.TestNull(oPlayer.activeItem);
			
			return oResult;
		}
		
		private static function SetActiveItemFalseIfNoPlayer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlayerService", "SetActiveItemFalseIfNoPlayer");
			var oPlayer:Player = null;
			
			oResult.expected = "false";
			oResult.actual = String(PlayerService.SetActiveItem(oPlayer, null));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function SetActiveItemFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlayerService", "SetActiveItemFalse");
			var oPlayer:Player = new Player();
			oPlayer.activeItem = new Fruit(Fruit.TYPE_ALFALFA);
			
			oResult.expected = "false";
			oResult.actual = String(PlayerService.SetActiveItem(oPlayer, new Fruit(Fruit.TYPE_PUMPKIN)));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function SetActiveItemTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlayerService", "SetActiveItemTrue");
			var oPlayer:Player = new Player();
			oPlayer.activeItem = new Fruit(Fruit.TYPE_ALFALFA);
			oPlayer.activeFarm = FarmService.CreateBasicFarm(oPlayer, null, 0, 0, 0, 0);
			
			oResult.expected = "true";
			oResult.actual = String(PlayerService.SetActiveItem(oPlayer, new Fruit(Fruit.TYPE_PUMPKIN)));
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}