package
{
	//-----------------------
	//Purpose:				Handles updating the main UI panel for the game
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class MouseOverUIPanel
	{		
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get footerItemAnchor():PixelLocation
		{
			return _footerItemAnchor;
		}
		
		public function set footerItemAnchor(value:PixelLocation):void
		{
			_footerItemAnchor = value;
		}
		
		public function get footerPreviewItem():Object
		{
			return _footerPreviewItem;
		}
		
		public function set footerPreviewItem(value:Object):void
		{
			_footerPreviewItem = value;
		}
		
		public function get gridBldgAnchor():PixelLocation
		{
			return _gridBldgAnchor;
		}
		
		public function set gridBldgAnchor(value:PixelLocation):void
		{
			_gridBldgAnchor = value;
		}
		
		public function get gridItemAnchor():PixelLocation
		{
			return _gridItemAnchor;
		}
		
		public function set gridItemAnchor(value:PixelLocation):void
		{
			_gridItemAnchor = value;
		}
		
		public function get gridPreviewBldg():Object
		{
			return _gridPreviewBldg;
		}
		
		public function set gridPreviewBldg(value:Object):void
		{
			_gridPreviewBldg = value;
		}
		
		public function get gridPreviewItem():Object
		{
			return _gridPreviewItem;
		}
		
		public function set gridPreviewItem(value:Object):void
		{
			_gridPreviewItem = value;
		}
		
		public function get menuItemAnchor():PixelLocation
		{
			return _menuItemAnchor;
		}
		
		public function set menuItemAnchor(value:PixelLocation):void
		{
			_menuItemAnchor = value;
		}
		
		public function get menuPreviewItem():Object
		{
			return _menuPreviewItem;
		}
		
		public function set menuPreviewItem(value:Object):void
		{
			_menuPreviewItem = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _footerItemAnchor:PixelLocation;
		private var _footerPreviewItem:Object;
		private var _gridBldgAnchor:PixelLocation;
		private var _gridItemAnchor:PixelLocation;
		private var _gridPreviewBldg:Object;
		private var _gridPreviewItem:Object;
		private var _menuItemAnchor:PixelLocation;
		private var _menuPreviewItem:Object;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		Create a new instance of the MainUIPanel object
		//
		//Parameters:
		//	none
		//
		//Returns:		reference to the new object
		//---------------
		public function MouseOverUIPanel()
		{
			_footerItemAnchor = new PixelLocation(0, 0);
			_gridBldgAnchor = new PixelLocation(0, 0);
			_gridItemAnchor = new PixelLocation(0, 0);
			_menuItemAnchor = new PixelLocation(0, 0);
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		
		//- Protected Methods -//
	}
}