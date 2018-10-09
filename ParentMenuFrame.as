package
{	
	import flash.events.MouseEvent;
	
	public class ParentMenuFrame extends MenuFrame
	{
		// Public Properties //
		
		public function get childMenu():ChildMenuFrame
		{
			return _childMenu;
		}
		
		public function set childMenu(value:ChildMenuFrame):void
		{
			_childMenu = value;
		}
		
		public function get showChildTabs():Array
		{
			return _showChildTabs;
		}
		
		public function set showChildTabs(value:Array):void
		{
			_showChildTabs = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _childMenu:ChildMenuFrame;
		private var _showChildTabs:Array;
		
		//- Private Properties -//
		
		
		// Initialization //
		
		public function ParentMenuFrame(gameController:GameController = null, contents:Array = null, showChildTabs:Array = null,
								  		label:String = "", labelSlotWidth:int = 0, buttons:Array = null,
								  		activeTab:int = 0, childTypes:Array = null, childTabs:Array = null, lockTabs:Boolean = false, showTabs:Boolean = true,
										childMenu:ChildMenuFrame = null)
		{
			super(gameController, contents, label, labelSlotWidth, buttons, activeTab, childTypes, childTabs, lockTabs, showTabs);
			
			_childMenu = childMenu;
			_showChildTabs = showChildTabs;
			
			UpdateMenuHeaderButtons();
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function IsChildCollapsed():Boolean
		{
			if (_tabStrip == null || _showChildTabs == null)
			{
				return false;
			}
			
			var iActiveTab:int = _tabStrip.activeTab;
			
			if (_showChildTabs[iActiveTab] == null)
			{
				return false;
			}
			
			if (!(_showChildTabs[iActiveTab] is Boolean))
			{
				return false;
			}
			
			var bIsChildCollapsed:Boolean = !(Boolean(_showChildTabs[iActiveTab]));
			
			return bIsChildCollapsed;
		}
		
		public function ToggleChildMenu():void
		{
			if (_tabStrip == null || _showChildTabs == null || _childMenu == null)
			{
				return;
			}
			
			var iActiveTab:int = _tabStrip.activeTab;
			
			_showChildTabs[iActiveTab] = !(_showChildTabs[iActiveTab]);
		}
		
		public function UpdateMenuHeaderButtons():void
		{
			if (_showChildTabs == null || _tabStrip == null)
			{
				_header.RemoveCollapseChildButton();
				return;
			}
			
			var iActiveTab:int = _tabStrip.activeTab;
			
			if (_showChildTabs[iActiveTab] == null)
			{
				_header.RemoveCollapseChildButton();
				return;
			}
			
			if (!(_showChildTabs[iActiveTab] is Boolean))
			{
				_header.RemoveCollapseChildButton();
				return;
			}
			
			_header.AddCollapseChildButton();
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
	}
}