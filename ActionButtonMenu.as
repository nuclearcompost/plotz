package
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	//-----------------------
	//Purpose:				The internal workings of a menu that holds action buttons
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class ActionButtonMenu implements IMenuContent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get gridHeight():int
		{
			if (_buttons == null)
			{
				return 1;
			}
			
			return _buttons.length;
		}
		
		public function set menuTab(value:MenuTab):void
		{
			_menuTab = value;
		}
		
		public function get menuTabDisplayName():String
		{
			return _tabName;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _buttons:Array;
		private var _gameController:GameController;
		private var _menuTab:MenuTab;
		private var _tabName:String;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function ActionButtonMenu(buttons:Array = null, tabName:String = "", gameController:GameController = null)
		{
			_buttons = buttons;
			if (_buttons == null)
			{
				_buttons = new Array();
			}
			
			_tabName = tabName;
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
			
			if (_buttons == null)
			{
				return mcMenuBody;
			}
			
			var iX:int = 15;
			var iY:int = 2;
			
			for (var i:int = 0; i < _buttons.length; i++)
			{
				if (_buttons[i] is MenuActionButton && _buttons[i] != null)
				{
					var oButton:MenuActionButton = MenuActionButton(_buttons[i]);
					var mcButton:SimpleButton = oButton.Paint();
					mcButton.x = iX;
					mcButton.y = iY;
				}
				
				mcMenuBody.addChild(mcButton);
				
				iY += (mcButton.height + 5);
			}
			
			return mcMenuBody;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}