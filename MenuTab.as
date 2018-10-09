package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MenuTab extends MovieClip
	{
		// Constants //
		
		private static const GRID_WIDTH:int = 4;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get content():IMenuContent
		{
			return _content;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _content:IMenuContent;
		private var _group:int;
		private var _isActive:Boolean;
		private var _label:String;
		private var _menu:MenuFrame;
		private var _tabStrip:MenuTabStrip;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function MenuTab(menu:MenuFrame, tabStrip:MenuTabStrip, content:IMenuContent, group:int, isActive:Boolean)
		{
			_menu = menu;
			_tabStrip = tabStrip;
			_content = content;
			_group = group;
			_isActive = isActive;
			
			_label = _content.menuTabDisplayName;
			
			if (_content != null)
			{
				_content.menuTab = this;
			}
		}
		
		//- Initialization -//
		
	
		// Public Methods //
		
		public function GetGridHeight():int
		{
			var iReturn:int = 1 + _content.gridHeight;
			
			if (_tabStrip.ShowTabs() == false)
			{
				iReturn--;
			}
			
			return iReturn;
		}
		
		public function IsInParentMenu():Boolean
		{
			if (_menu is ParentMenuFrame)
			{
				return true;
			}
			
			return false;
		}
		
		public function Paint():MovieClip
		{
			var mcMenuTab:MovieClip = new MovieClip();
			
			var bShowTabs:Boolean = _tabStrip.ShowTabs();
			
			// menu tab
			if (_isActive)
			{
				var oMenuTabGraphics = new MenuTab_MC();
				oMenuTabGraphics.x = 0;
				
				if (bShowTabs == true)
				{
					oMenuTabGraphics.y = UIManager.GRID_PIXEL_HEIGHT;  // down 1 tile b/c the Tap Topper takes up 1 Grid square of height
					oMenuTabGraphics.gotoAndStop(GetGridHeight() - 1);  // -1 b/c the Tab Topper takes up 1 Grid square of height
				}
				else
				{
					oMenuTabGraphics.y = 0;
					oMenuTabGraphics.gotoAndStop(GetGridHeight());
				}
				
				mcMenuTab.addChild(oMenuTabGraphics);
			}
			
			// menu tab topper
			if (bShowTabs == true)
			{
				var oMenuTabTopperGraphics = new MenuTabTopper_MC();
				
				oMenuTabTopperGraphics.x = _group * MenuTab.GRID_WIDTH * UIManager.GRID_PIXEL_WIDTH;
				oMenuTabTopperGraphics.y = 0;
				
				if (!_isActive)
				{
					oMenuTabTopperGraphics.gotoAndStop(2);
					oMenuTabTopperGraphics.addEventListener(MouseEvent.CLICK, OnTabTopperClick);
				}
				
				oMenuTabTopperGraphics.Label.text = _label;
				
				mcMenuTab.addChild(oMenuTabTopperGraphics);
			}
			
			// menu body
			if (_isActive)
			{
				var oMenuBodyGraphics = _content.Paint();
				oMenuBodyGraphics.x = 0;
				
				if (bShowTabs == true)
				{
					oMenuBodyGraphics.y = UIManager.GRID_PIXEL_HEIGHT;  // down 1 tile b/c the Tap Topper takes up 1 Grid square of height
				}
				else
				{
					oMenuBodyGraphics.y = 0;
				}
				
				mcMenuTab.addChild(oMenuBodyGraphics);
			}
			
			return mcMenuTab;
		}
		
		public function SetActiveStatus(status:Boolean):void
		{
			_isActive = status;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function OnTabTopperClick(event:MouseEvent):void
		{
			_tabStrip.ActivateTab(_group);
		}
		
		//- Private Methods -//
	}
}