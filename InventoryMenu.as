package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	//-----------------------
	//Purpose:				Base class for all menu content objects that have an inventory
	//
	//Properties:
	//	
	//Methods:
	//	
	//Extended By:
	//	BuyMenu
	//	CsaDeliveryMenu
	//	MarketMenu
	//	SellMenu
	//	StorageMenu
	//
	//-----------------------
	public class InventoryMenu implements IMenuContent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get gridHeight():int
		{
			trace("InventoryMenu gridHeight getter called");
			return -1;
		}
		
		public function get inventory():Inventory
		{
			return _inventory;
		}
		
		public function set menuTab(value:MenuTab):void
		{
			_menuTab = value;
		}
		
		public function get menuTabDisplayName():String
		{
			if (_inventory == null)
			{
				return "";
			}
			
			return _inventory.displayName;
		}
		
		//- Public Properties -//
		
		
		// Protected Properties //
		
		protected var _gameController:GameController;
		protected var _inventory:Inventory;
		protected var _menuTab:MenuTab;
		
		//- Protected Properties -//
		
	
		// Initialization //
		
		public function InventoryMenu(inventory:Inventory, gameController:GameController)
		{
			_inventory = inventory;
			_gameController = gameController;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function IsInParentMenu():Boolean
		{
			if (_menuTab == null)
			{
				return false;
			}
			
			var bIsInParentMenu:Boolean = _menuTab.IsInParentMenu();
			
			return bIsInParentMenu;
		}
		
		public function Paint():MovieClip
		{
			trace("InventoryMenu Paint method called");
			return new MovieClip();
		}
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		protected function OnMouseRollOut(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_gameController.OnMenuSlotRollOut();
		}
		
		protected function OnMouseRollOver(event:MouseEvent):void
		{
			event.stopPropagation();
			
			var oAnchor:PixelLocation = new PixelLocation(event.stageX, event.stageY);
			
			if (event.currentTarget.item is IItem)
			{
				_gameController.OnMenuSlotRollOver(IItem(event.currentTarget.item), oAnchor);
			}
		}
		
		//- Protected Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}