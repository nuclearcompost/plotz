package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	//-----------------------
	//Purpose:				Parent class for "pickers" that let you choose a value for a property of a CustomDayEvent
	//
	//Properties:
	//	
	//Methods:
	//	
	//Extended By:
	//	EventTypePicker
	//	FruitTypePicker
	//	NumberPicker
	//	PlantTypePicker
	//
	//-----------------------
	public class CustomEventPropertyPicker
	{
		// Constants //
		
		public static const TYPE_EVENT:int = 0;
		public static const TYPE_QUANTITY:int = 1;
		public static const TYPE_PLANT:int = 2;
		public static const TYPE_FRUIT:int = 3;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		// override in each child class
		public function get type():int
		{
			trace("CustomEventPropertyPicker type getter called");
			return -1;
		}
		
		//- Public Properties -//
		
		
		// Protected Properties //
		
		protected var _isOpen:Boolean;
		protected var _parent:CalendarMenu;
		protected var _viewState:CustomDayEventViewState;
		
		//- Protected Properties -//
		
	
		// Initialization //
		
		public function CustomEventPropertyPicker(parent:CalendarMenu, viewState:CustomDayEventViewState)
		{
			_parent = parent;
			_viewState = viewState;
			
			_isOpen = false;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function Close():void
		{
			_isOpen = false;
		}
		
		// override in each child class
		public function GetGraphics():MovieClip
		{
			trace("CustomEventPropertyPicker GetGraphics method called");
			return new MovieClip();
		}
		
		// override in each child class
		public function GetHeaderWidth():int
		{
			trace("CustomEventPropertyPicker GetHeaderWidth method called");
			return 0;
		}
		
		public function Open():void
		{
			_isOpen = true;
		}
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		protected function OnHeaderClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_isOpen = !(_isOpen);
			
			_parent.TogglePickersForViewState(this, _viewState);
		}
		
		//- Protected Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}