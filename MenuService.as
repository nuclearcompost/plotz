package
{
	//-----------------------
	//Purpose:				Service logic for menus
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class MenuService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function MenuService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function CanDeliverItem(menuState:MenuState, player:Player, item:IItem):Boolean
		{
			if (menuState == null)
			{
				return false;
			}
			
			if (player == null)
			{
				return false;
			}
			
			if (item == null)
			{
				return false;
			}
			
			if (menuState.parentMenu == null)
			{
				return false;
			}
			
			var oParentMenu:ParentMenuFrame = menuState.parentMenu;
			
			if (menuState.childMenu == null)
			{
				return false;
			}
			
			if (oParentMenu.IsChildCollapsed() == true && player.activeItem == null)
			{
				return true;
			}
			
			var oChildMenu:ChildMenuFrame = menuState.childMenu;
			
			if (oChildMenu == null || oChildMenu.tabStrip == null)
			{
				return false;
			}
			
			var oMenuContent:IMenuContent = oChildMenu.tabStrip.GetActiveTabContent();
			
			if (!(oMenuContent is InventoryMenu))
			{
				return false;
			}
			
			var oInventoryMenu:InventoryMenu = InventoryMenu(oMenuContent);
			
			if (oParentMenu.IsChildCollapsed() == false && oInventoryMenu.inventory.CanAddItem(item) == true)
			{
				return true;
			}
			
			return false;
		}
		
		public static function CloseParentAndChildMenus(menuState:MenuState):void
		{
			menuState.parentMenu = null;
			menuState.parentMenuSource = null;
			menuState.childMenu = null;
		}
		
		public static function ClosePopUpMenu(menuState:MenuState):void
		{
			menuState.popUpMenu = null;
		}
		
		public static function DecrementPriceModifier(inventory:Inventory, slot:int):void
		{
			if (inventory == null)
			{
				return;
			}
			
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
			
			if (oItem.priceModifier > ItemPricingService.PRICE_MOD_LOWEST)
			{
				oItem.priceModifier--;
			}
		}
		
		public static function DeliverItem(menuState:MenuState, player:Player, item:IItem):void
		{
			if (menuState == null)
			{
				return;
			}
			
			if (player == null)
			{
				return;
			}
			
			if (item == null)
			{
				return;
			}
			
			if (menuState.parentMenu == null)
			{
				return;
			}
			
			var oParentMenu:ParentMenuFrame = menuState.parentMenu;
			
			if (oParentMenu.IsChildCollapsed() == true && player.activeItem == null)
			{
				player.activeItem = item;
				
				return;
			}
			
			var oChildMenu:ChildMenuFrame = menuState.childMenu;
			
			if (oChildMenu == null || oChildMenu.tabStrip == null)
			{
				return;
			}
			
			var oMenuContent:IMenuContent = oChildMenu.tabStrip.GetActiveTabContent();
			
			if (!(oMenuContent is InventoryMenu))
			{
				return;
			}
			
			var oInventoryMenu:InventoryMenu = InventoryMenu(oMenuContent);
			
			if (oParentMenu.IsChildCollapsed() == false && oInventoryMenu.inventory.CanAddItem(item) == true)
			{
				oInventoryMenu.inventory.AddItem(item);
			}
		}
		
		public static function IncrementPriceModifier(inventory:Inventory, slot:int):void
		{
			if (inventory == null)
			{
				return;
			}
			
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
			
			if (oItem.priceModifier < ItemPricingService.PRICE_MOD_HIGHEST)
			{
				oItem.priceModifier++;
			}
		}
		
		public static function SwapItem(menu:InventoryMenu, player:Player, slot:int):void
		{
			// confirm we can drop off the item the player is holding, if any
			var bCanDropItem:Boolean = true;
			var oInventory:Inventory = menu.inventory;
			
			if (player.activeItem != null)
			{
				bCanDropItem = oInventory.CanAddItem(player.activeItem);
			}
			
			if (bCanDropItem == false)
			{
				return;
			}
			
			// pop the current item, if any
			var oPopItem:IItem = IItem(oInventory.PopItemAt(slot));
			
			// place the item the player is holding, if any
			oInventory.AddItemAt(player.activeItem, slot);
			
			// give the popped item to the player
			player.activeItem = oPopItem;
		}
		
		public static function ToggleChildMenu(menuState:MenuState):void
		{
			if (menuState == null || menuState.parentMenu == null)
			{
				return;
			}
			
			menuState.parentMenu.ToggleChildMenu();
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}