package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	//-----------------------
	//Purpose:				The internal workings of a menu that can hold items the player can sell
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class SellMenu extends InventoryMenu
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get gridHeight():int
		{
			if (_inventory == null)
			{
				return 1;
			}
			
			var iNumRows:int = _inventory.maxSize / UIManager.MENU_INV_ITEMS_PER_ROW;
			var iGridHeight:int = iNumRows * (UIManager.MENU_INV_ITEM_GRID_HEIGHT + 1);
			
			return iGridHeight;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function SellMenu(inventory:Inventory, gameController:GameController)
		{
			super(inventory, gameController);
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Paint():MovieClip
		{
			var mcMenuBody:MovieClip = new MovieClip();
			
			if (_inventory == null)
			{
				return mcMenuBody;
			}
			
			var iX:int = 0;
			var iY:int = 0;
			
			for (var i:int = 0; i < _inventory.maxSize; i++)
			{
				// event graphics
				var mcEvent:MovieClip = new MovieClip();
				mcEvent.slot = i;
				
				// menu slot graphics
				var mcMenuSlot:MenuSlot_MC = new MenuSlot_MC();
				mcMenuSlot.x = iX;
				mcMenuSlot.y = iY;
				mcEvent.addChild(mcMenuSlot);
				
				// item graphics
				var oObject:Object = _inventory.GetItemAt(i);
				
				if (oObject is IItem && oObject != null)
				{
					var oItem:IItem = IItem(oObject);
				
					var mcItem:MovieClip = oItem.GetItemGraphics();
					mcItem.x = iX;
					mcItem.y = iY;
					
					mcEvent.addChild(mcItem);
					
					// price graphics
					var iPrice:int = _gameController.GetItemPrice(oItem);
					
					if (oItem != null && iPrice > 0)
					{
						var mcPrice:MenuPrice_MC = new MenuPrice_MC();
						mcPrice.x = iX;
						mcPrice.y = iY + (UIManager.MENU_INV_ITEM_GRID_HEIGHT * UIManager.GRID_PIXEL_HEIGHT);
						mcPrice.gotoAndStop(2);
						mcPrice.Price.text = "$" + String(iPrice);
						
						mcMenuBody.addChild(mcPrice);
					}
				}
				
				// attach event listeners
				mcEvent.item = oObject;
				mcEvent.addEventListener(MouseEvent.CLICK, OnSlotClick, false, 0, true);
				mcEvent.addEventListener(MouseEvent.ROLL_OUT, OnMouseRollOut, false, 0, true);
				mcEvent.addEventListener(MouseEvent.ROLL_OVER, OnMouseRollOver, false, 0, true);
				mcMenuBody.addChild(mcEvent);
				
				// update drawing position
				iX += UIManager.MENU_INV_ITEM_GRID_WIDTH * UIManager.GRID_PIXEL_WIDTH;
				if (iX >= UIManager.SCREEN_PIXEL_WIDTH)
				{
					iX = 0;
					iY += (UIManager.MENU_INV_ITEM_GRID_HEIGHT + 1) * UIManager.GRID_PIXEL_HEIGHT;
				}
			}
			
			return mcMenuBody;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function OnSlotClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_gameController.OnSellMenuSlotClick(this, event.currentTarget.slot);
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}