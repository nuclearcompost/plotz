package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	//-----------------------
	//Purpose:				The internal workings of a menu that allows the player to delivery items for their CSA
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CsaDeliveryMenu extends InventoryMenu
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get csaState():CsaState
		{
			return _csaState;
		}
		
		public override function get gridHeight():int
		{
			if (_csaState == null || _inventory == null)
			{
				return 4;
			}
			
			var oCustomer:CsaCustomer = CsaService.GetFirstCustomerNeedingDelivery(_csaState);
			
			if (oCustomer == null)
			{
				return 4;
			}
			
			return 6;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _csaState:CsaState;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CsaDeliveryMenu(csaState:CsaState, gameController:GameController)
		{
			super(csaState.deliveryInventory, gameController);
			
			_csaState = csaState;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Paint():MovieClip
		{
			var mcMenuBody:MovieClip = new MovieClip();
			
			var mcBody:Csa_DeliveryMenu_MC = new Csa_DeliveryMenu_MC();
			mcBody.x = 0;
			mcBody.y = 0;
			mcMenuBody.addChild(mcBody);
			
			var oCustomer:CsaCustomer = CsaService.GetFirstCustomerNeedingDelivery(_csaState);
			
			if (oCustomer == null)
			{
				return mcMenuBody;
			}
			
			if (_inventory == null)
			{
				return mcMenuBody;
			}
			
			mcBody.gotoAndStop(2);
			
			var iX:int = 0;
			var iY:int = mcBody.height + 10;
			
			for (var i:int = 0; i < _inventory.maxSize; i++)
			{
				mcBody.CustomerName.text = oCustomer.name;
				
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
				}
				
				// add event listeners
				mcEvent.item = oObject;
				mcEvent.addEventListener(MouseEvent.CLICK, OnSlotClick, false, 0, true);
				mcEvent.addEventListener(MouseEvent.ROLL_OUT, OnMouseRollOut, false, 0, true);
				mcEvent.addEventListener(MouseEvent.ROLL_OVER, OnMouseRollOver, false, 0, true);
				mcMenuBody.addChild(mcEvent);
				
				// update drawing position
				iX += UIManager.MENU_INV_ITEM_GRID_WIDTH * UIManager.MENU_INV_GRID_PIXEL_WIDTH;
				if (iX >= UIManager.SCREEN_PIXEL_WIDTH)
				{
					iX = 0;
					iY += UIManager.MENU_INV_ITEM_GRID_HEIGHT * UIManager.MENU_INV_GRID_PIXEL_HEIGHT;
				}
			}
			
			// deliver button
			var btnDeliver:Csa_Deliver_Btn = new Csa_Deliver_Btn();
			btnDeliver.x = iX + (btnDeliver.width / 2);
			btnDeliver.y = iY + (btnDeliver.height / 2) + 15;
			btnDeliver.addEventListener(MouseEvent.CLICK, OnDeliverButtonClick, false, 0, true);
			mcMenuBody.addChild(btnDeliver);
			
			return mcMenuBody;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function OnDeliverButtonClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			var oCustomer:CsaCustomer = CsaService.GetFirstCustomerNeedingDelivery(_csaState);
			
			_gameController.OnCsaDeliverButtonClick(_csaState, oCustomer);
		}
		
		private function OnSlotClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_gameController.OnCsaDeliveryMenuSlotClick(this, event.currentTarget.slot);
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}