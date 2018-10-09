package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	//-----------------------
	//Purpose:				Allow the user to change the CustomDayEvent type on the calendar day mode
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class EventTypePicker extends CustomEventPropertyPicker
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get type():int
		{
			return CustomEventPropertyPicker.TYPE_EVENT;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _type:int;
		private var _types:Array;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function EventTypePicker(parent:CalendarMenu, viewState:CustomDayEventViewState, types:Array, type:int)
		{
			super(parent, viewState);
			
			_types = types;
			_type = type;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function GetGraphics():MovieClip
		{
			var mcPicker:MovieClip = new MovieClip();
			
			var btnHeader:Calendar_EventTypePicker_Btn = new Calendar_EventTypePicker_Btn();
			
			UIManager.AssignButtonText(btnHeader, String(DayEvent.GetDescription(_viewState.event.eventType)));
			
			btnHeader.addEventListener(MouseEvent.CLICK, OnHeaderClick, false, 0, true);
			mcPicker.addChild(btnHeader);
			
			if (_isOpen == true)
			{
				for (var i:int = 0; i < _types.length; i++)
				{
					var iEventType:int = int(_types[i]);
					var sDescription:String = DayEvent.DESCRIPTION[iEventType];
					
					var mcOption:EventTypePicker_Option_MC = new EventTypePicker_Option_MC();
					mcOption.x = (btnHeader.width / 2) - (mcOption.width / 2);
					mcOption.y = 25 + (i * mcOption.height);
					mcOption.Message.text = sDescription;
					mcOption.eventType = iEventType;
					mcOption.addEventListener(MouseEvent.CLICK, OnEventTypeOptionClick, false, 0, true);
					mcOption.addEventListener(MouseEvent.ROLL_OUT, OnEventTypeOptionRollOut, false, 0, true);
					mcOption.addEventListener(MouseEvent.ROLL_OVER, OnEventTypeOptionRollOver, false, 0, true);
					mcPicker.addChild(mcOption);
				}
			}
			
			return mcPicker;
		}
		
		public override function GetHeaderWidth():int
		{
			var btnHeader:Calendar_EventTypePicker_Btn = new Calendar_EventTypePicker_Btn();
			var iWidth:int = btnHeader.width;
			
			return iWidth;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function OnEventTypeOptionClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			if (_viewState.event.eventType == event.currentTarget.eventType)
			{
				return;
			}
			
			_parent.DeleteEvent(_viewState);
			
			if (_viewState.event.eventType == DayEvent.TYPE_CUSTOM_PLANT && event.currentTarget.eventType == DayEvent.TYPE_CUSTOM_HARVEST)
			{
				var oOldPlantEvent:CustomPlantEvent = CustomPlantEvent(_viewState.event);
				var oNewEvent:CustomDayEvent = new CustomHarvestEvent(oOldPlantEvent.plantType, oOldPlantEvent.time.GetClone(), oOldPlantEvent.occurrences);
				oNewEvent.ForceToValidValues(_parent.calendarState.time);
				_parent.AddEvent(oNewEvent);
			}
			else if (_viewState.event.eventType == DayEvent.TYPE_CUSTOM_HARVEST && event.currentTarget.eventType == DayEvent.TYPE_CUSTOM_PLANT)
			{
				var oOldHarvestEvent:CustomHarvestEvent = CustomHarvestEvent(_viewState.event);
				oNewEvent = new CustomPlantEvent(oOldHarvestEvent.fruitType, oOldHarvestEvent.time.GetClone(), oOldHarvestEvent.occurrences);
				_parent.AddEvent(oNewEvent);
			}
		}
		
		private function OnEventTypeOptionRollOut(event:MouseEvent):void
		{
			event.stopPropagation();
			
			event.currentTarget.gotoAndStop(1);
		}
		
		private function OnEventTypeOptionRollOver(event:MouseEvent):void
		{
			event.stopPropagation();
			
			event.currentTarget.gotoAndStop(2);
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}