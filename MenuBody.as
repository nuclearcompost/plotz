package
{
	import flash.display.MovieClip;
	
	public class MenuBody extends MovieClip
	{
		// Constants //
		
		// NOTE: You cannot just change these values as you like - they map to the MenuPrice_MC frame values
		public static const TYPE_NONINVENTORY:int = -1;
		public static const TYPE_STORAGE:int = 0;
		public static const TYPE_BUY:int = 1;
		public static const TYPE_SELL:int = 2;
		public static const TYPE_MARKET:int = 3;  // contains items to be sold, and the player can choose the sell price
		
		//* Constants *//
		
		
		// Public Properties //
		
		public function get gridHeight():int
		{
			return _gridHeight;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _contents:Array;
		private var _gridHeight:int;
		private var _maxSize:int;
		private var _menu:MenuFrame;
		private var _tab:int;
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		public function MenuBody(menu:MenuFrame, tab:int, type:int = 0)
		{
			_menu = menu;
			_tab = tab;
			_type = type;
			
			_maxSize = _menu.contents.GetTabMaxSize(tab);

			var iContentType:int = menu.contents.GetTabContentType(tab);
			
			_contents = new Array();
			for (var i:int = 0; i < _maxSize; i++)
			{
				if (iContentType == Inventory.CONTENT_TYPE_ITEM)
				{
					_contents[i] = new MenuInventoryItem(menu, this, tab, i);
				}
				else if (iContentType == Inventory.CONTENT_TYPE_ACTIONBTN)
				{
					var iType:int = int(menu.contents.GetItemAt(i, tab));
					_contents[i] = new MenuActionButton(menu, iType);
				}
			}
			
			_gridHeight = CalculateGridHeight();
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		public function Paint():MovieClip
		{
			var mcMenuBody:MovieClip = new MovieClip();
			
			var iX:int = 0;
			var iY:int = 0;
			var iContentType:int = _menu.contents.GetTabContentType(_tab);
			
			if (iContentType == Inventory.CONTENT_TYPE_ITEM)
			{
				for (var i:int = 0; i < _maxSize; i++)
				{
					var oMenuSlotGraphics:MovieClip = MenuInventoryItem(_contents[i]).Paint();
					oMenuSlotGraphics.x = iX;
					oMenuSlotGraphics.y = iY;
					mcMenuBody.addChild(oMenuSlotGraphics);
					
					iX += UIManager.MENU_INV_ITEM_GRID_WIDTH * UIManager.GRID_PIXEL_WIDTH;
					if (iX >= UIManager.MAX_VIEW_PIXEL_X)
					{
						iX = 0;
						iY += UIManager.MENU_INV_ITEM_GRID_HEIGHT * UIManager.GRID_PIXEL_HEIGHT;
						
						// add extra height if there are prices to display
						if (_type != MenuBody.TYPE_STORAGE)
						{
							iY += UIManager.GRID_PIXEL_HEIGHT;  // 1 additional tile of height for the prices
						}
						
						// add more extra height if the prices can be modified
						if (_type == MenuBody.TYPE_MARKET)
						{
							iY += UIManager.GRID_PIXEL_HEIGHT;
						}
					}
				}
			}
			else if (iContentType == Inventory.CONTENT_TYPE_ACTIONBTN)
			{
				for (i = 0; i < _maxSize; i++)
				{
					if (_contents[i] == null)
					{
						continue;
					}
					
					var oMenuActionButtonGraphics:MovieClip = MenuActionButton(_contents[i]).Paint();
					oMenuActionButtonGraphics.x = iX;
					oMenuActionButtonGraphics.y = iY;
					mcMenuBody.addChild(oMenuActionButtonGraphics);
					
					iY += UIManager.GRID_PIXEL_HEIGHT;
				}
			}
			
			return mcMenuBody;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//---------------
		//Purpose:		Calculate the grid height needed to properly display the contents of this MenuBody
		//
		//Parameters:
		//	none
		//
		//Returns:		the height in Grid squares that is needed to display this MenuBody
		//---------------
		private function CalculateGridHeight():int
		{
			var iGridHeight:int = -1;
			var iContentType:int = _menu.contents.GetTabContentType(_tab);
						
			if (iContentType == Inventory.CONTENT_TYPE_ITEM)
			{
				var iNumRowsOfItems:int = Math.ceil(_maxSize / UIManager.MENU_INV_ITEMS_PER_ROW);
				
				// items
				iGridHeight = iNumRowsOfItems * UIManager.MENU_INV_ITEM_GRID_HEIGHT;
				
				// prices
				if (_type != MenuBody.TYPE_STORAGE)
				{
					iGridHeight += iNumRowsOfItems;
				}
				
				// price adjustment buttons
				if (_type == MenuBody.TYPE_MARKET)
				{
					iGridHeight += iNumRowsOfItems;
				}
			}
			else if (iContentType == Inventory.CONTENT_TYPE_ACTIONBTN)
			{
				// Assuming only 1 column of Action Buttons:
				iGridHeight = _maxSize * UIManager.MENU_ACTION_BTN_GRID_HEIGHT;
			}
			
			return iGridHeight;
		}
		
		//- Private Methods -//
	}
}