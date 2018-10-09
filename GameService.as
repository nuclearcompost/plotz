package
{
	import flash.utils.getQualifiedClassName;
	
	//-----------------------
	//Purpose:				Service logic for functionality that requires objects from across several pieces of game state
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class GameService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function GameService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function MenuActionButtonClick(actionButtonType:int, gameSession:GameSession):void
		{
			switch (actionButtonType)
			{
				case MenuActionButton.BTN_END_DAY:
					gameSession.AdvanceDay();
					break;
				case MenuActionButton.BTN_SAVE_GAME:
					gameSession.menuState.popUpMenu = new PopUpMenu(gameSession, PopUpMenu.TYPE_CONFIRM_SAVE_GAME);
					break;
				case MenuActionButton.BTN_LOAD_GAME:
					gameSession.menuState.popUpMenu = new PopUpMenu(gameSession, PopUpMenu.TYPE_CONFIRM_LOAD_GAME);
					break;
				case MenuActionButton.BTN_EXIT_TO_TITLE:
					gameSession.menuState.popUpMenu = new PopUpMenu(gameSession, PopUpMenu.TYPE_CONFIRM_SAVE_ON_EXIT);
					break;
				case MenuActionButton.BTN_EXPORT_STATS:
					break;
				case MenuActionButton.BTN_REPLAY_TUTORIAL:
					gameSession.menuState.popUpMenu = new PopUpMenu(gameSession, PopUpMenu.TYPE_CONFIRM_SAVE_FOR_TUTORIAL_REPLAY);
					break;
				default:
					break;
			}
		}
		
		// have the active player buy the item from the given inventory and deliver it, if possible
		public static function PurchaseItemFromInventory(inventory:Inventory, slot:int, gameSession:GameSession):void
		{
			var oObject:Object = inventory.GetItemAt(slot);
			
			if (oObject == null)
			{
				return;
			}
			
			if (!(oObject is IItem))
			{
				return;
			}
			
			var oItem:IItem = IItem(oObject);
			var iPrice:int = gameSession.itemPricingService.GetItemPrice(oItem);
			
			var bCanDeliver:Boolean = MenuService.CanDeliverItem(gameSession.menuState, gameSession.activePlayer, oItem);
			var bCanBuy:Boolean = EconomyService.CanBuyItem(gameSession.activePlayer, iPrice);
			
			if (bCanBuy == true && bCanDeliver == true)
			{
				var bItemBought:Boolean = EconomyService.BuyItem(gameSession.activePlayer, iPrice);
			
				if (bItemBought == true)
				{
					var oNewItem:IItem = Item.GetCopyOfItem(oItem);
					gameSession.statTracker.moneySpent += iPrice;
					gameSession.calendarStatTracker.AddEventToday(new ItemShopPurchaseEvent(getQualifiedClassName(oItem), oItem.type, iPrice, null, 1));
					
					// deliver the NEW Item
					MenuService.DeliverItem(gameSession.menuState, gameSession.activePlayer, oNewItem);
				}
			}
		}
		
		// sell the item from the given inventory and give cash back to the active player, if possible
		public static function SellItemFromInventory(inventory:Inventory, slot:int, gameSession:GameSession):void
		{
			var oObject:Object = inventory.GetItemAt(slot);
			
			if (oObject == null)
			{
				return;
			}
			
			if (!(oObject is IItem))
			{
				return;
			}
			
			var oItem:IItem = IItem(oObject);
			var iPrice:int = gameSession.itemPricingService.GetItemPrice(oItem);
			
			var bItemSold:Boolean = EconomyService.SellItem(gameSession.activePlayer, iPrice);
				
			if (bItemSold == true)
			{
				inventory.PopItemAt(slot);
				gameSession.statTracker.moneyEarned += iPrice;
				gameSession.calendarStatTracker.AddEventToday(new ItemShopSaleEvent(getQualifiedClassName(oItem), oItem.type, iPrice, null, 1));
			}
		}
		
		public static function UpdateChildMenu(activeTabBldgType:int, activeTabChildTab:int, gameSession:GameSession, gameController:GameController):void
		{
			// this gets called during parent menu initial creation b/c this whole menu initialization thing is shit
			// so kick out of this if there's no parent menu yet. this is really only meant to be called when the tab
			//  is changing from one tab to another on an already created menu.
			if (gameSession.menuState.parentMenu == null)
			{
				return;
			}
			
			var oMenuState:MenuState = gameSession.menuState;
			
			// clear out the current child menu
			oMenuState.childMenu = null;
			
			var oChildBldg:Bldg = gameSession.activePlayer.activeFarm.GetBldg(activeTabBldgType);
			
			if (oChildBldg != null)
			{
				var oChildMenu:ChildMenuFrame = oChildBldg.GetChildMenu(gameController, activeTabChildTab);
				
				if (oChildMenu != null)
				{
					oMenuState.childMenu = oChildMenu;
					oMenuState.childMenu.parentMenu = oMenuState.parentMenu;
					oMenuState.parentMenu.childMenu = oChildMenu;
				}
			}
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}