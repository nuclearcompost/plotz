package
{
	//-----------------------
	//Purpose:				An organized collection of DayEvents
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class CalendarStatTracker
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get events():Array
		{
			return _events;
		}
		
		public function set events(value:Array):void
		{
			_events = value;
		}
		
		public function get gameTime():Time
		{
			return _gameTime;
		}
		
		public function set gameTime(value:Time):void
		{
			_gameTime = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		var _events:Array;
		var _gameTime:Time;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CalendarStatTracker(gameTime:Time = null, events:Array = null)
		{
			_gameTime = gameTime;
			if (_gameTime == null)
			{
				_gameTime = new Time(0, 0, 0, 0, 0, 0, false);
			}
			
			_events = events;
			if (_events == null)
			{
				_events = new Array();
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		// adds the given event at the event's time
		public function AddEvent(event:DayEvent):void
		{
			if (event == null)
			{
				return;
			}
			
			if (event.time == null)
			{
				return;
			}
			
			AddOrIncrementEvent(event);
		}
		
		// adds the given event, ignoring the event's time and replacing it with the current game time
		public function AddEventToday(event:DayEvent):void
		{
			if (event == null)
			{
				return;
			}
			
			event.time = _gameTime.GetClone();
			
			AddOrIncrementEvent(event);
		}
		
		public function ClearAllEventsOfType(eventType:int):void
		{
			if (eventType < 0)
			{
				return;
			}
			
			if (eventType > DayEvent.MAX_TYPE)
			{
				return;
			}
			
			for (var i:int = 0; i < _events.length; i++)
			{
				var oObject:Object = _events[i];
				
				if (oObject == null)
				{
					continue;
				}
				
				if (!(oObject is DayEvent))
				{
					continue;
				}
				
				var oDayEvent:DayEvent = DayEvent(oObject);
				
				if (oDayEvent.eventType == eventType)
				{
					_events.splice(i, 1);
					i--;
				}
			}
		}
		
		public function ClearCustomEventsForDay(time:Time):void
		{
			if (time == null)
			{
				return;
			}
			
			var lEvents:Array = this.GetAllEventsForDay(time);
			
			for (var i:int = 0; i < lEvents.length; i++)
			{
				var oEvent:DayEvent = DayEvent(lEvents[i]);
				
				if (oEvent is CustomDayEvent)
				{
					var oCustomDayEvent:CustomDayEvent = CustomDayEvent(oEvent);
					var lLinkedEvents:Array = oCustomDayEvent.GetLinkedEvents();
					
					for (var j:int = 0; j < lLinkedEvents.length; j++)
					{
						var oLinkedEvent:DayEvent = DayEvent(lLinkedEvents[j]);
						this.RemoveEvent(oLinkedEvent);
					}
					
					this.RemoveEvent(oEvent);
				}
			}
		}
		
		// return a list of all events for a given day
		public function GetAllEventsForDay(time:Time):Array
		{
			if (time == null)
			{
				return new Array();
			}
			
			var lEvents:Array = new Array();
			
			for (var i:int = 0; i < _events.length; i++)
			{
				var oEvent:DayEvent = DayEvent(_events[i]);
				
				if (oEvent.time.IsSameDay(time) == false)
				{
					continue;
				}
				
				lEvents.push(oEvent);
			}
			
			return lEvents;
		}
		
		// return a list of all events of a given type for a given day
		public function GetEventsOfTypeForDay(eventType:int, time:Time):Array
		{
			if (eventType < 0)
			{
				return new Array();
			}
			
			if (eventType > DayEvent.MAX_TYPE)
			{
				return new Array();
			}
			
			if (time == null)
			{
				return new Array();
			}
			
			var lEvents:Array = new Array();
			
			for (var i:int = 0; i < _events.length; i++)
			{
				var oEvent:DayEvent = DayEvent(_events[i]);
				
				if (oEvent.time.IsSameDay(time) == false)
				{
					continue;
				}
				
				if (oEvent.eventType == eventType)
				{
					lEvents.push(oEvent);
				}
			}
			
			return lEvents;
		}
		
		public function GetEventsForCalendarDayMode(time:Time):Array
		{
			if (time == null)
			{
				return new Array();
			}
			
			var lEvents:Array = new Array(DayEvent.MAX_TYPE + 1);
			for (var i:int = 0; i < lEvents.length; i++)
			{
				lEvents[i] = new Array();
			}
			
			for (i = 0; i < _events.length; i++)
			{
				var oEvent:DayEvent = DayEvent(_events[i]);
				
				if (oEvent.time.IsSameDay(time) == false)
				{
					continue;
				}
				
				var iEventType:int = oEvent.eventType;
				var iIndex:int = CalendarMenu.DAY_MODE_EVENT_TYPE_INDEX[iEventType];
				
				lEvents[iIndex].push(oEvent);
			}
			
			return lEvents;
		}
		
		public function RemoveEvent(event:DayEvent):void
		{
			if (event == null)
			{
				return;
			}
			
			for (var i:int = 0; i < _events.length; i++)
			{
				var oEvent:DayEvent = DayEvent(_events[i]);
				
				if (oEvent == event)
				{
					_events.splice(i, 1);
					break;
				}
				
				/*
				if (oEvent.Equals(event) == true && oEvent.time.IsSameDay(event.time))
				{
					_events.splice(i, 1);
					break;
				}
				*/
			}
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function AddOrIncrementEvent(event:DayEvent):void
		{
			var lExistingEvents:Array = GetEventsOfTypeForDay(event.eventType, event.time);
			
			var oMatch:DayEvent = null;
			
			for (var i:int = 0; i < lExistingEvents.length; i++)
			{
				var oEvent:DayEvent = DayEvent(lExistingEvents[i]);
				
				if (oEvent.Equals(event) == true)
				{
					oMatch = oEvent;
					break;
				}
			}
			
			if (oMatch != null)
			{
				oMatch.occurrences++;
			}
			else
			{
				_events.push(event);
			}
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(CalendarStatTracker.AddEventOkIfEventNull());
			lResults.push(CalendarStatTracker.AddEventDoesNothingIfEventNull());
			lResults.push(CalendarStatTracker.AddEventOkIfTimeNull());
			lResults.push(CalendarStatTracker.AddEventAddsNewEvent());
			lResults = lResults.concat(CalendarStatTracker.AddEventIncrementsOccurrencesOfExistingEvent());
			
			lResults.push(CalendarStatTracker.AddEventTodayOkIfEventNull());
			lResults.push(CalendarStatTracker.AddEventTodayDoesNothingIfEventNull());
			lResults.push(CalendarStatTracker.AddEventTodayAddsNewEvent());
			lResults.push(CalendarStatTracker.AddEventTodaySetsNewEventTimeToGameTime());
			lResults = lResults.concat(CalendarStatTracker.AddEventTodayIncrementsOccurrencesOfExistingEvent());
			
			lResults.push(CalendarStatTracker.ClearAllEventsOfTypeDoesNothingForTooSmallEventType());
			lResults.push(CalendarStatTracker.ClearAllEventsOfTypeDoesNothingForTooLargeEventType());
			lResults = lResults.concat(CalendarStatTracker.ClearAllEventsOfTypeClearsEventsForType());
			
			lResults.push(CalendarStatTracker.ClearCustomEventsForDayOkIfTimeNull());
			lResults.push(CalendarStatTracker.ClearCustomEventsForDayOkIfNoEventsToClear());
			lResults.push(CalendarStatTracker.ClearCustomEventsForDayClearsEventsForDay());
			lResults.push(CalendarStatTracker.ClearCustomEventsForDayClearsRelatedEvents());
			lResults.push(CalendarStatTracker.ClearCustomEventsForDayKeepsOtherEvents());
			
			lResults.push(CalendarStatTracker.GetAllEventsForDayEmptyIfTimeNull());
			lResults.push(CalendarStatTracker.GetAllEventsForDayEmptyIfNoEvents());
			lResults = lResults.concat(CalendarStatTracker.GetAllEventsForDayReturnsEventList());
			
			lResults.push(CalendarStatTracker.GetEventsOfTypeForDayEmptyIfEventTypeTooSmall());
			lResults.push(CalendarStatTracker.GetEventsOfTypeForDayEmptyIfEventTypeTooLarge());
			lResults.push(CalendarStatTracker.GetEventsOfTypeForDayEmptyIfTimeNull());
			lResults.push(CalendarStatTracker.GetEventsOfTypeForDayEmptyIfNoEvents());
			lResults = lResults.concat(CalendarStatTracker.GetEventsOfTypeForDayReturnsEventList());
			
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeEmptyIfTimeNull());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeEmptyIfNoEvents());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeReturnsWeatherEventsAtProperIndex());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeReturnsPlantKilledEventsAtProperIndex());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeReturnsCustomPlantEventsAtProperIndex());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeReturnsCustomHarvestEventsAtProperIndex());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeReturnsSaleCartSaleEventsAtProperIndex());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeReturnsFutureHarvestEventsAtProperIndex());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeReturnsSeedPlantedEventsAtProperIndex());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeReturnsFruitHarvestedEventsAtProperIndex());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeReturnsItemShopPurchaseEventsAtProperIndex());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeReturnsItemShopSaleEventsAtProperIndex());
			lResults.push(CalendarStatTracker.GetEventsForCalendarDayModeReturnsWellAmountEventsAtProperIndex());
			
			lResults.push(CalendarStatTracker.RemoveEventOkIfEventNull());
			lResults.push(CalendarStatTracker.RemoveEventRemovesMatchingEvent());
			lResults.push(CalendarStatTracker.RemoveEventLeavesEventOfDifferentType());
			lResults.push(CalendarStatTracker.RemoveEventLeavesEventOfDifferentDay());
			
			return lResults;
		}
		
		private static function AddEventOkIfEventNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventOkIfEventNull");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:DayEvent = null;
			
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			try
			{
				oTracker.AddEvent(oEvent);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function AddEventDoesNothingIfEventNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventDoesNothingIfEventNull");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:DayEvent = null;
			
			oTracker.AddEvent(oEvent);
			
			oResult.expected = "0";
			oResult.actual = String(oTracker.events.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function AddEventOkIfTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventOkIfTimeNull");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:DayEvent = new WeatherEvent(Weather.TYPE_HOT, null);
			
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			try
			{
				oTracker.AddEvent(oEvent);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function AddEventAddsNewEvent():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventAddsNewEvent");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oNewTime:Time = new Time(1, 1, 1, 1, 1, 1, false);
			var oEvent:DayEvent = new WeatherEvent(Weather.TYPE_HOT, oTime);
			var oNewEvent:DayEvent = new WeatherEvent(Weather.TYPE_HOT, oNewTime);
			oTracker.events.push(oEvent);
			
			oTracker.AddEvent(oNewEvent);
			
			oResult.expected = "2";
			oResult.actual = String(oTracker.events.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function AddEventIncrementsOccurrencesOfExistingEvent():Array
		{
			var oNumEventsResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventIncrementsOccurrencesOfExistingEvent - Number of Events");
			var oNumOccurrencesResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventIncrementsOccurrencesOfExistingEvent - Number of Occurrences");
			var lResults:Array = [ oNumEventsResult, oNumOccurrencesResult ];
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oEvent:DayEvent = new SeedPlantedEvent(Seed.TYPE_ASPARAGUS, oTime, 1);
			var oNewEvent:DayEvent = new SeedPlantedEvent(Seed.TYPE_ASPARAGUS, oTime);
			oTracker.events.push(oEvent);
			
			oTracker.AddEvent(oNewEvent);
			
			oNumEventsResult.expected = "1";
			oNumEventsResult.actual = String(oTracker.events.length);
			oNumEventsResult.TestEquals();
			
			oNumOccurrencesResult.expected = "2";
			if (oTracker.events.length > 0)
			{
				var oObject:Object = oTracker.events[0];
				
				if (oObject is DayEvent)
				{
					var oFirstEvent:DayEvent = DayEvent(oObject);
					
					oNumOccurrencesResult.actual = String(oFirstEvent.occurrences);
				}
				else
				{
					oNumOccurrencesResult.actual = "Object was not a DayEvent";
				}
			}
			else
			{
				oNumOccurrencesResult.actual = "no events";
			}
			oNumOccurrencesResult.TestEquals();
			
			return lResults;
		}
		
		private static function AddEventTodayOkIfEventNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventTodayOkIfEventNull");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:DayEvent = null;
			
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			try
			{
				oTracker.AddEventToday(oEvent);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function AddEventTodayDoesNothingIfEventNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventTodayDoesNothingIfEventNull");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:DayEvent = null;
			
			oTracker.AddEventToday(oEvent);
			
			oResult.expected = "0";
			oResult.actual = String(oTracker.events.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function AddEventTodayAddsNewEvent():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventTodayAddsNewEvent");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:DayEvent = new WeatherEvent(Weather.TYPE_HOT);
			
			oTracker.AddEventToday(oEvent);
			
			oResult.expected = "1";
			oResult.actual = String(oTracker.events.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function AddEventTodaySetsNewEventTimeToGameTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventTodaySetsNewEventTimeToGameTime");
			var oGameTime:Time = new Time(1, 1, 1, 1, 1, 1, true);
			var oTracker:CalendarStatTracker = new CalendarStatTracker(oGameTime);
			var oEvent:DayEvent = new WeatherEvent(Weather.TYPE_HOT);
			
			oTracker.AddEventToday(oEvent);
			
			oResult.TestTrue(oGameTime.IsSameDay(oEvent.time));
			
			return oResult;
		}
		
		private static function AddEventTodayIncrementsOccurrencesOfExistingEvent():Array
		{
			var oNumEventsResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventTodayIncrementsOccurrencesOfExistingEvent - Number of Events");
			var oNumOccurrencesResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "AddEventTodayIncrementsOccurrencesOfExistingEvent - Number of Occurrences");
			var lResults:Array = [ oNumEventsResult, oNumOccurrencesResult ];
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oTracker:CalendarStatTracker = new CalendarStatTracker(oTime);
			var oEvent:DayEvent = new SeedPlantedEvent(Seed.TYPE_ASPARAGUS, oTime, 1);
			var oNewEvent:DayEvent = new SeedPlantedEvent(Seed.TYPE_ASPARAGUS, oTime);
			oTracker.events.push(oEvent);
			
			oTracker.AddEvent(oNewEvent);
			
			oNumEventsResult.expected = "1";
			oNumEventsResult.actual = String(oTracker.events.length);
			oNumEventsResult.TestEquals();
			
			oNumOccurrencesResult.expected = "2";
			if (oTracker.events.length > 0)
			{
				var oObject:Object = oTracker.events[0];
				
				if (oObject is DayEvent)
				{
					var oFirstEvent:DayEvent = DayEvent(oObject);
					
					oNumOccurrencesResult.actual = String(oFirstEvent.occurrences);
				}
				else
				{
					oNumOccurrencesResult.actual = "Object was not a DayEvent";
				}
			}
			else
			{
				oNumOccurrencesResult.actual = "no events";
			}
			oNumOccurrencesResult.TestEquals();
			
			return lResults;
		}
		
		private static function ClearAllEventsOfTypeDoesNothingForTooSmallEventType():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "ClearAllEventsOfTypeDoesNothingForTooSmallEventType");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:WeatherEvent = new WeatherEvent(Weather.TYPE_HOT);
			oTracker.events.push(oEvent);
			
			oTracker.ClearAllEventsOfType(-1);
			
			oResult.expected = "1";
			oResult.actual = String(oTracker.events.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ClearAllEventsOfTypeDoesNothingForTooLargeEventType():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "ClearAllEventsOfTypeDoesNothingForTooLargeEventType");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:WeatherEvent = new WeatherEvent(Weather.TYPE_HOT);
			oTracker.events.push(oEvent);
			
			oTracker.ClearAllEventsOfType(DayEvent.MAX_TYPE + 1);
			
			oResult.expected = "1";
			oResult.actual = String(oTracker.events.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ClearAllEventsOfTypeClearsEventsForType():Array
		{
			var oNumEntriesResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "ClearAllEventsOfTypeClearsEventsForType - Number of entries");
			var oEntry1Result:UnitTestResult = new UnitTestResult("CalendarStatTracker", "ClearAllEventsOfTypeClearsEventsForType - Entry 1");
			var lResults = [ oNumEntriesResult, oEntry1Result ];
			
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oWeatherEvent:WeatherEvent = new WeatherEvent(Weather.TYPE_HOT);
			oTracker.events.push(oWeatherEvent);
			var oSeedPlantedEvent:SeedPlantedEvent = new SeedPlantedEvent(Seed.TYPE_ASPARAGUS);
			oTracker.events.push(oSeedPlantedEvent);
			
			oTracker.ClearAllEventsOfType(DayEvent.TYPE_WEATHER);
			
			oNumEntriesResult.expected = "1";
			oNumEntriesResult.actual = String(oTracker.events.length);
			oNumEntriesResult.TestEquals();
			
			oEntry1Result.expected = String(DayEvent.TYPE_SEED_PLANTED);
			oEntry1Result.actual = "no events";
			
			if (oTracker.events.length > 0)
			{
				var oEvent:DayEvent = DayEvent(oTracker.events[0]);
				oEntry1Result.actual = String(oEvent.eventType);
			}
			
			oEntry1Result.TestEquals();			
			
			return lResults;
		}
	
		private static function ClearCustomEventsForDayOkIfTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "ClearCustomEventsForDayOkIfTimeNull");
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = null;
			
			try
			{
				oTracker.ClearCustomEventsForDay(oTime);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ClearCustomEventsForDayOkIfNoEventsToClear():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "ClearCustomEventsForDayOkIfNoEventsToClear");
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			try
			{
				oTracker.ClearCustomEventsForDay(oTime);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ClearCustomEventsForDayClearsEventsForDay():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "ClearCustomEventsForDayClearsEventsForDay");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			oTracker.AddEventToday(new CustomPlantEvent(Plant.TYPE_CARROT));
			oTracker.AddEventToday(new CustomHarvestEvent(Fruit.TYPE_POTATO));
			
			oTracker.ClearCustomEventsForDay(oTime);
			
			var lEvents:Array = oTracker.GetAllEventsForDay(oTime);
			
			oResult.expected = "No events";
			
			if (lEvents.length == 0)
			{
				oResult.actual = "No events";
			}
			else
			{
				oResult.actual = DayEvent.PrettyPrintList(lEvents);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ClearCustomEventsForDayClearsRelatedEvents():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "ClearCustomEventsForDayClearsRelatedEvents");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oCalendarState:CalendarState = new CalendarState(new Time(0, 0, 0, 0, 0, 0, false), oTracker, new Time(0, 0, 0, 0, 0, 0, false));
			var oRelatedTime:Time = oTime.GetClone();
			var iDaysToHarvest:int = Plant.GetDaysToHarvest(Plant.TYPE_ASPARAGUS);
			for (var i:int = 0; i < iDaysToHarvest; i++)
			{
				TimeService.AdvanceDate(oRelatedTime);
			}
			
			var oBaseEvent:CustomDayEvent = CalendarService.GetDefaultCustomEvent(oTime);
			var lLinkedEvents:Array = oBaseEvent.GetLinkedEvents();
			oTracker.events.push(oBaseEvent);
			for (i = 0; i < lLinkedEvents.length; i++)
			{
				var oLinkedEvent:CustomDayEvent = CustomDayEvent(lLinkedEvents[i]);
				oTracker.events.push(oLinkedEvent);
			}
			
			oTracker.ClearCustomEventsForDay(oTime);
			
			var lEvents:Array = oTracker.GetAllEventsForDay(oRelatedTime);
			
			oResult.expected = "No events";
			
			if (lEvents.length == 0)
			{
				oResult.actual = "No events";
			}
			else
			{
				oResult.actual = DayEvent.PrettyPrintList(lEvents);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ClearCustomEventsForDayKeepsOtherEvents():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "ClearCustomEventsForDayKeepsOtherEvents");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oWeatherEvent:WeatherEvent = new WeatherEvent(Weather.TYPE_CLOUD);
			var oSeedPlantedEvent:SeedPlantedEvent = new SeedPlantedEvent(Plant.TYPE_LETTUCE);
			oTracker.AddEventToday(oWeatherEvent);
			oTracker.AddEventToday(new CustomPlantEvent(Plant.TYPE_CARROT));
			oTracker.AddEventToday(new CustomHarvestEvent(Fruit.TYPE_POTATO));
			oTracker.AddEventToday(oSeedPlantedEvent);
			var lExpectedEvents:Array = [ oWeatherEvent, oSeedPlantedEvent ];
			
			oTracker.ClearCustomEventsForDay(oTime);
			
			var lEvents:Array = oTracker.GetAllEventsForDay(oTime);
			
			oResult.expected = DayEvent.PrettyPrintList(lExpectedEvents);
			
			if (lEvents.length == 0)
			{
				oResult.actual = "No events";
			}
			else
			{
				oResult.actual = DayEvent.PrettyPrintList(lEvents);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetAllEventsForDayEmptyIfTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetAllEventsForDayEmptyIfTimeNull");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = null;
			
			var lActual:Array = oTracker.GetAllEventsForDay(oTime);
			
			oResult.expected = "0";
			oResult.actual = String(lActual.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetAllEventsForDayEmptyIfNoEvents():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetAllEventsForDayEmptyIfNoEvents");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = new Time();
			
			var lActual:Array = oTracker.GetAllEventsForDay(oTime);
			
			oResult.expected = "0";
			oResult.actual = String(lActual.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetAllEventsForDayReturnsEventList():Array
		{
			var oNumEventsResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetAllEventsForDayReturnsEventList - Number of events");
			var oCorrectEvent1Result:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetAllEventsForDayReturnsEventList - Correct event 1");
			var lResults:Array = [ oNumEventsResult, oCorrectEvent1Result ];
			
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oTime2:Time = new Time(1, 1, 1, 1, 1, 1, false);
			
			oTracker.events.push(new WeatherEvent(Weather.TYPE_HOT, oTime));
			oTracker.events.push(new WeatherEvent(Weather.TYPE_RAIN, oTime2));
			
			var lActual:Array = oTracker.GetAllEventsForDay(oTime);
			
			oNumEventsResult.expected = "1";
			oNumEventsResult.actual = String(lActual.length);
			oNumEventsResult.TestEquals();
			
			if (lActual.length > 0)
			{
				var oObject:Object = lActual[0];
				
				if (oObject is WeatherEvent)
				{
					var oWeatherEvent:WeatherEvent = WeatherEvent(oObject);
					
					oCorrectEvent1Result.expected = String(Weather.TYPE_HOT);
					oCorrectEvent1Result.actual = String(oWeatherEvent.weatherType);
					oCorrectEvent1Result.TestEquals();
				}
			}
			
			return lResults;
		}
		
		private static function GetEventsOfTypeForDayEmptyIfEventTypeTooSmall():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsOfTypeForDayEmptyIfEventTypeTooSmall");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = new Time();
			var iEventType:int = -1;
			
			var lActual:Array = oTracker.GetEventsOfTypeForDay(iEventType, oTime);
			
			oResult.expected = "0";
			oResult.actual = String(lActual.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsOfTypeForDayEmptyIfEventTypeTooLarge():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsOfTypeForDayEmptyIfEventTypeTooLarge");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = new Time();
			var iEventType:int = DayEvent.MAX_TYPE + 1;
			
			var lActual:Array = oTracker.GetEventsOfTypeForDay(iEventType, oTime);
			
			oResult.expected = "0";
			oResult.actual = String(lActual.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsOfTypeForDayEmptyIfTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsOfTypeForDayEmptyIfTimeNull");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = null;
			var iEventType:int = DayEvent.TYPE_WEATHER;
			
			var lActual:Array = oTracker.GetEventsOfTypeForDay(iEventType, oTime);
			
			oResult.expected = "0";
			oResult.actual = String(lActual.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsOfTypeForDayEmptyIfNoEvents():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsOfTypeForDayEmptyIfNoEvents");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = new Time();
			var iEventType:int = DayEvent.TYPE_WEATHER;
			
			var lActual:Array = oTracker.GetEventsOfTypeForDay(iEventType, oTime);
			
			oResult.expected = "0";
			oResult.actual = String(lActual.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsOfTypeForDayReturnsEventList():Array
		{
			var oNumEventsResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsOfTypeForDayReturnsEventList - Number of events");
			var oCorrectEvent1Result:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsOfTypeForDayReturnsEventList - Correct Event 1");
			var lResults:Array = [ oNumEventsResult, oCorrectEvent1Result ];
			
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oTracker.events.push(new WeatherEvent(Weather.TYPE_HOT, oTime));
			oTracker.events.push(new SeedPlantedEvent(Seed.TYPE_ASPARAGUS, oTime, 1));
			
			var lEvents:Array = oTracker.GetEventsOfTypeForDay(DayEvent.TYPE_WEATHER, oTime);
			
			oNumEventsResult.expected = "1";
			oNumEventsResult.actual = String(lEvents.length);
			oNumEventsResult.TestEquals();
			
			oCorrectEvent1Result.expected = "WeatherEvent";
			if (lEvents.length > 0)
			{
				var oObject:Object = lEvents[0];
				
				if (oObject is WeatherEvent)
				{
					oCorrectEvent1Result.actual = "WeatherEvent";
				}
				else
				{
					oCorrectEvent1Result.actual = "Not a weather event";
				}
			}
			else
			{
				oCorrectEvent1Result.actual = "No events";
			}
			oCorrectEvent1Result.TestEquals();
			
			return lResults;
		}
		
		private static function GetEventsForCalendarDayModeEmptyIfTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeEmptyIfTimeNull");
			var oTime:Time = null;
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			
			oResult.expected = "Array of length 0";
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			oResult.actual = "Array of length " + String(lEvents.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeEmptyIfNoEvents():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeEmptyIfNoEvents");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			oCalendarStatTracker.AddEvent(new SeedPlantedEvent(Plant.TYPE_ASPARAGUS, new Time(0, 1, 0, 0, 1, 0, false), 2));
			
			oResult.expected = "";
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			oResult.actual = DayEvent.PrettyPrintList(lEvents);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeReturnsWeatherEventsAtProperIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeReturnsWeatherEventsAtProperIndex");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			var oWeatherEvent1:WeatherEvent = new WeatherEvent(Weather.TYPE_HOT, new Time(0, 0, 0, 0, 0, 0, false));
			var oWeatherEvent2:WeatherEvent = new WeatherEvent(Weather.TYPE_SUN, new Time(0, 0, 0, 0, 0, 0, false));
			
			oCalendarStatTracker.AddEvent(new SeedPlantedEvent(Plant.TYPE_ASPARAGUS, new Time(0, 0, 0, 0, 0, 0, false), 2));
			oCalendarStatTracker.AddEvent(new WeatherEvent(Weather.TYPE_CLOUD, new Time(0, 1, 0, 0, 1, 0, false)));
			oCalendarStatTracker.AddEvent(oWeatherEvent1);
			oCalendarStatTracker.AddEvent(oWeatherEvent2);
			
			var lExpected:Array = [ oWeatherEvent1, oWeatherEvent2 ];
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			var lActual:Array = lEvents[0];
			
			oResult.expected = DayEvent.PrettyPrintList(lExpected);
			oResult.actual = DayEvent.PrettyPrintList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeReturnsCustomPlantEventsAtProperIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeReturnsCustomPlantEventsAtProperIndex");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent1:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_ASPARAGUS, new Time(0, 0, 0, 0, 0, 0, false), 2);
			var oEvent2:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_LETTUCE, new Time(0, 0, 0, 0, 0, 0, false));
			
			oCalendarStatTracker.AddEvent(new WeatherEvent(Weather.TYPE_HOT, new Time(0, 0, 0, 0, 0, 0, false)));
			oCalendarStatTracker.AddEvent(new CustomPlantEvent(Plant.TYPE_CARROT, new Time(0, 1, 0, 0, 1, 0, false)));
			oCalendarStatTracker.AddEvent(oEvent1);
			oCalendarStatTracker.AddEvent(oEvent2);
			
			var lExpected:Array = [ oEvent1, oEvent2 ];
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			var lActual:Array = lEvents[1];
			
			oResult.expected = DayEvent.PrettyPrintList(lExpected);
			oResult.actual = DayEvent.PrettyPrintList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeReturnsCustomHarvestEventsAtProperIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeReturnsCustomHarvestEventsAtProperIndex");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent1:CustomHarvestEvent = new CustomHarvestEvent(Plant.TYPE_ASPARAGUS, new Time(0, 0, 0, 0, 0, 0, false), 2);
			var oEvent2:CustomHarvestEvent = new CustomHarvestEvent(Plant.TYPE_LETTUCE, new Time(0, 0, 0, 0, 0, 0, false));
			
			oCalendarStatTracker.AddEvent(new WeatherEvent(Weather.TYPE_HOT, new Time(0, 0, 0, 0, 0, 0, false)));
			oCalendarStatTracker.AddEvent(new CustomHarvestEvent(Plant.TYPE_CARROT, new Time(0, 1, 0, 0, 1, 0, false)));
			oCalendarStatTracker.AddEvent(oEvent1);
			oCalendarStatTracker.AddEvent(oEvent2);
			
			var lExpected:Array = [ oEvent1, oEvent2 ];
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			var lActual:Array = lEvents[2];
			
			oResult.expected = DayEvent.PrettyPrintList(lExpected);
			oResult.actual = DayEvent.PrettyPrintList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeReturnsPlantKilledEventsAtProperIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeReturnsPlantKilledEventsAtProperIndex");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			var oSeedEvent1:PlantKilledEvent = new PlantKilledEvent(Plant.TYPE_ASPARAGUS, -1, new Time(0, 0, 0, 0, 0, 0, false), 2);
			var oSeedEvent2:PlantKilledEvent = new PlantKilledEvent(Plant.TYPE_LETTUCE, -1, new Time(0, 0, 0, 0, 0, 0, false));
			
			oCalendarStatTracker.AddEvent(new WeatherEvent(Weather.TYPE_HOT, new Time(0, 0, 0, 0, 0, 0, false)));
			oCalendarStatTracker.AddEvent(new PlantKilledEvent(Plant.TYPE_CARROT, -1, new Time(0, 1, 0, 0, 1, 0, false)));
			oCalendarStatTracker.AddEvent(oSeedEvent1);
			oCalendarStatTracker.AddEvent(oSeedEvent2);
			
			var lExpected:Array = [ oSeedEvent1, oSeedEvent2 ];
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			var lActual:Array = lEvents[3];
			
			oResult.expected = DayEvent.PrettyPrintList(lExpected);
			oResult.actual = DayEvent.PrettyPrintList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeReturnsSaleCartSaleEventsAtProperIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeReturnsSaleCartSaleEventsAtProperIndex");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			var oSaleEvent1:SaleCartSaleEvent = new SaleCartSaleEvent("Seed", 0, 15, new Time(0, 0, 0, 0, 0, 0, false), 2);
			var oSaleEvent2:SaleCartSaleEvent = new SaleCartSaleEvent("Fertilizer", 0, 25, new Time(0, 0, 0, 0, 0, 0, false));
			
			oCalendarStatTracker.AddEvent(new WeatherEvent(Weather.TYPE_HOT, new Time(0, 0, 0, 0, 0, 0, false)));
			oCalendarStatTracker.AddEvent(new SaleCartSaleEvent("Seed", 1, 10, new Time(0, 1, 0, 0, 1, 0, false)));
			oCalendarStatTracker.AddEvent(oSaleEvent1);
			oCalendarStatTracker.AddEvent(oSaleEvent2);
			
			var lExpected:Array = [ oSaleEvent1, oSaleEvent2 ];
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			var lActual:Array = lEvents[4];
			
			oResult.expected = DayEvent.PrettyPrintList(lExpected);
			oResult.actual = DayEvent.PrettyPrintList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeReturnsFutureHarvestEventsAtProperIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeReturnsFutureHarvestEventsAtProperIndex");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent1:FutureHarvestEvent = new FutureHarvestEvent(Fruit.TYPE_ASPARAGUS, new Time(0, 0, 0, 0, 0, 0, false), 2);
			var oEvent2:FutureHarvestEvent = new FutureHarvestEvent(Fruit.TYPE_LETTUCE, new Time(0, 0, 0, 0, 0, 0, false));
			
			oCalendarStatTracker.AddEvent(new WeatherEvent(Weather.TYPE_HOT, new Time(0, 0, 0, 0, 0, 0, false)));
			oCalendarStatTracker.AddEvent(new FutureHarvestEvent(Fruit.TYPE_CARROT, new Time(0, 1, 0, 0, 1, 0, false)));
			oCalendarStatTracker.AddEvent(oEvent1);
			oCalendarStatTracker.AddEvent(oEvent2);
			
			var lExpected:Array = [ oEvent1, oEvent2 ];
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			var lActual:Array = lEvents[5];
			
			oResult.expected = DayEvent.PrettyPrintList(lExpected);
			oResult.actual = DayEvent.PrettyPrintList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeReturnsSeedPlantedEventsAtProperIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeReturnsSeedPlantedEventsAtProperIndex");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent1:SeedPlantedEvent = new SeedPlantedEvent(Plant.TYPE_ASPARAGUS, new Time(0, 0, 0, 0, 0, 0, false), 2);
			var oEvent2:SeedPlantedEvent = new SeedPlantedEvent(Plant.TYPE_LETTUCE, new Time(0, 0, 0, 0, 0, 0, false));
			
			oCalendarStatTracker.AddEvent(new WeatherEvent(Weather.TYPE_HOT, new Time(0, 0, 0, 0, 0, 0, false)));
			oCalendarStatTracker.AddEvent(new SeedPlantedEvent(Plant.TYPE_CARROT, new Time(0, 1, 0, 0, 1, 0, false)));
			oCalendarStatTracker.AddEvent(oEvent1);
			oCalendarStatTracker.AddEvent(oEvent2);
			
			var lExpected:Array = [ oEvent1, oEvent2 ];
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			var lActual:Array = lEvents[6];
			
			oResult.expected = DayEvent.PrettyPrintList(lExpected);
			oResult.actual = DayEvent.PrettyPrintList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeReturnsFruitHarvestedEventsAtProperIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeReturnsFruitHarvestedEventsAtProperIndex");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent1:FruitHarvestedEvent = new FruitHarvestedEvent(Fruit.TYPE_ASPARAGUS, new Time(0, 0, 0, 0, 0, 0, false), 2);
			var oEvent2:FruitHarvestedEvent = new FruitHarvestedEvent(Fruit.TYPE_LETTUCE, new Time(0, 0, 0, 0, 0, 0, false));
			
			oCalendarStatTracker.AddEvent(new WeatherEvent(Weather.TYPE_HOT, new Time(0, 0, 0, 0, 0, 0, false)));
			oCalendarStatTracker.AddEvent(new FruitHarvestedEvent(Fruit.TYPE_CARROT, new Time(0, 1, 0, 0, 1, 0, false)));
			oCalendarStatTracker.AddEvent(oEvent1);
			oCalendarStatTracker.AddEvent(oEvent2);
			
			var lExpected:Array = [ oEvent1, oEvent2 ];
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			var lActual:Array = lEvents[7];
			
			oResult.expected = DayEvent.PrettyPrintList(lExpected);
			oResult.actual = DayEvent.PrettyPrintList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeReturnsItemShopPurchaseEventsAtProperIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeReturnsItemShopPurchaseEventsAtProperIndex");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent1:ItemShopPurchaseEvent = new ItemShopPurchaseEvent("Seed", 0, 15, new Time(0, 0, 0, 0, 0, 0, false), 2);
			var oEvent2:ItemShopPurchaseEvent = new ItemShopPurchaseEvent("Fertilizer", 0, 25, new Time(0, 0, 0, 0, 0, 0, false));
			
			oCalendarStatTracker.AddEvent(new WeatherEvent(Weather.TYPE_HOT, new Time(0, 0, 0, 0, 0, 0, false)));
			oCalendarStatTracker.AddEvent(new ItemShopPurchaseEvent("Seed", 1, 10, new Time(0, 1, 0, 0, 1, 0, false)));
			oCalendarStatTracker.AddEvent(oEvent1);
			oCalendarStatTracker.AddEvent(oEvent2);
			
			var lExpected:Array = [ oEvent1, oEvent2 ];
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			var lActual:Array = lEvents[8];
			
			oResult.expected = DayEvent.PrettyPrintList(lExpected);
			oResult.actual = DayEvent.PrettyPrintList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeReturnsItemShopSaleEventsAtProperIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeReturnsItemShopSaleEventsAtProperIndex");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent1:ItemShopSaleEvent = new ItemShopSaleEvent("Seed", 0, 15, new Time(0, 0, 0, 0, 0, 0, false), 2);
			var oEvent2:ItemShopSaleEvent = new ItemShopSaleEvent("Fertilizer", 0, 25, new Time(0, 0, 0, 0, 0, 0, false));
			
			oCalendarStatTracker.AddEvent(new WeatherEvent(Weather.TYPE_HOT, new Time(0, 0, 0, 0, 0, 0, false)));
			oCalendarStatTracker.AddEvent(new ItemShopSaleEvent("Seed", 1, 10, new Time(0, 1, 0, 0, 1, 0, false)));
			oCalendarStatTracker.AddEvent(oEvent1);
			oCalendarStatTracker.AddEvent(oEvent2);
			
			var lExpected:Array = [ oEvent1, oEvent2 ];
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			var lActual:Array = lEvents[9];
			
			oResult.expected = DayEvent.PrettyPrintList(lExpected);
			oResult.actual = DayEvent.PrettyPrintList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetEventsForCalendarDayModeReturnsWellAmountEventsAtProperIndex():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "GetEventsForCalendarDayModeReturnsWellAmountEventsAtProperIndex");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCalendarStatTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent1:WellAmountEvent = new WellAmountEvent(100, new Time(0, 0, 0, 0, 0, 0, false));
			
			oCalendarStatTracker.AddEvent(new WeatherEvent(Weather.TYPE_HOT, new Time(0, 0, 0, 0, 0, 0, false)));
			oCalendarStatTracker.AddEvent(oEvent1);
			
			var lExpected:Array = [ oEvent1 ];
			var lEvents:Array = oCalendarStatTracker.GetEventsForCalendarDayMode(oTime);
			var lActual:Array = lEvents[10];
			
			oResult.expected = DayEvent.PrettyPrintList(lExpected);
			oResult.actual = DayEvent.PrettyPrintList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function RemoveEventOkIfEventNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "RemoveEventOkIfEventNull");
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:DayEvent = null;
			
			try
			{
				oTracker.RemoveEvent(oEvent);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function RemoveEventRemovesMatchingEvent():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "RemoveEventRemovesMatchingEvent");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_ASPARAGUS, new Time(0, 0, 0, 0, 0, 0, false), 1);
			oTracker.AddEvent(oEvent);
			
			oTracker.RemoveEvent(oEvent);
			
			var lEvents:Array = oTracker.GetAllEventsForDay(new Time(0, 0, 0, 0, 0, 0, false));
			
			oResult.expected = "No events";
			
			if (lEvents.length == 0)
			{
				oResult.actual = "No events";
			}
			else
			{
				oResult.actual = DayEvent.PrettyPrintList(lEvents);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function RemoveEventLeavesEventOfDifferentType():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "RemoveEventLeavesEventOfDifferentType");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_ASPARAGUS, new Time(0, 0, 0, 0, 0, 0, false), 1);
			oTracker.AddEvent(oEvent);
			var oRemoveEvent:CustomHarvestEvent = new CustomHarvestEvent(Fruit.TYPE_ASPARAGUS, new Time(0, 0, 0, 0, 0, 0, false), 1);
			
			oTracker.RemoveEvent(oRemoveEvent);
			
			var lEvents:Array = oTracker.GetAllEventsForDay(new Time(0, 0, 0, 0, 0, 0, false));
			
			oResult.expected = DayEvent.PrettyPrintList([ oEvent ]);
			
			if (lEvents.length == 0)
			{
				oResult.actual = "No events";
			}
			else
			{
				oResult.actual = DayEvent.PrettyPrintList(lEvents);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function RemoveEventLeavesEventOfDifferentDay():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "RemoveEventLeavesEventOfDifferentDay");
			var oTracker:CalendarStatTracker = new CalendarStatTracker();
			var oEvent:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_ASPARAGUS, new Time(0, 0, 0, 0, 0, 0, false), 1);
			oTracker.AddEvent(oEvent);
			var oRemoveEvent:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_ASPARAGUS, new Time(0, 1, 0, 0, 1, 0, false), 1);
			
			oTracker.RemoveEvent(oRemoveEvent);
			
			var lEvents:Array = oTracker.GetAllEventsForDay(new Time(0, 0, 0, 0, 0, 0, false));
			
			oResult.expected = DayEvent.PrettyPrintList([ oEvent ]);
			
			if (lEvents.length == 0)
			{
				oResult.actual = "No events";
			}
			else
			{
				oResult.actual = DayEvent.PrettyPrintList(lEvents);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		/*
		
		private static function ():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CalendarStatTracker", "");
			
			return oResult;
		}
		
		private static function ():Array
		{
			var lResults:Array = new Array();
			
			return lResults;
		}
		
		*/
		
		//- Testing Methods -//
	}
}