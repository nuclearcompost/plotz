package
{
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	//-----------------------
	//Purpose:				Handle events on the game level and act as an event root for other game levels
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class GameController
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _gameRoot:GameRoot;
		private var _gameSession:GameSession;
		private var _uiManager:UIManager;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function GameController(gameRoot:GameRoot = null, gameSession:GameSession = null, uiManager:UIManager = null)
		{
			_gameRoot = gameRoot;
			_gameSession = gameSession;
			_uiManager = uiManager;
		}
		
		//- Initialization -//
		
		
		// Public Methods //
		
		public function ClosePopUpMenu():void
		{
			_gameSession.menuState.popUpMenu = null;
			
			RepaintAll();
		}
		
		public function GetCsaDayType():int
		{
			var iDayType:int = CsaService.GetCsaDayType(_gameSession.time);
			
			return iDayType;
		}
		
		// Not the biggest fan of having this method here since it feels like more of a service method than a controller call. But the only alternative
		//  I can come up with right now is to do something like passing an instance of itemPricingService into the IMenuContent. That would require
		//  passing itemPricingService to all GetMenu and GetChildMenu methods for all buildings - including the ones that DON'T need any item pricing,
		//  which I feel like sucks more than having this method here...
		public function GetItemPrice(item:IItem):int
		{
			var iPrice:int = _gameSession.itemPricingService.GetItemPrice(item);
			
			return iPrice;
		}
		
		public function GetNextCsaDeliveryDate():Time
		{
			var iDeliveryDate:Time = CsaService.GetNextDeliveryDate(_gameSession.time);
			
			return iDeliveryDate;
		}
		
		public function GetNextCsaSignupDate():Time
		{
			var iSignupDate:Time = CsaService.GetNextSignupDate(_gameSession.time);
			
			return iSignupDate;
		}
		
		public function OnBuyMenuSlotClick(buyMenu:BuyMenu, slot:int):void
		{
			var bStop:Boolean = StopMenuClickForTutorial(buyMenu, slot);
			
			if (bStop == true)
			{
				return;
			}
			
			if (!(buyMenu is InventoryMenu))
			{
				return;
			}
			
			var oInventoryMenu:InventoryMenu = InventoryMenu(buyMenu);
			
			var oInventory:Inventory = oInventoryMenu.inventory;
			
			GameService.PurchaseItemFromInventory(oInventory, slot, _gameSession);
			
			RepaintAll();
		}
		
		public function OnClickCloseMenuHeaderButton(event:MouseEvent):void
		{
			event.stopPropagation();
			
			if (TutorialService.IsValidCloseMenuHeaderButtonClick(_gameSession.tutorialStep) == false)
			{
				return;
			}
			
			if (TutorialService.IsTutorialActive(_gameSession.tutorialStep) == true)
			{
				_gameSession.tutorialStep++;
			}
			
			MenuService.CloseParentAndChildMenus(_gameSession.menuState);
			
			RepaintAll();
		}
		
		public function OnClickCollapseChildMenuHeaderButton(event:MouseEvent):void
		{
			event.stopPropagation();
			
			MenuService.ToggleChildMenu(_gameSession.menuState);
			
			RepaintAll();
		}
		
		
		public function OnCsaDeliverButtonClick(csaState:CsaState, csaCustomer:CsaCustomer):void
		{
			CsaService.DeliverItems(csaState, csaCustomer);
			
			var bAddDeliveryPayment:Boolean = CsaService.ShouldGetDeliveryPayment(csaCustomer);
			
			if (bAddDeliveryPayment == true)
			{
				_gameSession.activePlayer.cash += CsaService.GetHalfPaymentAmount(_gameSession.time.season);
			}
			
			_gameSession.menuState.parentMenu.tabStrip.UpdateGridHeight();
			
			RepaintAll();
		}
		
		public function OnCsaDeliveryMenuSlotClick(csaDeliveryMenu:CsaDeliveryMenu, slot):void
		{
			MenuService.SwapItem(csaDeliveryMenu, _gameSession.activePlayer, slot);
			
			RepaintAll();
		}
		
		public function OnFooterLocationClick(index:int):void
		{
			var oFooterButton:FooterButton = FooterService.GetFooterButtonAtIndex(_gameSession.footer, index);
			
			var iActiveToolType:int = -1;
			if (_gameSession.activePlayer.activeItem is Tool)
			{
				iActiveToolType = Tool(_gameSession.activePlayer.activeItem).type;
			}
			
			if (oFooterButton != null)
			{
				switch (oFooterButton.type)
				{
					case FooterButton.TYPE_WATERING_CAN:
					case FooterButton.TYPE_SICKLE:
					case FooterButton.TYPE_HOE:
						var iToolType:int = FooterService.GetToolTypeForFooterButtonType(oFooterButton.type);
						if (iActiveToolType == iToolType)
						{
							PlayerService.DropActiveItem(_gameSession.activePlayer);
						}
						else
						{
							FooterService.ActivateToolForPlayer(_gameSession.footer, index, _gameSession.activePlayer);
						}
						break;
					case FooterButton.TYPE_MAGNIFYING_GLASS:
						FooterService.ToggleShowPlants(_gameSession.menuState);
						break;
					case FooterButton.TYPE_CALENDAR:
						FooterService.ToggleCalendarMenu(_gameSession.menuState, _gameSession.calendarState, this);
						break;
					default:
						break;
				}
			}
			
			RepaintAll();
		}
		
		public function OnMarketMenuSlotClick(marketMenu:MarketMenu, slot:int):void
		{
			var bStop:Boolean = StopMenuClickForTutorial(marketMenu, slot);
			
			if (bStop == true)
			{
				return;
			}
			
			MenuService.SwapItem(marketMenu, _gameSession.activePlayer, slot);
			
			RepaintAll();
		}
		
		public function OnMenuActionButtonClick(type:int):void
		{
			if (TutorialService.IsValidMenuActionButtonClickForTutorial(_gameSession.tutorialStep, type) == false)
			{
				return;
			}
			
			if (TutorialService.IsTutorialActive(_gameSession.tutorialStep) == true)
			{
				_gameSession.tutorialStep++;
			}
			
			GameService.MenuActionButtonClick(type, _gameSession);
			
			RepaintAll();
		}
		
		public function OnMenuSlotRollOut():void
		{
			_gameSession.mouseOverUIPanel.menuPreviewItem = null;
			
			_uiManager.RepaintMouseOverUI();
		}
		
		public function OnMenuSlotRollOver(item:IItem, anchor:PixelLocation):void
		{
			_gameSession.mouseOverUIPanel.menuPreviewItem = item;
			_gameSession.mouseOverUIPanel.menuItemAnchor = anchor;
			
			_uiManager.RepaintMouseOverUI();
		}
		
		public function OnPriceArrowUpClick(inventory:Inventory, slot:int):void
		{
			MenuService.IncrementPriceModifier(inventory, slot);
			
			_uiManager.RepaintMenu();
		}
		
		public function OnPriceArrowDownClick(inventory:Inventory, slot:int):void
		{
			MenuService.DecrementPriceModifier(inventory, slot);
			
			_uiManager.RepaintMenu();
		}
		
		public function OnSellMenuSlotClick(sellMenu:SellMenu, slot:int):void
		{
			var bStop:Boolean = StopMenuClickForTutorial(sellMenu, slot);
			
			if (bStop == true)
			{
				return;
			}
			
			if (!(sellMenu is InventoryMenu))
			{
				return;
			}
			
			var oInventoryMenu:InventoryMenu = InventoryMenu(sellMenu);
			
			var oInventory:Inventory = oInventoryMenu.inventory;
			
			GameService.SellItemFromInventory(oInventory, slot, _gameSession);
			
			RepaintAll();
		}
		
		public function OnStorageMenuSlotClick(storageMenu:StorageMenu, slot:int):void
		{
			var bStop:Boolean = StopMenuClickForTutorial(storageMenu, slot);
			
			if (bStop == true)
			{
				return;
			}
			
			MenuService.SwapItem(storageMenu, _gameSession.activePlayer, slot);
			
			RepaintAll();
		}
		
		public function RepaintAll():void
		{
			if (_uiManager == null)
			{
				return;
			}
			
			_uiManager.RepaintAll();
		}
		
		public function RepaintMenu():void
		{
			if (_uiManager == null)
			{
				return;
			}
			
			_uiManager.RepaintMenu();
		}
		
		public function UpdateChildMenu(activeTabBldgType:int, activeTabChildTab:int):void
		{
			GameService.UpdateChildMenu(activeTabBldgType, activeTabChildTab, _gameSession, this);
			
			RepaintAll();
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function StopMenuClickForTutorial(menuContent:IMenuContent, slot:int):Boolean
		{
			if (_gameSession.tutorialStep > -1)
			{
				var bIsValidSlot:Boolean = TutorialService.IsValidMenuSlotClickForTutorial(_gameSession.tutorialStep, menuContent, slot);
				
				if (bIsValidSlot)
				{
					_gameSession.tutorialStep++;
				}
				else
				{
					return true;
				}
			}
			
			return false;
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}