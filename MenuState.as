package
{
	//-----------------------
	//Purpose:				Hold state of open menus of various types
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class MenuState
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get childMenu():ChildMenuFrame
		{
			return _childMenu;
		}
		
		public function set childMenu(value:ChildMenuFrame):void
		{
			_childMenu = value;
		}
		
		public function get popUpMenu():PopUpMenu
		{
			return _popUpMenu;
		}
		
		public function set popUpMenu(value:PopUpMenu):void
		{
			_popUpMenu = value;
		}
		
		public function get parentMenu():ParentMenuFrame
		{
			return _parentMenu;
		}
		
		public function set parentMenu(value:ParentMenuFrame):void
		{
			_parentMenu = value;
		}
		
		public function get parentMenuSource():Object
		{
			return _parentMenuSource;
		}
		
		public function set parentMenuSource(value:Object):void
		{
			_parentMenuSource = value;
		}
		
		public function get showPlants():Boolean
		{
			return _showPlants;
		}
		
		public function set showPlants(value:Boolean):void
		{
			_showPlants = value;
		}		
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _childMenu:ChildMenuFrame;
		private var _popUpMenu:PopUpMenu;
		private var _parentMenu:ParentMenuFrame;
		private var _parentMenuSource:Object;
		private var _showPlants:Boolean;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function MenuState(parentMenu:ParentMenuFrame = null, childMenu:ChildMenuFrame = null, popUpMenu:PopUpMenu = null,
								  parentMenuSource:Object = null, showPlants:Boolean = true)
		{
			_parentMenu = parentMenu;
			_childMenu = childMenu;
			_popUpMenu = popUpMenu;
			_parentMenuSource = parentMenuSource;
			_showPlants = showPlants;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}