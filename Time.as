package
{
	//-----------------------
	//Purpose:				A time and date
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class Time
	{
		// Constants //
		
		public static const DAYS_LONG:Array = [ "Monday" , "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ];
		public static const DAY_MONDAY:int = 0;
		public static const DAY_TUESDAY:int = 1;
		public static const DAY_WEDNESDAY:int = 2;
		public static const DAY_THURSDAY:int = 3;
		public static const DAY_FRIDAY:int = 4;
		public static const DAY_SATURDAY:int = 5;
		public static const DAY_SUNDAY:int = 6;
		
		public static const DAYS_SHORT:Array = [ "Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun" ];
		public static const DAYS_MINI:Array = [ "M", "T", "W", "R", "F", "S", "U" ];
		public static const DAY_M:int = 0;
		public static const DAY_T:int = 1;
		public static const DAY_W:int = 2;
		public static const DAY_R:int = 3;
		public static const DAY_F:int = 4;
		public static const DAY_S:int = 5;
		public static const DAY_U:int = 6;
		
		public static const MAX_DATE:int = 27;
		
		public static const MONTHS_LONG:Array = [ "March", "April", "May", "June", "July", "August", "September", "October", "November" ];  //, "December", "January", "February" ];
		public static const MONTHS_SHORT:Array = [ "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov" ];  //, "Dec", "Jan", "Feb" ];
		
		public static const MONTH_MAR:int = 0;
		public static const MONTH_APR:int = 1;
		public static const MONTH_MAY:int = 2;
		public static const MONTH_JUN:int = 3;
		public static const MONTH_JUL:int = 4;
		public static const MONTH_AUG:int = 5;
		public static const MONTH_SEP:int = 6;
		public static const MONTH_OCT:int = 7;
		public static const MONTH_NOV:int = 8;
		//public static const MONTH_DEC:int = 9;
		//public static const MONTH_JAN:int = 10;
		//public static const MONTH_FEB:int = 11;
		public static const MAX_MONTH:int = 8;
		
		public static const SEASONS:Array = [ "Spring", "Summer", "Fall" ]; //, "Winter" ];
		public static const SEASON_ANY:int = -1;
		public static const SEASON_SPRING:int = 0;
		public static const SEASON_SUMMER:int = 1;
		public static const SEASON_FALL:int = 2;
		//public static const SEASON_WINTER:int = 3;
		public static const MAX_SEASON:int = 2;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get date():int
		{
			return _date;
		}
		
		public function set date(value:int):void
		{
			_date = value;
		}
		
		public function get day():int
		{
			return _day;
		}
		
		public function set day(value:int):void
		{
			_day = value;
		}
		
		public function get month():int
		{
			return _month;
		}
		
		public function set month(value:int):void
		{
			_month = value;
		}
		
		public function get season():int
		{
			return _season;
		}
		
		public function set season(value:int):void
		{
			_season = value;
		}
		
		public function get time():Number
		{
			return _time;
		}
		
		public function set time(value:Number):void
		{
			_time = value;
		}
		
		public function get useMonth():Boolean
		{
			return _useMonth;
		}
		
		public function set useMonth(value:Boolean):void
		{
			_useMonth = value;
		}
		
		public function get year():int
		{
			return _year;
		}
		
		public function set year(value:int):void
		{
			_year = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _date:int;
		private var _day:int;
		private var _month:int;
		private var _season:int;
		private var _time:Number;
		private var _useMonth:Boolean;  // if true, have each season be 3 months long; if false, have each season be only 1 month long
		private var _year:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Time(time:Number = 0, date:int = 0, month:int = 0, year:int = 0, day:int = 0, season:int = 0, useMonth:Boolean = false)
		{
			_time = time;
			_date = date;
			_month = month;
			_year = year;
			_day = day;
			_season = season;
			_useMonth = useMonth;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function GetClone():Time
		{
			var oClone:Time = new Time(_time, _date, _month, _year, _day, _season, _useMonth);
			
			return oClone;
		}
		
		// get a Time object based on the standardized numeric value
		public static function GetDateFromNumericValue(value:uint, useMonth:Boolean):Time
		{
			var iDaysPerMonth = Time.MAX_DATE + 1;
			
			var iNumMonths = Time.MAX_MONTH + 1;
			if (useMonth == false)
			{
				iNumMonths = Time.MAX_SEASON + 1;
			}
			
			var iDaysPerYear = iNumMonths * iDaysPerMonth;
			
			var iYear:int = Math.floor(value / iDaysPerYear);
			var iRemainder:uint = value - (iYear * iDaysPerYear);
			
			var iMonth:int = Math.floor(iRemainder / iDaysPerMonth);
			iRemainder -= (iMonth * iDaysPerMonth);
			
			var iDate:int = iRemainder;
			
			var iDay:int = TimeService.GetDayForDate(iDate);
			
			var iTime:Time = new Time(0, iDate, iMonth, iYear, iDay, 0, useMonth);
			iTime.season = TimeService.GetSeasonForMonth(iTime);
			
			return iTime;
		}
		
		// Get a single number represents a day. assume that the first possible date is day 0, then the next day is day 1, etc...
		public function GetNumericDateValue():uint
		{
			var iDaysPerMonth = Time.MAX_DATE + 1;
			
			var iNumMonths = Time.MAX_MONTH + 1;
			if (_useMonth == false)
			{
				iNumMonths = Time.MAX_SEASON + 1;
			}
			
			var iValue:uint = _year * iNumMonths * iDaysPerMonth;
			iValue += (_month * iDaysPerMonth);
			iValue += _date;
			
			return iValue;
		}
		
		public function IsSameDay(other:Time):Boolean
		{
			if (other == null)
			{
				return false;
			}
			
			if (other.date != _date)
			{
				return false;
			}
			
			if (other.month != _month)
			{
				return false;
			}
			
			if (other.year != _year)
			{
				return false;
			}
			
			if (other.day != _day)
			{
				return false;
			}
			
			if (other.season != _season)
			{
				return false;
			}
			
			if (other.useMonth != _useMonth)
			{
				return false;
			}
			
			return true;
		}
		
		public function PrettyPrint():String
		{
			var sOutput:String = String(_time) + " " + Time.DAYS_LONG[_day] + " ";
			
			if (_useMonth == true)
			{
				sOutput += (Time.MONTHS_LONG[_month] + " ");
			}
			
			sOutput += (String(_date + 1) + " " + Time.SEASONS[_season] + " " + _year);
			
			return sOutput;
		}
		
		public static function PrettyPrintList(list:Array):String
		{
			if (list == null)
			{
				return "";
			}
			
			var sOutput:String = "";
			
			for (var i:int = 0; i < list.length; i++)
			{
				var oObject:Object = list[i];
				
				if (oObject == null)
				{
					continue;
				}
				
				if (!(oObject is Time))
				{
					continue;
				}
				
				var oTime:Time = Time(oObject);
				
				sOutput += (oTime.PrettyPrint() + "; ");
			}
			
			return sOutput;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(Time.GetDateFromNumericValueWithUseMonthTrue());
			lResults.push(Time.GetDateFromNumericValueWithUseMonthFalse());
			
			lResults.push(Time.GetNumericDateValue());
			
			lResults.push(Time.IsSameDayFalseIfOtherNull());
			lResults.push(Time.IsSameDayFalseIfDifferentDate());
			lResults.push(Time.IsSameDayFalseIfDifferentMonth());
			lResults.push(Time.IsSameDayFalseIfDifferentYear());
			lResults.push(Time.IsSameDayFalseIfDifferentDay());
			lResults.push(Time.IsSameDayFalseIfDifferentSeason());
			lResults.push(Time.IsSameDayFalseIfDifferentUseMonth());
			lResults.push(Time.IsSameDayTrueIfDifferentTime());
			lResults.push(Time.IsSameDayTrueIfAllSame());
			
			lResults.push(Time.PrettyPrintWithUseMonth());
			lResults.push(Time.PrettyPrintWithoutUseMonth());
			
			return lResults;
		}
		
		private static function GetDateFromNumericValueWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "GetDateFromNumericValueWithUseMonthTrue");
			
			var bUseMonth:Boolean = true;
			
			var oTime0:Time = new Time(0, 0, 0, 0, 0, 0, bUseMonth);
			var oTime3:Time = new Time(0, 3, 0, 0, 3, 0, bUseMonth);
			var oTime36:Time = new Time(0, 8, 1, 0, 1, 0, bUseMonth);
			var oTime366:Time = new Time(0, 2, 4, 1, 2, 1, bUseMonth);
			
			var lTimes:Array = [ oTime0, oTime3, oTime36, oTime366 ];
			var lValues:Array = [ 0, 3, 36, 366 ];
			
			oResult.expected = Time.PrettyPrintList(lTimes);
			
			var lActual:Array = new Array();
			
			for (var i:int = 0; i < lValues.length; i++)
			{
				var uValue:uint = uint(lValues[i]);
				
				var oActual:Time = Time.GetDateFromNumericValue(uValue, bUseMonth);
				lActual.push(oActual);
			}
			
			oResult.actual = Time.PrettyPrintList(lActual);
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetDateFromNumericValueWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "GetDateFromNumericValueWithUseMonthFalse");
			
			var bUseMonth:Boolean = false;
			
			var oTime0:Time = new Time(0, 0, 0, 0, 0, 0, bUseMonth);
			var oTime3:Time = new Time(0, 3, 0, 0, 3, 0, bUseMonth);
			var oTime36:Time = new Time(0, 8, 1, 0, 1, 1, bUseMonth);
			var oTime142:Time = new Time(0, 2, 2, 1, 2, 2, bUseMonth);
			
			var lTimes:Array = [ oTime0, oTime3, oTime36, oTime142 ];
			var lValues:Array = [ 0, 3, 36, 142 ];
			
			oResult.expected = Time.PrettyPrintList(lTimes);
			
			var lActual:Array = new Array();
			
			for (var i:int = 0; i < lValues.length; i++)
			{
				var uValue:uint = uint(lValues[i]);
				
				var oActual:Time = Time.GetDateFromNumericValue(uValue, bUseMonth);
				lActual.push(oActual);
			}
			
			oResult.actual = Time.PrettyPrintList(lActual);
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumericDateValue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "GetNumericDateValue");
			
			var oTime0T:Time = new Time(0, 0, 0, 0, 0, 0, true);
			var oTime3T:Time = new Time(0, 3, 0, 0, 3, 0, true);
			var oTime36T:Time = new Time(0, 8, 1, 0, 1, 0, true);
			var oTime366T:Time = new Time(0, 2, 4, 1, 2, 1, true);
			var oTime0F:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oTime3F:Time = new Time(0, 3, 0, 0, 3, 0, false);
			var oTime36F:Time = new Time(0, 8, 1, 0, 1, 0, false);
			var oTime142F:Time = new Time(0, 2, 2, 1, 2, 2, false);
			
			var lTimes:Array = [ oTime0T, oTime3T, oTime36T, oTime366T, oTime0F, oTime3F, oTime36F, oTime142F ];
			
			oResult.expected = "0, 3, 36, 366, 0, 3, 36, 142, ";
			oResult.actual = "";
			
			for (var i:int = 0; i < lTimes.length; i++)
			{
				var oTime:Time = Time(lTimes[i]);
				
				var iValue:uint = oTime.GetNumericDateValue();
				
				oResult.actual += (String(iValue) + ", ");
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function IsSameDayFalseIfOtherNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "IsSameDayFalseIfOtherNull");
			var oTime:Time = new Time();
			var oOther:Time = null;
			
			oResult.TestFalse(oTime.IsSameDay(oOther));
			
			return oResult;
		}
		
		private static function IsSameDayFalseIfDifferentDate():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "IsSameDayFalseIfDifferentDate");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oOther:Time = new Time(0, 1, 0, 0, 0, 0, false);
			
			oResult.TestFalse(oTime.IsSameDay(oOther));
			
			return oResult;
		}
		
		private static function IsSameDayFalseIfDifferentMonth():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "IsSameDayFalseIfDifferentMonth");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oOther:Time = new Time(0, 0, 1, 0, 0, 0, false);
			
			oResult.TestFalse(oTime.IsSameDay(oOther));
			
			return oResult;
		}
		
		private static function IsSameDayFalseIfDifferentYear():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "IsSameDayFalseIfDifferentYear");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oOther:Time = new Time(0, 0, 0, 1, 0, 0, false);
			
			oResult.TestFalse(oTime.IsSameDay(oOther));
			
			return oResult;
		}
		
		private static function IsSameDayFalseIfDifferentDay():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "IsSameDayFalseIfDifferentDay");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oOther:Time = new Time(0, 0, 0, 0, 1, 0, false);
			
			oResult.TestFalse(oTime.IsSameDay(oOther));
			
			return oResult;
		}
		
		private static function IsSameDayFalseIfDifferentSeason():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "IsSameDayFalseIfDifferentSeason");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oOther:Time = new Time(0, 0, 0, 0, 0, 1, false);
			
			oResult.TestFalse(oTime.IsSameDay(oOther));
			
			return oResult;
		}
		
		private static function IsSameDayFalseIfDifferentUseMonth():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "IsSameDayFalseIfDifferentUseMonth");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oOther:Time = new Time(0, 0, 0, 0, 0, 0, true);
			
			oResult.TestFalse(oTime.IsSameDay(oOther));
			
			return oResult;
		}
		
		private static function IsSameDayTrueIfDifferentTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "IsSameDayTrueIfDifferentTime");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oOther:Time = new Time(1, 0, 0, 0, 0, 0, false);
			
			oResult.TestTrue(oTime.IsSameDay(oOther));
			
			return oResult;
		}
		
		private static function IsSameDayTrueIfAllSame():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "IsSameDayTrueIfAllSame");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oOther:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.TestTrue(oTime.IsSameDay(oOther));
			
			return oResult;
		}
		
		private static function PrettyPrintWithUseMonth():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "PrettyPrintWithUseMonth");
			
			var oTime:Time = new Time(50, 3, 4, 1, 5, 2, true);
			
			oResult.expected = "50 Saturday July 4 Fall 1";
			oResult.actual = oTime.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function PrettyPrintWithoutUseMonth():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Time", "PrettyPrintWithoutUseMonth");
			
			var oTime:Time = new Time(50, 3, 0, 1, 5, 2, false);
			
			oResult.expected = "50 Saturday 4 Fall 1";
			oResult.actual = oTime.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		/*
		
		private static function ():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "");
			
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