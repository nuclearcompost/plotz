package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	//-----------------------
	//Purpose:				Button to manipulate custom events on the calendar day mode
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CustomEventButton
	{
		// Constants //
		
		public static const TYPE_DELETE:int = 0;
		public static const TYPE_EDIT:int = 1;
		public static const TYPE_SAVE:int = 2;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get eventViewState():CustomDayEventViewState
		{
			return _eventViewState;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _eventViewState:CustomDayEventViewState;
		private var _parent:CalendarMenu;
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CustomEventButton(parent:CalendarMenu, type:int, eventViewState:CustomDayEventViewState)
		{
			_parent = parent;
			_type = type;
			_eventViewState = eventViewState;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function Paint():MovieClip
		{
			var mcButton:MovieClip = new MovieClip();
			
			switch (_type)
			{
				case CustomEventButton.TYPE_DELETE:
					var btnDelete:Calendar_DeleteCustomEvent_Btn = new Calendar_DeleteCustomEvent_Btn();
					btnDelete.addEventListener(MouseEvent.CLICK, OnDeleteCustomEventButtonClick, false, 0, true);
					mcButton.addChild(btnDelete);
					break;
				case CustomEventButton.TYPE_EDIT:
					var btnEdit:Calendar_EditCustomEvent_Btn = new Calendar_EditCustomEvent_Btn();
					btnEdit.addEventListener(MouseEvent.CLICK, OnEditCustomEventButtonClick, false, 0, true);
					mcButton.addChild(btnEdit);
					break;
				case CustomEventButton.TYPE_SAVE:
					var btnSave:Calendar_SaveCustomEvent_Btn = new Calendar_SaveCustomEvent_Btn();
					btnSave.addEventListener(MouseEvent.CLICK, OnSaveCustomEventButtonClick, false, 0, true);
					mcButton.addChild(btnSave);
					break;
				default:
					break;
			}
			
			return mcButton;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function OnDeleteCustomEventButtonClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_parent.DeleteEvent(_eventViewState);
		}
		
		private function OnEditCustomEventButtonClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_parent.EditEvent(_eventViewState);
		}
		
		private function OnSaveCustomEventButtonClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_parent.SaveEvent(_eventViewState);
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}