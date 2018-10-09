package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	//-----------------------
	//Purpose:				The internal workings of a menu that shows the current CSA status
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CsaStatusMenu implements IMenuContent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get csaState():CsaState
		{
			return _csaState;
		}
		
		public function get gridHeight():int
		{
			var oCustomer:CsaCustomer = CsaService.GetFirstCustomerNeedingDelivery(_csaState);
			
			if (oCustomer == null)
			{
				return 4;
			}
			
			return 2;
		}
		
		public function set menuTab(value:MenuTab):void
		{
			_menuTab = value;
		}
		
		public function get menuTabDisplayName():String
		{
			return "CSA";
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _csaState:CsaState;
		private var _gameController:GameController;
		private var _menuTab:MenuTab;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CsaStatusMenu(csaState:CsaState = null, gameController:GameController = null)
		{
			_csaState = csaState;
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
			var mcMenuBody:MovieClip = new MovieClip();
			
			var oCustomer:CsaCustomer = CsaService.GetFirstCustomerNeedingDelivery(_csaState);
			
			var oStatusText:TextField = new TextField();
			
			
			if (oCustomer == null)
			{
				var oNextSignupDate:Time = _gameController.GetNextCsaSignupDate();
				
				oStatusText.appendText("You don't currently have anyone signed up for your CSA program.\n\n");
				oStatusText.appendText("The next CSA signup date is ");
				
				if (oNextSignupDate.useMonth == true)
				{
					oStatusText.appendText(Time.MONTHS_LONG[oNextSignupDate.month] + " ");
				}
				else
				{
					oStatusText.appendText(Time.SEASONS[oNextSignupDate.season] + " ");
				}
				
				oStatusText.appendText(String(oNextSignupDate.date + 1));
				oStatusText.appendText("\n\nCheck back then to get started!");
			}
			else
			{
				var oNextDeliveryDate:Time = _gameController.GetNextCsaDeliveryDate();
				var iNumCustomers:int = CsaService.GetNumCustomersNeedingDelivery(_csaState);
				
				oStatusText.appendText("You currently have " + iNumCustomers + " customers waiting for 4 products each\n");
				oStatusText.appendText("for a total of " + (iNumCustomers * 4) + " products due on "); 
				
				if (oNextDeliveryDate.useMonth == true)
				{
					oStatusText.appendText(Time.MONTHS_LONG[oNextDeliveryDate.month] + " ");
				}
				else
				{
					oStatusText.appendText(Time.SEASONS[oNextDeliveryDate.season] + " ");
				}
				
				oStatusText.appendText(String(oNextDeliveryDate.date + 1));
			}
			
			
			var oTextFormat:TextFormat = new TextFormat();
			oTextFormat.font = "Arial";
			oTextFormat.size = 20;
			oTextFormat.color = 0x6C4B1C;
			
			oStatusText.setTextFormat(oTextFormat);
			oStatusText.autoSize = TextFieldAutoSize.LEFT;			
			
			oStatusText.x = 25;
			oStatusText.y = 25;
			mcMenuBody.addChild(oStatusText);
			
			return mcMenuBody;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}