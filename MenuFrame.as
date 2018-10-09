package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MenuFrame extends MovieClip
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get header():MenuHeader
		{
			return _header;
		}
		
		public function set header(value:MenuHeader):void
		{
			_header = value;
		}
		
		public function get tabStrip():MenuTabStrip
		{
			return _tabStrip;
		}
		
		public function set tabStrip(value:MenuTabStrip):void
		{
			_tabStrip = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //

		protected var _gameController:GameController;
		protected var _header:MenuHeader;
		protected var _tabStrip:MenuTabStrip;
		
		//- Private Properties -//
		
		
		// Initialization //
		
		//---------------
		//Purpose:		Construct a new MenuFrame object
		//
		//Parameters:
		//	gameController:GameController = controller for handling events at the root level
		//	contents:Array = 1d array of IMenuContent objects - the menu will have 1 tab for each content
		//	
		//	label:String = label for the Menu header
		//	labelSlotWidth:int = the number of tiles wide needed for the label on the menu header
		//	buttons:Array = an array of MenuHeader HEADER_BUTTON values - defines what buttons appear on the menu header
		//
		//	activeTab:int = the currently active tab index
		//	childTypes:Array = an array of Bldg TYPE values that define what child menus should appear for each tab
		//	childTabs:Array = an array of <Specific Bldg Obj> TAB values that define what tab of the specific building's inventory should appear for each tab of the parent's inventory
		//	lockTabs:Boolean (default:false) = set to true to lock the tabs (usually done for child menus)
		//
		//Returns:		reference to the new object
		//---------------
		public function MenuFrame(gameController:GameController, contents:Array = null,
								  label:String = "", labelSlotWidth:int = 0, buttons:Array = null,
								  activeTab:int = 0, childTypes:Array = null, childTabs:Array = null, lockTabs:Boolean = false, showTabs:Boolean = true)
		{
			_gameController = gameController;
			
			_header = new MenuHeader(this, gameController, label, labelSlotWidth, buttons);
			
			_tabStrip = new MenuTabStrip(this, gameController, contents, activeTab, lockTabs, showTabs, childTypes, childTabs);
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function GetActiveTabBldgType():int
		{
			return _tabStrip.GetActiveTabBldgType();
		}
		
		public function GetActiveTabChildTab():int
		{
			return _tabStrip.GetActiveTabChildTab();
		}
		
		public function GetGridHeight():int
		{
			var iGridHeight:int = _tabStrip.gridHeight + _header.gridHeight;
			
			return iGridHeight;
		}
		
		public function Paint():MovieClip
		{
			var mcMenuFrame:MovieClip = new MovieClip();
			
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
			
			return mcMenuFrame;
		}
		
		/// Event Handlers ///
		
		///- Event Handlers -///
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
	}
}