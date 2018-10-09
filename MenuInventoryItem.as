package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class MenuInventoryItem extends MovieClip
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _body:MenuBody;
		private var _group:int;
		private var _menu:MenuFrame;
		private var _slot:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function MenuInventoryItem(menu:MenuFrame, body:MenuBody, group:int, slot:int)
		{
			_menu = menu;
			_body = body;
			_group = group;
			_slot = slot;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function Paint():MovieClip
		{
			var mcMenuInventoryItem:MovieClip = new MovieClip();
			var iPrice:int = -1;
			
			// menu slot graphics
			var oMenuSlotGraphics:MenuSlot_MC = new MenuSlot_MC();
			mcMenuInventoryItem.addChild(oMenuSlotGraphics);
			
			// item graphics
			var oItem:IItem = IItem(_menu.contents.GetItemAt(_slot, _group));
			
			if (oItem != null)
			{
				var oItemGraphics:MovieClip = oItem.GetGraphics();
				oItemGraphics.x = 0;
				oItemGraphics.y = 0;
				
				if (oItem is ItemBldg)
				{
					oItemGraphics.x = (UIManager.MENU_INV_ITEM_GRID_WIDTH / 2) * UIManager.GRID_PIXEL_WIDTH;
					oItemGraphics.y = (UIManager.MENU_INV_ITEM_GRID_HEIGHT / 2) * UIManager.GRID_PIXEL_HEIGHT;
				}
				
				mcMenuInventoryItem.addChild(oItemGraphics);
				iPrice = _menu.GetItemPrice(oItem);
			}
			
			// price graphics
			if (_body.type == MenuBody.TYPE_BUY || _body.type == MenuBody.TYPE_SELL)
			{
				// price
				if (oItem != null && iPrice > 0)
				{
					var oPriceGraphics:MenuPrice_MC = new MenuPrice_MC();
					oPriceGraphics.y = UIManager.MENU_INV_ITEM_GRID_HEIGHT * UIManager.GRID_PIXEL_HEIGHT;
					oPriceGraphics.gotoAndStop(_body.type);
					mcMenuInventoryItem.addChild(oPriceGraphics);
					oPriceGraphics.Price.text = "$" + String(iPrice);
				}
			}
			else if (_body.type == MenuBody.TYPE_MARKET)
			{
				if (oItem != null && iPrice > 0)
				{
					// price
					var mcPrice:MenuPrice_MC = new MenuPrice_MC();
					mcPrice.y = UIManager.MENU_INV_ITEM_GRID_HEIGHT * UIManager.GRID_PIXEL_HEIGHT;
					mcPrice.gotoAndStop(_body.type);
					mcMenuInventoryItem.addChild(mcPrice);
					mcPrice.Price.text = "$" + String(iPrice);
					
					// price adjustment buttons
					var mcUpArrow:MenuPriceArrow_MC = new MenuPriceArrow_MC();
					mcUpArrow.y = UIManager.MENU_INV_ITEM_GRID_HEIGHT * UIManager.GRID_PIXEL_HEIGHT;
					mcUpArrow.addEventListener(MouseEvent.CLICK, OnPriceArrowUpClick, false, 0, true);
					mcMenuInventoryItem.addChild(mcUpArrow);
					
					var mcDownArrow:MenuPriceArrow_MC = new MenuPriceArrow_MC();
					mcDownArrow.y = UIManager.MENU_INV_ITEM_GRID_HEIGHT * UIManager.GRID_PIXEL_HEIGHT;
					mcDownArrow.gotoAndStop(2);
					mcDownArrow.addEventListener(MouseEvent.CLICK, OnPriceArrowDownClick, false, 0, true);
					mcMenuInventoryItem.addChild(mcDownArrow);
				}
			}
			
			mcMenuInventoryItem.addEventListener(MouseEvent.CLICK, OnMenuSlotClick, false, 0, true);
			mcMenuInventoryItem.addEventListener(MouseEvent.ROLL_OVER, OnMenuSlotRollOver, false, 0, true);
			mcMenuInventoryItem.addEventListener(MouseEvent.ROLL_OUT, OnMenuSlotRollOut, false, 0, true);
			
			return mcMenuInventoryItem;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		/// Event Listeners ///
		
		private function OnMenuSlotClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_menu.OnMenuSlotClick(_group, _slot);
			_menu.RepaintCurrentViewForGame();
		}
		
		private function OnMenuSlotRollOut(event:MouseEvent):void
		{
			_menu.OnMenuSlotRollOut();
		}
		
		private function OnMenuSlotRollOver(event:MouseEvent):void
		{
			_menu.OnMenuSlotRollOver(IItem(_menu.contents.GetItemAt(_slot, _group)));
		}
		
		private function OnPriceArrowUpClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_menu.OnPriceArrowUpClick(_slot, _group);
		}
		
		private function OnPriceArrowDownClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_menu.OnPriceArrowDownClick(_slot, _group);
		}
		
		///- Event Listeners -///
		
		//- Private Methods -//
	}
}