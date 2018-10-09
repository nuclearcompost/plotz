package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	//-----------------------
	//Purpose:				The internal workings of a menu that allows the player to signup customers for the CSA program
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CsaSignupMenu implements IMenuContent
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
			var iGridHeight = 5;
			
			if (_csaState != null && _csaState.customers != null)
			{
				iGridHeight += (1 * _csaState.customers.length);
				
				var iExtra:int = Math.floor(_csaState.customers.length / 4);
				
				iGridHeight += iExtra;
			}
			
			return iGridHeight;
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
		
		public function CsaSignupMenu(csaState:CsaState = null, gameController:GameController = null)
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
			var mcMenu:MovieClip = new MovieClip();
			
			var oTextFormat:TextFormat = new TextFormat();
			oTextFormat.font = "Arial";
			oTextFormat.size = 20;
			oTextFormat.color = 0x6C4B1C;
			
			var oIntroField:TextField = new TextField();
			oIntroField.autoSize = TextFieldAutoSize.LEFT;
			oIntroField.appendText("Welcome to your Community Supported Agriculture Sign Up!\n\n");
			oIntroField.appendText("Below is a list of customers who would like to support your farm by\n");
			oIntroField.appendText("offering you some money up front in exchange for a scheduled delivery\n");
			oIntroField.appendText("of 4 products on ");
			
			var oDeliveryDate:Time = _gameController.GetNextCsaDeliveryDate();
			
			if (oDeliveryDate.useMonth == true)
			{
				oIntroField.appendText(Time.MONTHS_LONG[oDeliveryDate.month] + " ");
			}
			else
			{
				oIntroField.appendText(Time.SEASONS[oDeliveryDate.season] + " ");
			}
			
			oIntroField.appendText(String(oDeliveryDate.date + 1) + ".");
			
			oIntroField.setTextFormat(oTextFormat);
			oIntroField.x = 25;
			oIntroField.y = 25;
			
			mcMenu.addChild(oIntroField);
			
			var iX:int = 80;
			var iY:int = oIntroField.height + 75;
			
			for (var i:int = 0; i < _csaState.customers.length; i++)
			{
				var oObject:Object = _csaState.customers[i];
				
				if (oObject == null)
				{
					continue;
				}
				
				if (!(oObject is CsaCustomer))
				{
					continue;
				}
				
				var oCustomer:CsaCustomer = CsaCustomer(oObject);
				
				if (oCustomer.signedUp == true)
				{
					var oCancelSignupButton:Csa_CancelSignupButton_MC = new Csa_CancelSignupButton_MC();
					oCancelSignupButton.x = iX;
					oCancelSignupButton.y = iY;
					oCancelSignupButton.customerIndex = i;
					oCancelSignupButton.buttonMode = true;
					oCancelSignupButton.addEventListener(MouseEvent.CLICK, OnCancelSignupButtonClick, false, 0, true);
					mcMenu.addChild(oCancelSignupButton);
				}
				else
				{
					var oSignupButton:Csa_SignupButton_MC = new Csa_SignupButton_MC();
					oSignupButton.x = iX;
					oSignupButton.y = iY;
					oSignupButton.customerIndex = i;
					oSignupButton.buttonMode = true;
					oSignupButton.addEventListener(MouseEvent.CLICK, OnSignupButtonClick, false, 0, true);
					mcMenu.addChild(oSignupButton);
				}
				
				// Customer name text field
				var oNameField:TextField = new TextField();
				oNameField.text = oCustomer.name;
				oNameField.autoSize = TextFieldAutoSize.LEFT;
				oNameField.setTextFormat(oTextFormat);
				
				oNameField.x = iX + 90;
				oNameField.y = iY - 10;
				
				mcMenu.addChild(oNameField);
				
				iY += 60;
			}
			
			return mcMenu;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function OnCancelSignupButtonClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			var oCustomer:CsaCustomer = CsaCustomer(_csaState.customers[event.currentTarget.customerIndex]);
			
			oCustomer.signedUp = false;
			
			_gameController.RepaintAll();
		}
		
		private function OnSignupButtonClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			var oCustomer:CsaCustomer = CsaCustomer(_csaState.customers[event.currentTarget.customerIndex]);
			
			oCustomer.signedUp = true;
			
			_gameController.RepaintAll();
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}