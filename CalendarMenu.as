package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	//-----------------------
	//Purpose:				The internal workings of a menu for the Calendar
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CalendarMenu implements IMenuContent
	{
		// Constants //
		
		public static const DAY_MODE_EVENT_TYPE_INDEX:Array = [ 7, 8, 9, 3, 4, 6, 0, 10, 5, 1, 2 ];
		
		private static const DAY_MODE_ICON_X_OFFSET:int = 165;
		private static const DAY_MODE_TEXT_X_OFFSET:int = 185;
		private static const DAY_MODE_Y_OFFSET:int = 85;
		private static const DAY_MODE_NUM_ICONS:int = 15;
		private static const DAY_MODE_ICON_HEIGHT:int = 25;
		
		private static const MONTH_MODE_GRID_X_OFFSET:int = 10;
		private static const MONTH_MODE_GRID_Y_OFFSET:int = 80;
		private static const MONTH_MODE_DAY_WIDTH:int = 100;
		private static const MONTH_MODE_DAY_HEIGHT:int = 100;
		
		private static const CUSTOM_BUTTON_START_X:int = 122;
		private static const CUSTOM_BUTTON_WIDTH:int = 25;
		
		private static const TEXT_COLOR:uint = 0x6C4B1C;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get calendarState():CalendarState
		{
			return _calendarState;
		}
		
		public function get gridHeight():int
		{
			return 11;
		}
		
		public function set menuTab(value:MenuTab):void
		{
			_menuTab = value;
		}
		
		public function get menuTabDisplayName():String
		{
			return "";
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _calendarState:CalendarState;
		private var _customEventButtons:Array;
		private var _customEventViewStates:Array;
		private var _dayModeCustomEventTypes:Array;
		private var _dayModeEvents:Array;
		private var _gameController:GameController;
		private var _menuTab:MenuTab;
		private var _smallTextFormat:TextFormat;
		private var _standardTextFormat:TextFormat;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CalendarMenu(gameController:GameController = null, calendarState:CalendarState = null)
		{
			_gameController = gameController;
			_calendarState = calendarState;
			
			_customEventButtons = new Array();
			_customEventViewStates = new Array();
			_dayModeCustomEventTypes = new Array();
			_dayModeEvents = new Array();
			
			_standardTextFormat = new TextFormat();
			_standardTextFormat.font = "Arial";
			_standardTextFormat.size = 20;
			_standardTextFormat.color = CalendarMenu.TEXT_COLOR;
			
			_smallTextFormat = new TextFormat();
			_smallTextFormat.font = "Arial";
			_smallTextFormat.size = 12;
			_smallTextFormat.color = CalendarMenu.TEXT_COLOR;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function AddEvent(event:CustomDayEvent):void
		{
			// add the event to the calendarStatTracker and dayMode state
			_calendarState.calendarStatTracker.events.push(event);
			var iEventTypeIndex:int = CalendarMenu.DAY_MODE_EVENT_TYPE_INDEX[event.eventType];
			_dayModeEvents[iEventTypeIndex].push(event);
			
			// create viewState for the event and add it to the dayMode state
			var oViewState:CustomDayEventViewState = new CustomDayEventViewState(event, CustomDayEventViewState.MODE_READ);
			_customEventViewStates[iEventTypeIndex].push(oViewState);
			
			var oEventTypePicker:EventTypePicker = new EventTypePicker(this, oViewState, _dayModeCustomEventTypes, event.eventType);
			oViewState.SetPickers(this, oEventTypePicker, _calendarState.time);
			
			// add each linked event to the calendarStatTracker - if the event is on the same day as the base event also add it to dayMode state and generate viewState for it
			var lLinkedEvents:Array = event.GetLinkedEvents();
			for (var i:int = 0; i < lLinkedEvents.length; i++)
			{
				var oLinkedEvent:CustomDayEvent = CustomDayEvent(lLinkedEvents[i]);
				_calendarState.calendarStatTracker.events.push(oLinkedEvent);
				
				if (oLinkedEvent.time.IsSameDay(_calendarState.calendarTime))
				{
					iEventTypeIndex = CalendarMenu.DAY_MODE_EVENT_TYPE_INDEX[oLinkedEvent.eventType];
					_dayModeEvents[iEventTypeIndex].push(oLinkedEvent);
					
					oViewState = new CustomDayEventViewState(oLinkedEvent, CustomDayEventViewState.MODE_READ);
					_customEventViewStates[iEventTypeIndex].push(oViewState);
					
					oEventTypePicker = new EventTypePicker(this, oViewState, _dayModeCustomEventTypes, oLinkedEvent.eventType);
					oViewState.SetPickers(this, oEventTypePicker, _calendarState.time);
				}   
			}
			
			EditEvent(oViewState);
		}
		
		public function DeleteEvent(eventViewState:CustomDayEventViewState):void
		{
			var lLinkedEvents:Array = eventViewState.event.GetLinkedEvents();
			
			for (var i:int = 0; i < lLinkedEvents.length; i++)
			{
				// remove linked event from calendarStatTracker
				var oLinkedEvent:CustomDayEvent = CustomDayEvent(lLinkedEvents[i]);
				_calendarState.calendarStatTracker.RemoveEvent(oLinkedEvent);
				
				if (oLinkedEvent.time.IsSameDay(_calendarState.calendarTime))
				{
					// remove linked event and viewState from dayMode state
					RemoveCustomEventAndViewState(oLinkedEvent);
				}
			}
			
			// remove the base event from calendarStatTracker
			_calendarState.calendarStatTracker.RemoveEvent(eventViewState.event);
			
			// remove base event and viewState from dayMode state
			RemoveCustomEventAndViewState(eventViewState.event);
			
			// repaint the menu
			_gameController.RepaintMenu();
		}
		
		private function RemoveCustomEventAndViewState(event:CustomDayEvent):void
		{
			var iEventTypeIndex:int = CalendarMenu.DAY_MODE_EVENT_TYPE_INDEX[event.eventType];
					
			for (var i:int = 0; i < _dayModeEvents[iEventTypeIndex].length; i++)
			{
				var oCheckEvent:DayEvent = DayEvent(_dayModeEvents[iEventTypeIndex][i]);
				
				if (oCheckEvent == event)
				{
					// remove linked event from dayMode state
					_dayModeEvents[iEventTypeIndex].splice(i, 1);
					
					// remove linked event's viewState from dayMode state
					_customEventViewStates[iEventTypeIndex].splice(i, 1);
					
					break;
				}
			}
		}
		
		public function EditEvent(eventViewState:CustomDayEventViewState):void
		{
			eventViewState.ToggleMode();
			
			// set all other events to read mode
			if (eventViewState.mode == CustomDayEventViewState.MODE_EDIT)
			{
				for (var i:int = 0; i < _customEventViewStates.length; i++)
				{
					for (var j:int = 0; j < _customEventViewStates[i].length; j++)
					{
						var oEvent:DayEvent = DayEvent(_dayModeEvents[i][j]);
						
						if (!(oEvent is CustomDayEvent))
						{
							break;
						}
						
						var oViewState:CustomDayEventViewState = CustomDayEventViewState(_customEventViewStates[i][j]);
						
						if (oViewState != eventViewState)
						{
							oViewState.mode = CustomDayEventViewState.MODE_READ;
						}
					}
				}
			}
			
			_gameController.RepaintMenu();
		}
		
		public function IsInParentMenu():Boolean
		{
			if (_menuTab == null)
			{
				return false;
			}
			
			var bIsInParentMenu:Boolean = _menuTab.IsInParentMenu();
			
			return bIsInParentMenu;
		}
		
		public function Paint():MovieClip
		{
			var mcMenuBody:MovieClip = new MovieClip();
			
			if (_calendarState.dayMode == false)
			{
				PaintMonthMode(mcMenuBody);
			}
			else
			{
				PaintDayMode(mcMenuBody);
			}
			
			return mcMenuBody;
		}
		
		public function Repaint():void
		{
			_gameController.RepaintMenu();
		}
		
		public function SaveEvent(eventViewState:CustomDayEventViewState):void
		{
			eventViewState.ToggleMode();
			
			_gameController.RepaintMenu();
		}
		
		public function TogglePickersForViewState(picker:CustomEventPropertyPicker, viewState:CustomDayEventViewState):void
		{
			if (picker.isOpen == true)
			{
				for (var i:int = 0; i < viewState.pickers.length; i++)
				{
					var oPicker:CustomEventPropertyPicker = CustomEventPropertyPicker(viewState.pickers[i]);
					
					if (oPicker == picker)
					{
						continue;
					}
					
					oPicker.Close();
				}
			}
			
			_gameController.RepaintMenu();
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		/// Core Functionality ///
		
		private function SetDayModeViewState():void
		{
			// get all events for the current day
			_dayModeEvents = _calendarState.calendarStatTracker.GetEventsForCalendarDayMode(_calendarState.calendarTime);
			
			// get all custom event types valid for the current day
			_dayModeCustomEventTypes = CustomDayEvent.GetValidTypes(_calendarState.time, _calendarState.calendarTime);
			
			// build initial viewState for all custom events for the current day
			_customEventViewStates = new Array(_dayModeEvents.length);
			
			for (var i:int = 0; i < _customEventViewStates.length; i++)
			{
				_customEventViewStates[i] = new Array();
				
				if (_dayModeEvents[i].length == 0)
				{
					continue;
				}
				
				var oEvent:DayEvent = DayEvent(_dayModeEvents[i][0]);
				
				if (!(oEvent is CustomDayEvent))
				{
					continue;
				}
				
				for (var j:int = 0; j < _dayModeEvents[i].length; j++)
				{
					var oCustomEvent:CustomDayEvent = CustomDayEvent(_dayModeEvents[i][j]);
					
					var oViewState:CustomDayEventViewState = new CustomDayEventViewState(oCustomEvent, CustomDayEventViewState.MODE_READ);
					_customEventViewStates[i][j] = oViewState;
					
					var oEventTypePicker:EventTypePicker = new EventTypePicker(this, oViewState, _dayModeCustomEventTypes, oCustomEvent.eventType);
					
					oViewState.SetPickers(this, oEventTypePicker, _calendarState.time);
				}
			}
		}
		
		///- Core Functionality -///
		
		
		/// Event Handlers ///
		
		private function OnAddCustomEventButtonClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			var oBaseEvent:CustomDayEvent = CalendarService.GetDefaultCustomEvent(_calendarState.calendarTime);
			
			AddEvent(oBaseEvent);
		}
		
		private function OnDayModeToggleClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_calendarState.dayMode = !(_calendarState.dayMode);
			
			if (_calendarState.dayMode == true)
			{
				SetDayModeViewState();
			}
			
			_gameController.RepaintMenu();
		}
		
		private function OnLeftArrowClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			if (_calendarState.dayMode == false)
			{
				_calendarState.calendarTime = TimeService.BackUpMonth(_calendarState.calendarTime);
			}
			else
			{
				TimeService.BackUpDate(_calendarState.calendarTime);
				SetDayModeViewState();
			}
			
			_gameController.RepaintMenu();
		}
		
		private function OnMonthBackgroundClick(event:MouseEvent):void
		{
			// This is a farking mess... some of the mess is due to us trying to figure out the position of the target at runtime.
			// We can't use event.localX/Y b/c it is local to event.target, NOT event.currentTarget, so it could actually be from anywhere on the screen if a textfield or icon is clicked
			// We can't use event.currentTarget.x/y b/c the highest level of the display tree we can go here is "container", which itself is still positioned at 0 b/c there's so many
			//  levels of stuff in the menu system - the menu header height isn't applied until later, so the container's y value is still not the actual stage y value.
			// The only solution I found to work is to take the event's stageX/Y and then convert it to local coords using the built-in conversion function, then doing the additional
			//  maths to get our grid location from it.
			
			var oStagePoint:Point = new Point(event.stageX, event.stageY);
			var oLocalPoint:Point = event.currentTarget.globalToLocal(oStagePoint);
			var oClickLocation:PixelLocation = new PixelLocation(oLocalPoint.x, oLocalPoint.y);
			var oGridStart:PixelLocation = new PixelLocation(CalendarMenu.MONTH_MODE_GRID_X_OFFSET, CalendarMenu.MONTH_MODE_GRID_Y_OFFSET);
			var oLocalClick:PixelLocation = new PixelLocation(oClickLocation.x - oGridStart.x, oClickLocation.y - oGridStart.y);
			var oLocalClickGrid:PixelLocation = new PixelLocation(Math.floor(oLocalClick.x / CalendarMenu.MONTH_MODE_DAY_WIDTH), Math.floor(oLocalClick.y / CalendarMenu.MONTH_MODE_DAY_HEIGHT));
			var iDay:int = oLocalClickGrid.x + (7 * oLocalClickGrid.y);
			
			if (iDay >= 0 && iDay <= Time.MAX_DATE)
			{
				_calendarState.calendarTime.date = iDay;
				_calendarState.calendarTime.day = TimeService.GetDayForDate(iDay);
				_calendarState.dayMode = true;
				SetDayModeViewState();
				
				_gameController.RepaintMenu();
			}
		}
		
		private function OnRightArrowClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			if (_calendarState.dayMode == false)
			{
				_calendarState.calendarTime = TimeService.AdvanceMonth(_calendarState.calendarTime);
			}
			else
			{
				TimeService.AdvanceDate(_calendarState.calendarTime);
				SetDayModeViewState();
			}
			
			_gameController.RepaintMenu();
		}
		
		///- Event Handlers -///
		
		
		/// Graphics ///
		
		private function PaintDayMode(container:MovieClip):void
		{
			_customEventButtons = new Array();
			
			// background
			var mcBackground:Calendar_Background_MC = new Calendar_Background_MC();
			mcBackground.x = 0;
			mcBackground.y = 0;
			mcBackground.gotoAndStop(2);
			container.addChild(mcBackground);
			
			// current day
			var sDayDisplay:String = String(Time.DAYS_SHORT[_calendarState.calendarTime.day]) + ", " + String(_calendarState.calendarTime.date + 1) + " ";
			
			if (_calendarState.time.useMonth == true)
			{
				sDayDisplay += String(Time.MONTHS_LONG[_calendarState.calendarTime.month]);
			}
			else
			{
				sDayDisplay += String(Time.SEASONS[_calendarState.calendarTime.month]);
			}
			
			mcBackground.Title.text = sDayDisplay;
			
			// previous day arrow
			var bHasPreviousDay:Boolean = TimeService.HasPreviousDayThisYear(_calendarState.calendarTime);
			
			if (bHasPreviousDay == true)
			{
				var btnLeftArrow:Calendar_ArrowLeft_Btn = new Calendar_ArrowLeft_Btn();
				btnLeftArrow.x = 208;
				btnLeftArrow.y = 29;
				btnLeftArrow.addEventListener(MouseEvent.CLICK, OnLeftArrowClick, false, 0, true);
				container.addChild(btnLeftArrow);
			}
			
			// next day arrow
			var bHasNextDay:Boolean = TimeService.HasNextDayThisYear(_calendarState.calendarTime);
			
			if (bHasNextDay == true)
			{
				var btnRightArrow:Calendar_ArrowRight_Btn = new Calendar_ArrowRight_Btn();
				btnRightArrow.x = 512;
				btnRightArrow.y = 29;
				btnRightArrow.addEventListener(MouseEvent.CLICK, OnRightArrowClick, false, 0, true);
				container.addChild(btnRightArrow);
			}
			
			// day mode / calendar mode toggle
			var btnMonthMode:Calendar_DayModeMonth_Btn = new Calendar_DayModeMonth_Btn();
			btnMonthMode.x = 630;
			btnMonthMode.y = 28;
			btnMonthMode.addEventListener(MouseEvent.CLICK, OnDayModeToggleClick, false, 0, true);
			container.addChild(btnMonthMode);
			
			var mcDayModeToggle:Calendar_DayModeToggle_MC = new Calendar_DayModeToggle_MC();
			mcDayModeToggle.x = 670;
			mcDayModeToggle.y = 32;
			mcDayModeToggle.gotoAndStop(2);
			mcDayModeToggle.addEventListener(MouseEvent.CLICK, OnDayModeToggleClick, false, 0, true);
			container.addChild(mcDayModeToggle);
			
			// add custom event button
			if (_dayModeCustomEventTypes.length > 0)
			{
				var btnAddCustomEvent:Calendar_AddCustomEvent_Btn = new Calendar_AddCustomEvent_Btn();
				btnAddCustomEvent.x = 700 - (btnAddCustomEvent.width / 2);
				btnAddCustomEvent.y = CalendarMenu.MONTH_MODE_GRID_Y_OFFSET + 5 + (btnAddCustomEvent.height / 2);
				btnAddCustomEvent.addEventListener(MouseEvent.CLICK, OnAddCustomEventButtonClick, false, 0, true);
				container.addChild(btnAddCustomEvent);
			}
			
			// csa day type
			var iY:int = DAY_MODE_Y_OFFSET;
			
			var iCsaDayType:int = CsaService.GetCsaDayType(_calendarState.calendarTime);
				
			if (iCsaDayType == CsaState.DAY_TYPE_SIGNUP)
			{
				var mcIcon:MovieClip = new Calendar_EventIcon_MC();
				mcIcon.gotoAndStop(5);
				
				var oLabel:TextField = new TextField();
				oLabel.autoSize = TextFieldAutoSize.LEFT;
				oLabel.appendText("CSA Sign-up Day");
				oLabel.setTextFormat(_smallTextFormat);
			}
			else if (iCsaDayType == CsaState.DAY_TYPE_DELIVERY)
			{
				mcIcon = new Calendar_EventIcon_MC();
				mcIcon.gotoAndStop(6);
				
				oLabel = new TextField();
				oLabel.autoSize = TextFieldAutoSize.LEFT;
				oLabel.appendText("CSA Delivery Day");
				oLabel.setTextFormat(_smallTextFormat);
			}
			
			if (iCsaDayType != CsaState.DAY_TYPE_STATUS)
			{
				mcIcon.x = CalendarMenu.DAY_MODE_ICON_X_OFFSET;
				mcIcon.y = iY;
				oLabel.x = CalendarMenu.DAY_MODE_TEXT_X_OFFSET;
				oLabel.y = iY;
				container.addChild(mcIcon);
				container.addChild(oLabel);
				iY += CalendarMenu.DAY_MODE_ICON_HEIGHT;
			}
			
			// events
			var mcPicker:MovieClip = new MovieClip();
			
			for (var i:int = 0; i < _dayModeEvents.length; i++)
			{
				if (iY > (CalendarMenu.DAY_MODE_Y_OFFSET + ((CalendarMenu.DAY_MODE_NUM_ICONS - 1) * CalendarMenu.DAY_MODE_ICON_HEIGHT)))
				{
					break;
				}
				
				if (_dayModeEvents[i] == null)
				{
					continue;
				}
				
				var lCurrentEvents:Array = _dayModeEvents[i];
				
				if (lCurrentEvents.length == 0)
				{
					continue;
				}
				
				if (i == 0 || i == 10) // weather and well amount - only one per day
				{
					var oEvent:DayEvent = DayEvent(lCurrentEvents[0]);
					iY = PaintDayModeSingleEvent(oEvent, container, iY);
				}
				else if (i == 3 || i == 5 || i == 6 || i == 7)  // plant killed, future harvest, seed planted, fruit harvested - multiple per day
				{
					iY = PaintDayModeMultiEvent(lCurrentEvents, container, iY);
				}
				else if (i == 4 || i == 8 || i == 9) // salecart sale, itemshop purchase, itemshop sale - coalesce into a single event per type
				{
					iY = PaintDayModeCoalesce(lCurrentEvents, container, iY);
				}
				else if (i == 1 || i == 2)  // custom plant, custom harvest
				{
					iY = PaintDayModeCustomEvents(_customEventViewStates[i], container, mcPicker, iY);
				}
			}
			
			// add picker graphics last
			container.addChild(mcPicker);
		}
		
		private function PaintDayModeSingleEvent(event:DayEvent, container:MovieClip, y:int):int
		{
			var mcIcon:MovieClip = event.GetIcon();
			mcIcon.x = CalendarMenu.DAY_MODE_ICON_X_OFFSET;
			mcIcon.y = y;
			container.addChild(mcIcon);
			
			var sLongDescription:String = event.GetLongDescription();
			var oLabel:TextField = new TextField();
			oLabel.autoSize = TextFieldAutoSize.LEFT;
			oLabel.appendText(sLongDescription);
			oLabel.setTextFormat(_smallTextFormat);
			oLabel.x = CalendarMenu.DAY_MODE_TEXT_X_OFFSET;
			oLabel.y = y;
			container.addChild(oLabel);
			
			var iNewY:int = y + CalendarMenu.DAY_MODE_ICON_HEIGHT;
			return iNewY;
		}
		
		private function PaintDayModeMultiEvent(events:Array, container:MovieClip, y:int):int
		{
			if (events.length == 0)
			{
				return y;
			}
			
			var iY:int = y;
			
			for (var i:int = 0; i < events.length; i++)
			{
				var oEvent:DayEvent = DayEvent(events[i]);
				
				var mcIcon:MovieClip = oEvent.GetIcon();
				mcIcon.x = CalendarMenu.DAY_MODE_ICON_X_OFFSET;
				mcIcon.y = iY;
				container.addChild(mcIcon);
				
				var sLongDescription:String = oEvent.GetLongDescription();
				var oLabel:TextField = new TextField();
				oLabel.autoSize = TextFieldAutoSize.LEFT;
				oLabel.appendText(sLongDescription);
				oLabel.setTextFormat(_smallTextFormat);
				oLabel.x = CalendarMenu.DAY_MODE_TEXT_X_OFFSET;
				oLabel.y = iY;
				container.addChild(oLabel);
				
				iY += CalendarMenu.DAY_MODE_ICON_HEIGHT;
			}
			
			return iY;
		}
		
		private function PaintDayModeCoalesce(events:Array, container:MovieClip, y:int):int
		{
			if (events.length == 0)
			{
				return y;
			}
			
			var iY:int = y;
			var oEvent:DayEvent = DayEvent(events[0]);
			
			var mcIcon:MovieClip = oEvent.GetIcon();
			mcIcon.x = CalendarMenu.DAY_MODE_ICON_X_OFFSET;
			mcIcon.y = iY;
			container.addChild(mcIcon);
			
			if (oEvent is SaleCartSaleEvent)
			{
				var sLongDescription:String = SaleCartSaleEvent.GetCoalesceDescription(events);
			}
			else if (oEvent is ItemShopPurchaseEvent)
			{
				sLongDescription = ItemShopPurchaseEvent.GetCoalesceDescription(events);
			}
			else if (oEvent is ItemShopSaleEvent)
			{
				sLongDescription = ItemShopSaleEvent.GetCoalesceDescription(events);
			}
			
			var oLabel:TextField = new TextField();
			oLabel.autoSize = TextFieldAutoSize.LEFT;
			oLabel.appendText(sLongDescription);
			oLabel.setTextFormat(_smallTextFormat);
			oLabel.x = CalendarMenu.DAY_MODE_TEXT_X_OFFSET;
			oLabel.y = iY;
			container.addChild(oLabel);
			
			iY += CalendarMenu.DAY_MODE_ICON_HEIGHT;
			return iY;
		}
		
		private function PaintDayModeCustomEvents(customEventViewStates:Array, container:MovieClip, pickerGraphics:MovieClip, y:int):int
		{
			if (customEventViewStates.length == 0)
			{
				return y;
			}
			
			var iY:int = y;
			
			for (var i:int = 0; i < customEventViewStates.length; i++)
			{
				var oViewState:CustomDayEventViewState = CustomDayEventViewState(customEventViewStates[i]);
				var oEvent:CustomDayEvent = oViewState.event;
				var iX:int = CalendarMenu.DAY_MODE_TEXT_X_OFFSET;
				
				// icon
				var mcIcon:MovieClip = oEvent.GetIcon();
				mcIcon.x = CalendarMenu.DAY_MODE_ICON_X_OFFSET;
				mcIcon.y = iY;
				container.addChild(mcIcon);
				
				if (oViewState.mode == CustomDayEventViewState.MODE_READ)
				{
					var sLongDescription:String = oEvent.GetLongDescription();
					var oLabel:TextField = new TextField();
					oLabel.autoSize = TextFieldAutoSize.LEFT;
					oLabel.appendText(sLongDescription);
					oLabel.setTextFormat(_smallTextFormat);
					oLabel.x = CalendarMenu.DAY_MODE_TEXT_X_OFFSET;
					oLabel.y = iY;
					container.addChild(oLabel);
					
					var oEditButton:CustomEventButton = new CustomEventButton(this, CustomEventButton.TYPE_EDIT, oViewState);
					_customEventButtons.push(oEditButton);
					var mcEditButton:MovieClip = oEditButton.Paint();
					mcEditButton.x = CalendarMenu.CUSTOM_BUTTON_START_X;
					mcEditButton.y = iY + (CalendarMenu.DAY_MODE_ICON_HEIGHT / 2);
					container.addChild(mcEditButton);
				}
				else if (oViewState.mode == CustomDayEventViewState.MODE_EDIT)
				{
					for (var g:int = 0; g < oViewState.pickers.length; g++)
					{
						var oPicker:CustomEventPropertyPicker = CustomEventPropertyPicker(oViewState.pickers[g]);
						
						var mcPicker:MovieClip = oPicker.GetGraphics();
						mcPicker.x = iX;
						mcPicker.y = iY;
						pickerGraphics.addChild(mcPicker);
						
						iX += (oPicker.GetHeaderWidth() + 5);
					}
					
					var oSaveButton:CustomEventButton = new CustomEventButton(this, CustomEventButton.TYPE_SAVE, oViewState);
					_customEventButtons.push(oSaveButton);
					var mcSaveButton:MovieClip = oSaveButton.Paint();
					mcSaveButton.x = CalendarMenu.CUSTOM_BUTTON_START_X;
					mcSaveButton.y = iY + (CalendarMenu.DAY_MODE_ICON_HEIGHT / 2);
					container.addChild(mcSaveButton);
				}
				
				// delete button
				var oDeleteButton:CustomEventButton = new CustomEventButton(this, CustomEventButton.TYPE_DELETE, oViewState);
				_customEventButtons.push(oDeleteButton);
				var mcDeleteButton:MovieClip = oDeleteButton.Paint();
				mcDeleteButton.x = CalendarMenu.CUSTOM_BUTTON_START_X + CalendarMenu.CUSTOM_BUTTON_WIDTH;
				mcDeleteButton.y = iY + (CalendarMenu.DAY_MODE_ICON_HEIGHT / 2);
				container.addChild(mcDeleteButton);
				
				iY += CalendarMenu.DAY_MODE_ICON_HEIGHT;
			}
			
			return iY;
		}
		
		private function PaintMonthMode(container:MovieClip):void
		{
			container.addEventListener(MouseEvent.CLICK, OnMonthBackgroundClick, false, 0, true);
			
			var mcBackground:Calendar_Background_MC = new Calendar_Background_MC();
			mcBackground.x = 0;
			mcBackground.y = 0;
			container.addChild(mcBackground);
			
			if (_calendarState.time.useMonth == true)
			{
				mcBackground.Title.text = String(Time.MONTHS_LONG[_calendarState.calendarTime.month]);
			}
			else
			{
				mcBackground.Title.text = String(Time.SEASONS[_calendarState.calendarTime.month]);
			}
			
			var gridX:int = CalendarMenu.MONTH_MODE_GRID_X_OFFSET;
			var gridY:int = CalendarMenu.MONTH_MODE_GRID_Y_OFFSET;
			
			for (var iDate:int = 0; iDate < 28; iDate++)
			{
				var mcDay:MovieClip = PaintMonthModeDay(iDate, gridX, gridY);
				container.addChild(mcDay);
			}
			
			var mcLines:Calendar_Lines_MC = new Calendar_Lines_MC();
			mcLines.x = gridX;
			mcLines.y = gridY;
			container.addChild(mcLines);
			
			var oCalendarTime:Time = _calendarState.calendarTime;
			
			var bHasPreviousMonth:Boolean = TimeService.HasPreviousMonthThisYear(oCalendarTime);
			
			if (bHasPreviousMonth == true)
			{
				var btnLeftArrow:Calendar_ArrowLeft_Btn = new Calendar_ArrowLeft_Btn();
				btnLeftArrow.x = 258;
				btnLeftArrow.y = 29;
				btnLeftArrow.addEventListener(MouseEvent.CLICK, OnLeftArrowClick, false, 0, true);
				container.addChild(btnLeftArrow);
			}
			
			var bHasNextMonth:Boolean = TimeService.HasNextMonthThisYear(oCalendarTime);
			
			if (bHasNextMonth == true)
			{
				var btnRightArrow:Calendar_ArrowRight_Btn = new Calendar_ArrowRight_Btn();
				btnRightArrow.x = 462;
				btnRightArrow.y = 29;
				btnRightArrow.addEventListener(MouseEvent.CLICK, OnRightArrowClick, false, 0, true);
				container.addChild(btnRightArrow);
			}
			
			var btnDayMode:Calendar_DayModeDay_Btn = new Calendar_DayModeDay_Btn();
			btnDayMode.x = 670;
			btnDayMode.y = 28;
			btnDayMode.addEventListener(MouseEvent.CLICK, OnDayModeToggleClick, false, 0, true);
			container.addChild(btnDayMode);
			
			var mcDayModeToggle:Calendar_DayModeToggle_MC = new Calendar_DayModeToggle_MC();
			mcDayModeToggle.x = 630;
			mcDayModeToggle.y = 32;
			mcDayModeToggle.addEventListener(MouseEvent.CLICK, OnDayModeToggleClick, false, 0, true);
			container.addChild(mcDayModeToggle);
		}
		
		private function PaintMonthModeDay(date:int, gridXOffset:int, gridYOffset:int):MovieClip
		{
			var mcDay:MovieClip = new MovieClip();
			
			var gridHeight:int = 100;
			var gridWidth:int = 100;
			
			var iRow:int = Math.floor(date / 7);
			
			var iColumn:int = ((date + 1) % 7) - 1;
			if (iColumn == -1)
			{
				iColumn = 6;
			}
			
			var iGridX:int = gridXOffset + (iColumn * gridWidth);
			var iGridY:int = gridYOffset + (iRow * gridHeight);
			
			// current day highlight
			if (_calendarState.time.date == date && _calendarState.calendarTime.month == _calendarState.time.month)
			{
				var mcCurrentDay:Calendar_CurrentDayHighlight_MC = new Calendar_CurrentDayHighlight_MC();
				mcCurrentDay.x = iGridX;
				mcCurrentDay.y = iGridY;
				mcDay.addChild(mcCurrentDay);
			}
			
			// date number
			var oDateField:TextField = new TextField();
			oDateField.autoSize = TextFieldAutoSize.LEFT;
			oDateField.appendText(String(date + 1));
			oDateField.setTextFormat(_standardTextFormat);
			oDateField.x = iGridX + 5;
			oDateField.y = iGridY + 5;
			
			mcDay.addChild(oDateField);
			
			// weather icon
			var oDayTime:Time = _calendarState.time.GetClone();
			oDayTime.month = _calendarState.calendarTime.month;
			oDayTime.date = date;
			oDayTime.season = TimeService.GetSeasonForMonth(oDayTime);
			oDayTime.day = TimeService.GetDayForDate(oDayTime.date);
			
			var lWeatherEvents:Array = _calendarState.calendarStatTracker.GetEventsOfTypeForDay(DayEvent.TYPE_WEATHER, oDayTime);
			
			if (lWeatherEvents.length > 0)
			{
				var oWeatherEvent:WeatherEvent = WeatherEvent(lWeatherEvents[0]);
				
				var mcWeatherIcon:Calendar_WeatherIcon_MC = new Calendar_WeatherIcon_MC();
				mcWeatherIcon.gotoAndStop(oWeatherEvent.weatherType + 1);
				mcWeatherIcon.x = iGridX + gridWidth - 25;
				mcWeatherIcon.y = iGridY + 5;
				mcDay.addChild(mcWeatherIcon);
			}
			
			var iIconX:int = iGridX + 5;
			var iIconY:int = iGridY + 34;
			var iNumIcons:int = 0;
			var iMaxIcons:int = 3;
			var iIconWidth:int = 20;
			var iIconHeight:int = 20;
			
			var oSmallTextFormat:TextFormat = new TextFormat();
			oSmallTextFormat.font = "Arial";
			oSmallTextFormat.size = 12;
			oSmallTextFormat.color = CalendarMenu.TEXT_COLOR;
			
			var mcIcon:MovieClip = null;
			
			// csa icon
			if (iNumIcons < iMaxIcons)
			{
				var iCsaDayType:int = CsaService.GetCsaDayType(oDayTime);
				
				if (iCsaDayType == CsaState.DAY_TYPE_SIGNUP)
				{
					mcIcon = new Calendar_EventIcon_MC();
					mcIcon.gotoAndStop(5);
					
					var oLabel:TextField = new TextField();
					oLabel.autoSize = TextFieldAutoSize.LEFT;
					oLabel.appendText("Signup");
					oLabel.setTextFormat(_standardTextFormat);
				}
				else if (iCsaDayType == CsaState.DAY_TYPE_DELIVERY)
				{
					mcIcon = new Calendar_EventIcon_MC();
					mcIcon.gotoAndStop(6);
					
					oLabel = new TextField();
					oLabel.autoSize = TextFieldAutoSize.LEFT;
					oLabel.appendText("Delivery");
					oLabel.setTextFormat(_standardTextFormat);
				}
				
				if (mcIcon != null)
				{
					mcIcon.x = iIconX;
					mcIcon.y = iIconY;
					mcDay.addChild(mcIcon);
					
					oLabel.setTextFormat(oSmallTextFormat);
					oLabel.x = iIconX + iIconWidth + 5;
					oLabel.y = iIconY;
					mcDay.addChild(oLabel);
					
					iNumIcons++;
					iIconY += (iIconHeight + 2);
				}
			}
			
			// future harvest icon
			if (iNumIcons < iMaxIcons)
			{
				var lFutureHarvestEvents:Array = _calendarState.calendarStatTracker.GetEventsOfTypeForDay(DayEvent.TYPE_FUTURE_HARVEST, oDayTime);
				
				if (lFutureHarvestEvents.length > 0)
				{
					var iHarvestEvents:int = 0;
					
					for (var iEvent:int = 0; iEvent < lFutureHarvestEvents.length; iEvent++)
					{
						var oFutureHarvestEvent:FutureHarvestEvent = FutureHarvestEvent(lFutureHarvestEvents[iEvent]);
						
						iHarvestEvents += oFutureHarvestEvent.occurrences;
					}
					
					mcIcon = new Calendar_EventIcon_MC();

					mcIcon.gotoAndStop(2);
					mcIcon.x = iIconX;
					mcIcon.y = iIconY;
					mcDay.addChild(mcIcon);
					
					oLabel = new TextField();
					oLabel.autoSize = TextFieldAutoSize.LEFT;
					oLabel.appendText("x " + String(iHarvestEvents));
					oLabel.setTextFormat(oSmallTextFormat);
					oLabel.x = iIconX + iIconWidth + 5;
					oLabel.y = iIconY;
					mcDay.addChild(oLabel);
					
					iNumIcons++;
					iIconY += (iIconHeight + 2);
				}
			}
			
			// seed planted icon
			if (iNumIcons < iMaxIcons)
			{
				var lSeedPlantedEvents:Array = _calendarState.calendarStatTracker.GetEventsOfTypeForDay(DayEvent.TYPE_SEED_PLANTED, oDayTime);
				var lCustomPlantEvents:Array = _calendarState.calendarStatTracker.GetEventsOfTypeForDay(DayEvent.TYPE_CUSTOM_PLANT, oDayTime);
				lSeedPlantedEvents = lSeedPlantedEvents.concat(lCustomPlantEvents);
				
				if (lSeedPlantedEvents.length > 0)
				{
					var iSeedsPlanted:int = 0;
					
					for (iEvent = 0; iEvent < lSeedPlantedEvents.length; iEvent++)
					{
						var oEvent:DayEvent = DayEvent(lSeedPlantedEvents[iEvent]);
						
						iSeedsPlanted += oEvent.occurrences;
					}
					
					mcIcon = new Calendar_EventIcon_MC();
					mcIcon.gotoAndStop(1);
					mcIcon.x = iIconX;
					mcIcon.y = iIconY;
					mcDay.addChild(mcIcon);
					
					oLabel = new TextField();
					oLabel.autoSize = TextFieldAutoSize.LEFT;
					oLabel.appendText("x " + String(iSeedsPlanted));
					oLabel.setTextFormat(oSmallTextFormat);
					oLabel.x = iIconX + iIconWidth + 5;
					oLabel.y = iIconY;
					mcDay.addChild(oLabel);
					
					iNumIcons++;
					iIconY += (iIconHeight + 2);
				}
			}
			
			// fruit harvested icon
			if (iNumIcons < iMaxIcons)
			{
				var lFruitHarvestedEvents:Array = _calendarState.calendarStatTracker.GetEventsOfTypeForDay(DayEvent.TYPE_FRUIT_HARVESTED, oDayTime);
				var lCustomHarvestEvents:Array = _calendarState.calendarStatTracker.GetEventsOfTypeForDay(DayEvent.TYPE_CUSTOM_HARVEST, oDayTime);
				lFruitHarvestedEvents = lFruitHarvestedEvents.concat(lCustomHarvestEvents);
				
				if (lFruitHarvestedEvents.length > 0)
				{
					var iFruitHarvested:int = 0;
					
					for (iEvent = 0; iEvent < lFruitHarvestedEvents.length; iEvent++)
					{
						oEvent = DayEvent(lFruitHarvestedEvents[iEvent]);
						
						iFruitHarvested += oEvent.occurrences;
					}
					
					mcIcon = new Calendar_EventIcon_MC();
					mcIcon.gotoAndStop(2);
					mcIcon.x = iIconX;
					mcIcon.y = iIconY;
					mcDay.addChild(mcIcon);
					
					oLabel = new TextField();
					oLabel.autoSize = TextFieldAutoSize.LEFT;
					oLabel.appendText("x " + String(iFruitHarvested));
					oLabel.setTextFormat(oSmallTextFormat);
					oLabel.x = iIconX + iIconWidth + 5;
					oLabel.y = iIconY;
					mcDay.addChild(oLabel);
					
					iNumIcons++;
					iIconY += (iIconHeight + 2);
				}
			}
			
			// fruit sold icon
			if (iNumIcons < iMaxIcons)
			{
				var lSaleCartSaleEvents:Array = _calendarState.calendarStatTracker.GetEventsOfTypeForDay(DayEvent.TYPE_SALE_CART_SALE, oDayTime);
				
				if (lSaleCartSaleEvents.length > 0)
				{
					var iSaleCartSales:int = 0;
					
					for (iEvent = 0; iEvent < lSaleCartSaleEvents.length; iEvent++)
					{
						var oSaleCartSaleEvent:SaleCartSaleEvent = SaleCartSaleEvent(lSaleCartSaleEvents[iEvent]);
						
						iSaleCartSales += oSaleCartSaleEvent.occurrences;
					}
					
					mcIcon = new Calendar_EventIcon_MC();
					mcIcon.gotoAndStop(3);
					mcIcon.x = iIconX;
					mcIcon.y = iIconY;
					mcDay.addChild(mcIcon);
					
					oLabel = new TextField();
					oLabel.autoSize = TextFieldAutoSize.LEFT;
					oLabel.appendText("x " + String(iSaleCartSales));
					oLabel.setTextFormat(oSmallTextFormat);
					oLabel.x = iIconX + iIconWidth + 5;
					oLabel.y = iIconY;
					mcDay.addChild(oLabel);
					
					iNumIcons++;
					iIconY += (iIconHeight + 2);
				}
			}
			
			// plant killed icon
			if (iNumIcons < iMaxIcons)
			{
				var lPlantKilledEvents:Array = _calendarState.calendarStatTracker.GetEventsOfTypeForDay(DayEvent.TYPE_PLANT_KILLED, oDayTime);
				
				if (lPlantKilledEvents.length > 0)
				{
					var iPlantsKilled:int = 0;
					
					for (iEvent = 0; iEvent < lPlantKilledEvents.length; iEvent++)
					{
						var oPlantKilledEvent:PlantKilledEvent = PlantKilledEvent(lPlantKilledEvents[iEvent]);
						
						iPlantsKilled += oPlantKilledEvent.occurrences;
					}
					
					mcIcon = new Calendar_EventIcon_MC();
					mcIcon.gotoAndStop(4);
					mcIcon.x = iIconX;
					mcIcon.y = iIconY;
					mcDay.addChild(mcIcon);
					
					oLabel = new TextField();
					oLabel.autoSize = TextFieldAutoSize.LEFT;
					oLabel.appendText("x " + String(iPlantsKilled));
					oLabel.setTextFormat(oSmallTextFormat);
					oLabel.x = iIconX + iIconWidth + 5;
					oLabel.y = iIconY;
					mcDay.addChild(oLabel);
					
					iNumIcons++;
					iIconY += (iIconHeight + 2);
				}
			}
			
			return mcDay;
		}
		
		///- Graphics -///
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}