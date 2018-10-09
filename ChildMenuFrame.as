package
{
	import flash.display.MovieClip;
	
	public class ChildMenuFrame extends MenuFrame
	{
		// Public Properties //
				
		public function get parentMenu():ParentMenuFrame
		{
			return _parentMenu;
		}
		
		public function set parentMenu(value:ParentMenuFrame):void
		{
			_parentMenu = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _parentMenu:ParentMenuFrame;
		
		//- Private Properties -//
		
		
		// Initialization //
		
		public function ChildMenuFrame(gameController:GameController = null, contents:Array = null,
								  		label:String = "", labelSlotWidth:int = 0, buttons:Array = null,
								  		activeTab:int = 0, lockTabs:Boolean = false, showTabs:Boolean = true,
										parentMenu:ParentMenuFrame = null)
		{
			super(gameController, contents, label, labelSlotWidth, buttons, activeTab, null, null, lockTabs, showTabs);
			
			_parentMenu = parentMenu;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function GetGridHeight():int
		{
			if (_parentMenu.IsChildCollapsed() == true)
			{
				return 0;
			}
			
			var iGridHeight:int = _tabStrip.gridHeight + _header.gridHeight;
			
			return iGridHeight;
		}
		
		public override function Paint():MovieClip
		{
			var mcMenuFrame:MovieClip = new MovieClip();
			
			if (_parentMenu.IsChildCollapsed() == false)
			{
				// menu frame
				var oMenuFrameGraphics:Menu_MC = new Menu_MC();
				oMenuFrameGraphics.gotoAndStop(GetGridHeight());
				mcMenuFrame.addChild(oMenuFrameGraphics);
				
				// menu header
				if (_header != null)
				{
					var oHeaderGraphics:MovieClip = _header.Paint();
					mcMenuFrame.addChild(oHeaderGraphics);
				}
				
				// menu tab strip
				var oTabStripGraphics:MovieClip = _tabStrip.Paint();
				oTabStripGraphics.y += (_header.gridHeight * UIManager.GRID_PIXEL_HEIGHT);
				
				mcMenuFrame.addChild(oTabStripGraphics);
			}
			
			return mcMenuFrame;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
	}
	
}