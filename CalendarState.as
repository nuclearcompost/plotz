package
{
	//-----------------------
	//Purpose:				State object for the calendar tool
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class CalendarState
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get calendarStatTracker():CalendarStatTracker
		{
			return _calendarStatTracker;
		}
		
		public function set calendarStatTracker(value:CalendarStatTracker):void
		{
			_calendarStatTracker = value;
		}
		
		public function get calendarTime():Time
		{
			return _calendarTime;
		}
		
		public function set calendarTime(value:Time):void
		{
			_calendarTime = value;
		}		
		
		public function get dayMode():Boolean
		{
			return _dayMode;
		}
		
		public function set dayMode(value:Boolean):void
		{
			_dayMode = value;
		}
		
		public function get time():Time
		{
			return _time;
		}
		
		public function set time(value:Time):void
		{
			_time = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _calendarStatTracker:CalendarStatTracker;
		private var _calendarTime:Time;
		private var _dayMode:Boolean;
		private var _time:Time;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CalendarState(time:Time = null, calendarStatTracker:CalendarStatTracker = null, calendarTime:Time = null, dayMode:Boolean = false)
		{
			_time = time;
			if (_time == null)
			{
				_time = new Time(0, 0, 0, 0, 0, 0, false);
			}
			
			_calendarStatTracker = calendarStatTracker;
			
			_calendarTime = calendarTime;
			if (_calendarTime == null)
			{
				_calendarTime = new Time(0, 0, 0, 0, 0, 0, false);
			}
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