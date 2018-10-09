package
{
	import flash.display.MovieClip;
	
	public class MenuTabStrip extends MovieClip
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get activeTab():int
		{
			return _activeTab;
		}
		
		public function get gridHeight():int
		{
			return _gridHeight;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _activeTab:int;
		private var _childTabs:Array;
		private var _childTypes:Array;
		private var _gameController:GameController;
		private var _gridHeight:int;
		private var _lockTabs:Boolean;
		private var _menu:MenuFrame;
		private var _showTabs:Boolean;
		private var _tabs:Array;
		
		//- Private Properties -//
	
	
		// Initialization //
		
		public function MenuTabStrip(menu:MenuFrame, gameController:GameController, contents:Array, activeTab:int = 0, lockTabs:Boolean = false, showTabs:Boolean = true,
									 childTypes:Array = null, childTabs:Array = null)
		{
			_menu = menu;
			_gameController = gameController;
			_activeTab = activeTab;
			_showTabs = showTabs;
			_lockTabs = lockTabs;
			
			if (childTypes != null)
			{
				_childTypes = childTypes.slice();
			}
			
			if (childTabs != null)
			{
				_childTabs = childTabs.slice();
			}
						
			_tabs = new Array();
			
			if (contents != null)
			{
				for (var t:int = 0; t < contents.length; t++)
				{
					if (!(contents[t] is IMenuContent))
					{
						continue;
					}
					
					var oMenuContent:IMenuContent = IMenuContent(contents[t]);
	
					_tabs[t] = new MenuTab(menu, this, oMenuContent, t, Boolean(t == activeTab));
				}
			}
			
			_gridHeight = CalculateGridHeight();
			
			ActivateTab(_activeTab);
		}
		
		//- Initialization -//
		
	
		// Public Methods //
		
		public function ActivateTab(index:int):void
		{
			if (index < 0 || index > _tabs.length)
			{
				return;
			}
			
			if (_lockTabs)
			{
				return;
			}
			
			_activeTab = index;
			UpdateActiveTabValues();
			_gridHeight = CalculateGridHeight();

			if (_childTypes != null && _childTabs != null)
			{
				_gameController.UpdateChildMenu(_childTypes[_activeTab], _childTabs[_activeTab]);
			}
			
			UpdateMenuHeaderButtons();
			
			_gameController.RepaintAll();
		}
		
		public function GetActiveTabBldgType():int
		{
			if (_childTypes == null)
			{
				return -1;
			}
			
			return _childTypes[_activeTab];
		}
		
		public function GetActiveTabChildTab():int
		{
			if (_childTabs == null)
			{
				return -1;
			}
			
			return _childTabs[_activeTab];
		}
		
		public function GetActiveTabContent():IMenuContent
		{
			var oTab:MenuTab = _tabs[_activeTab];
			
			var oContent:IMenuContent = oTab.content;
			
			return oContent;
		}
		
		public function LockTabs():void
		{
			_lockTabs = true;
		}
		
		public function Paint():MovieClip
		{
			var mcTabStrip:MovieClip = new MovieClip();
			
			for (var t:int = 0; t < _tabs.length; t++)
			{
				mcTabStrip.addChild(MenuTab(_tabs[t]).Paint());
			}
			
			return mcTabStrip;
		}
		
		public function ShowTabs():Boolean
		{
			var bShowTabs:Boolean = true;
			
			if (_showTabs == false && _tabs.length == 1)
			{
				bShowTabs = false;
			}
			
			return bShowTabs;
		}
		
		public function UpdateActiveTabValues():void
		{
			for (var t:int = 0; t < _tabs.length; t++)
			{
				MenuTab(_tabs[t]).SetActiveStatus(Boolean(t == _activeTab));
			}
		}
		
		public function UpdateGridHeight():void
		{
			_gridHeight = CalculateGridHeight();
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//---------------
		//Purpose:		Calculates the Grid height needed to display the tab strip and its contents
		//
		//Parameters:
		//	none
		//
		//Returns:		the grid height for the tab strip, considering the current tab
		//---------------
		private function CalculateGridHeight():int
		{
			return MenuTab(_tabs[_activeTab]).GetGridHeight();
		}
		
		private function UpdateMenuHeaderButtons():void
		{
			if (!(_menu is ParentMenuFrame))
			{
				return;
			}
			
			var oParentMenuFrame:ParentMenuFrame = ParentMenuFrame(_menu);
			
			oParentMenuFrame.UpdateMenuHeaderButtons();
		}
		
		//- Private Methods -//
	}
	
}