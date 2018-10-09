package
{
	//-----------------------
	//Purpose:				Service logic for Time
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class TimeService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function TimeService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		//---------------
		//Purpose:		Advance to the next date
		//
		//Parameters:
		//	none
		//
		//Returns:		void
		//---------------
		public static function AdvanceDate(time:Time):void
		{
			// advance the day value
			if (time.day == Time.DAY_SUNDAY)
			{
				time.day = Time.DAY_MONDAY;
			}
			else
			{
				time.day++;
			}
			
			// advance the date value
			if (time.date < Time.MAX_DATE)
			{
				time.date++;
			}
			else
			{
				// reset to the beginning of the month
				time.date = 0;
				
				// advance the month - and year, if needed
				time.month++;
				
				var bAdvanceYear:Boolean = false;
				
				if (time.useMonth == true && time.month > Time.MAX_MONTH)
				{
					bAdvanceYear = true;
				}
				
				if (time.useMonth == false && time.month > Time.MAX_SEASON)
				{
					bAdvanceYear = true;
				}
				
				if (bAdvanceYear == true)
				{
					time.month = 0;
					time.year++;
				}
				
				// update the season based on the new month
				time.season = TimeService.GetSeasonForMonth(time);
			}
		}
		
		public static function AdvanceMonth(time:Time):Time
		{
			if (time == null)
			{
				return null;
			}
			
			var iDateValue:int = time.GetNumericDateValue();
			iDateValue += (Time.MAX_DATE + 1);
			
			var oNewTime:Time = Time.GetDateFromNumericValue(iDateValue, time.useMonth);
			
			return oNewTime;
		}
		
		public static function BackUpDate(time:Time):void
		{
			if (time.day == Time.DAY_MONDAY)
			{
				time.day = Time.DAY_SUNDAY;
			}
			else
			{
				time.day--;
			}
			
			if (time.date > 0)
			{
				time.date--;
			}
			else
			{
				time.date = Time.MAX_DATE;
				
				if (time.month > 0)
				{
					time.month--;
					
				}
				else
				{
					if (time.year > 0)
					{
						time.month = TimeService.GetMaxMonth(time);
						time.year--;
					}
					else
					{
						time.day = 0;
						time.date = 0;
					}
				}
				
				time.season = TimeService.GetSeasonForMonth(time);
			}
		}
		
		public static function BackUpMonth(time:Time):Time
		{
			if (time == null)
			{
				return null;
			}
			
			var iDateValue:int = time.GetNumericDateValue();
			iDateValue -= (Time.MAX_DATE + 1);
			
			var oNewTime:Time = Time.GetDateFromNumericValue(iDateValue, time.useMonth);
			
			return oNewTime;
		}
		
		public static function GetDayForDate(date:int):int
		{
			if (date < 0)
			{
				return 0;
			}
			
			if (date > Time.MAX_DATE)
			{
				return 0;
			}
			
			var iDay:int = date % 7;
			
			return iDay;
		}
		
		public static function GetFutureDate(time:Time, days:int):Time
		{
			if (time == null)
			{
				return null;
			}
			
			if (days < 0)
			{
				return time;
			}
			
			// DON'T modify the original time passed in, this is a Get function
			var oCloneTime:Time = time.GetClone();
			
			for (var i:int = 0; i < days; i++)
			{
				AdvanceDate(oCloneTime);
			}
			
			return oCloneTime;
		}
		
		public static function GetMaxMonth(time:Time):int
		{
			if (time == null)
			{
				return 0;
			}
			
			var iMaxMonth:int = 0;
			
			if (time.useMonth == true)
			{
				iMaxMonth = Time.MAX_MONTH;
			}
			else
			{
				iMaxMonth = Time.MAX_SEASON;
			}
			
			return iMaxMonth;
		}
		
		public static function GetNextMonth(time:Time):int
		{
			if (time == null)
			{
				return 0;
			}
			
			if (time.month < 0)
			{
				return 0;
			}
			
			var iMaxMonth:int = TimeService.GetMaxMonth(time);
			
			if (time.month > iMaxMonth)
			{
				return 0;
			}
			
			var iNextMonth:int = time.month + 1;
			
			if (iNextMonth > iMaxMonth)
			{
				iNextMonth = 0;
			}
			
			return iNextMonth;
		}
		
		public static function GetNumDaysBetween(base:Time, check:Time):int
		{
			if (base == null)
			{
				throw new Error("null parameter: base");
			}
			
			if (check == null)
			{
				throw new Error("null parameter: check");
			}
			
			if (base.useMonth != check.useMonth)
			{
				throw new Error("can only compare times with the same useMonth value");
			}
			
			var iBaseValue:uint = base.GetNumericDateValue();
			var iCheckValue:uint = check.GetNumericDateValue();
			
			var iDaysBetween:int = iCheckValue - iBaseValue;
			
			return iDaysBetween;
		}
		
		public static function GetPreviousMonth(time:Time):int
		{
			if (time == null)
			{
				return 0;
			}
			
			if (time.month < 0)
			{
				return 0;
			}
			
			var iMaxMonth:int = TimeService.GetMaxMonth(time);
			
			if (time.month > iMaxMonth)
			{
				return 0;
			}
			
			var iPreviousMonth:int = time.month - 1;
			
			if (iPreviousMonth < 0)
			{
				iPreviousMonth = iMaxMonth;
			}
			
			return iPreviousMonth;
		}
		
		public static function GetSeasonForMonth(time:Time):int
		{
			if (time == null)
			{
				return 0;
			}
			
			var iSeason:int = 0;
			
			if (time.useMonth == false)
			{
				iSeason = time.month;
				
				return iSeason;
			}
			
			switch (time.month)
			{
				case Time.MONTH_MAR:
				case Time.MONTH_APR:
				case Time.MONTH_MAY:
					iSeason = Time.SEASON_SPRING;
					break;
				case Time.MONTH_JUN:
				case Time.MONTH_JUL:
				case Time.MONTH_AUG:
					iSeason = Time.SEASON_SUMMER;
					break;
				case Time.MONTH_SEP:
				case Time.MONTH_OCT:
				case Time.MONTH_NOV:
					iSeason = Time.SEASON_FALL;
					break;
				default:
					break;
			}
			
			return iSeason;
		}
		
		public static function HasNextDayThisYear(time:Time):Boolean
		{
			if (time == null)
			{
				return false;
			}
			
			var iMaxMonth:int = TimeService.GetMaxMonth(time);
			
			if (time.month == iMaxMonth && time.date == Time.MAX_DATE)
			{
				return false;
			}
			
			return true;
		}
		
		public static function HasPreviousDayThisYear(time:Time):Boolean
		{
			if (time == null)
			{
				return false;
			}
			
			if (time.month == 0 && time.date == 0)
			{
				return false;
			}
			
			return true;
		}
		
		public static function HasNextMonthThisYear(time:Time):Boolean
		{
			if (time == null)
			{
				return false;
			}
			
			var iNextMonth:int = TimeService.GetNextMonth(time);
			
			if (iNextMonth == 0)
			{
				return false;
			}
			
			return true;
		}
		
		public static function HasPreviousMonthThisYear(time:Time):Boolean
		{
			if (time == null)
			{
				return false;
			}
			
			var iMaxMonth:int = TimeService.GetMaxMonth(time);
			var iPreviousMonth:int = TimeService.GetPreviousMonth(time);
			
			if (iPreviousMonth == iMaxMonth)
			{
				return false;
			}
			
			return true;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults = lResults.concat(AdvanceDateUpdatesDay());
			lResults = lResults.concat(AdvanceDateUpdatesDate());
			lResults = lResults.concat(AdvanceDateUpdatesMonthForUseMonthFalse());
			lResults = lResults.concat(AdvanceDateUpdatesMonthForUseMonthTrue());
			lResults.push(AdvanceDateUpdatesYearForUseMonthFalse());
			lResults.push(AdvanceDateUpdatesYearForUseMonthTrue());
			lResults = lResults.concat(AdvanceDateUpdatesSeasonForUseMonthFalse());
			lResults = lResults.concat(AdvanceDateUpdatesSeasonForUseMonthTrue());
			
			lResults.push(TimeService.GetDayForDateReturnsMondayForTooSmallDate());
			lResults.push(TimeService.GetDayForDateReturnsMondayForTooLargeDate());
			lResults = lResults.concat(TimeService.GetDayForDateReturnsCorrectDayForValidDate());
			
			lResults.push(TimeService.GetFutureDateNullForNullTime());
			lResults.push(TimeService.GetFutureDateSameTimeForNegDays());
			lResults.push(TimeService.GetFutureDateAdvancesDate());
			
			lResults.push(TimeService.GetMaxMonth0ForNullTime());
			lResults.push(TimeService.GetMaxMonthForUseMonthFalse());
			lResults.push(TimeService.GetMaxMonthForUseMonthTrue());
			
			lResults.push(TimeService.GetNextMonth0ForNullTime());
			lResults.push(TimeService.GetNextMonth0ForTooSmallMonth());
			lResults.push(TimeService.GetNextMonth0ForTooLargeMonthWithUseMonthFalse());
			lResults.push(TimeService.GetNextMonth0ForTooLargeMonthWithUseMonthTrue());
			lResults = lResults.concat(TimeService.GetNextMonthReturnsNextMonthWithUseMonthFalse());
			lResults = lResults.concat(TimeService.GetNextMonthReturnsNextMonthWithUseMonthTrue());
			
			lResults.push(TimeService.GetNumDaysBetweenThrowsExceptionIfBaseTimeNull());
			lResults.push(TimeService.GetNumDaysBetweenThrowsExceptionIfCheckTimeNull());
			lResults.push(TimeService.GetNumDaysBetweenThrowsExceptionForIncompatibleTimes());
			lResults.push(TimeService.GetNumDaysBetweenNegativeForPastDay());
			lResults.push(TimeService.GetNumDaysBetweenNegativeForPastWeek());
			lResults.push(TimeService.GetNumDaysBetweenNegativeForPastMonthIfUseMonthTrue());
			lResults.push(TimeService.GetNumDaysBetweenNegativeForPastMonthIfUseMonthFalse());
			lResults.push(TimeService.GetNumDaysBetweenNegativeForPastYearIfUseMonthTrue());
			lResults.push(TimeService.GetNumDaysBetweenNegativeForPastYearIfUseMonthFalse());
			lResults.push(TimeService.GetNumDaysBetweenEqual());
			lResults.push(TimeService.GetNumDaysBetweenPositiveForFutureDay());
			lResults.push(TimeService.GetNumDaysBetweenPositiveForFutureWeek());
			lResults.push(TimeService.GetNumDaysBetweenPositiveForFutureMonthIfUseMonthTrue());
			lResults.push(TimeService.GetNumDaysBetweenPositiveForFutureMonthIfUseMonthFalse());
			lResults.push(TimeService.GetNumDaysBetweenPositiveForFutureYearIfUseMonthTrue());
			lResults.push(TimeService.GetNumDaysBetweenPositiveForFutureYearIfUseMonthFalse());
			
			lResults.push(TimeService.GetPreviousMonth0ForNullTime());
			lResults.push(TimeService.GetPreviousMonth0ForTooSmallMonth());
			lResults.push(TimeService.GetPreviousMonth0ForTooLargeMonthWithUseMonthFalse());
			lResults.push(TimeService.GetPreviousMonth0ForTooLargeMonthWithUseMonthTrue());
			lResults = lResults.concat(TimeService.GetPreviousMonthReturnsNextMonthWithUseMonthFalse());
			lResults = lResults.concat(TimeService.GetPreviousMonthReturnsNextMonthWithUseMonthTrue());
			
			lResults.push(TimeService.GetSeasonForMonth0ForNullTime());
			lResults = lResults.concat(TimeService.GetSeasonForMonthWithUseMonthFalse());
			lResults = lResults.concat(TimeService.GetSeasonForMonthWithUseMonthTrue());
			
			lResults.push(TimeService.HasNextMonthThisYearFalseForNullTime());
			lResults.push(TimeService.HasNextMonthThisYearFalseWithUseMonthFalse());
			lResults.push(TimeService.HasNextMonthThisYearFalseWithUseMonthTrue());
			lResults.push(TimeService.HasNextMonthThisYearTrueWithUseMonthFalse());
			lResults.push(TimeService.HasNextMonthThisYearTrueWithUseMonthTrue());
			
			lResults.push(TimeService.HasPreviousMonthThisYearFalseForNullTime());
			lResults.push(TimeService.HasPreviousMonthThisYearFalseWithUseMonthFalse());
			lResults.push(TimeService.HasPreviousMonthThisYearFalseWithUseMonthTrue());
			lResults.push(TimeService.HasPreviousMonthThisYearTrueWithUseMonthFalse());
			lResults.push(TimeService.HasPreviousMonthThisYearTrueWithUseMonthTrue());
			
			lResults.push(TimeService.HasNextDayThisYearFalseForNullTime());
			lResults.push(TimeService.HasNextDayThisYearFalseWithUseMonthFalse());
			lResults.push(TimeService.HasNextDayThisYearFalseWithUseMonthTrue());
			lResults.push(TimeService.HasNextDayThisYearTrueWithUseMonthFalse());
			lResults.push(TimeService.HasNextDayThisYearTrueWithUseMonthTrue());
			
			lResults.push(TimeService.HasPreviousDayThisYearFalseForNullTime());
			lResults.push(TimeService.HasPreviousDayThisYearFalseWithUseMonthFalse());
			lResults.push(TimeService.HasPreviousDayThisYearFalseWithUseMonthTrue());
			lResults.push(TimeService.HasPreviousDayThisYearTrueWithUseMonthFalse());
			lResults.push(TimeService.HasPreviousDayThisYearTrueWithUseMonthTrue());
			
			lResults.push(TimeService.BackUpDateZeroDateReturnsZeroDate());
			lResults.push(TimeService.BackUpDateReturnsPreviousDate());
			lResults.push(TimeService.BackUpDateReturnsPreviousDateForWeekEdge());
			lResults.push(TimeService.BackUpDateReturnsPreviousDateForMonthEdgeWithUseMonthTrue());
			lResults.push(TimeService.BackUpDateReturnsPreviousDateForYearEdgeWithUseMonthTrue());
			lResults.push(TimeService.BackUpDateReturnsPreviousDateForMonthEdgeWithUseMonthFalse());
			lResults.push(TimeService.BackUpDateReturnsPreviousDateForYearEdgeWithUseMonthFalse());
			
			return lResults;
		}
		
		private static function AdvanceDateUpdatesDay():Array
		{
			var lResults:Array = new Array();
			var lExpected:Array = [ 1, 2, 3, 4, 5, 6, 0 ];
			
			for (var day:int = 0; day < 7; day++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "AdvanceDateUpdatesDay - Day " + Time.DAYS_LONG[day]);
				oResult.expected = String(lExpected[day]);
				
				var oTime:Time = new Time(0, 0, 0, 0, day);
				TimeService.AdvanceDate(oTime);
				
				oResult.actual = String(oTime.day);
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function AdvanceDateUpdatesDate():Array
		{
			var lResults:Array = new Array();
			var lExpected:Array = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 0 ];
			
			for (var date:int = 0; date <= Time.MAX_DATE; date++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "AdvanceDateUpdatesDate - Date " + (date + 1));
				
				oResult.expected = String(lExpected[date]);
				
				var oTime:Time = new Time(0, date);
				TimeService.AdvanceDate(oTime);
				
				oResult.actual = String(oTime.date);
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function AdvanceDateUpdatesMonthForUseMonthFalse():Array
		{
			var lResults:Array = new Array();
			var lExpected:Array = [ 1, 2, 0 ];
			
			for (var month:int = 0; month <= Time.MAX_SEASON; month++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "AdvanceDateUpdatesMonthForUseMonthFalse - Month " + Time.SEASONS[month]);
				
				oResult.expected = String(lExpected[month]);
				
				var iDay:int = TimeService.GetDayForDate(Time.MAX_DATE);
				var iSeason:int = TimeService.GetSeasonForMonth(oTime);
				var oTime:Time = new Time(0, Time.MAX_DATE, month, 0, iDay, iSeason, false);
				TimeService.AdvanceDate(oTime);
				
				oResult.actual = String(oTime.month);
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function AdvanceDateUpdatesMonthForUseMonthTrue():Array
		{
			var lResults:Array = new Array();
			var lExpected:Array = [ 1, 2, 3, 4, 5, 6, 7, 8, 0 ];
			
			for (var month:int = 0; month <= Time.MAX_MONTH; month++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "AdvanceDateUpdatesMonthForUseMonthTrue - Month " + Time.MONTHS_LONG[month]);
				
				oResult.expected = String(lExpected[month]);
				
				var iDay:int = TimeService.GetDayForDate(Time.MAX_DATE);
				var iSeason:int = TimeService.GetSeasonForMonth(new Time(0, 0, month, 0, 0, 0, true));
				var oTime:Time = new Time(0, Time.MAX_DATE, month, 0, iDay, iSeason, true);
				TimeService.AdvanceDate(oTime);
				
				oResult.actual = String(oTime.month);
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function AdvanceDateUpdatesYearForUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "AdvanceDateUpdatesYearForUseMonthFalse");
			
			var iMonth:int = Time.MAX_SEASON;
			var iDay:int = TimeService.GetDayForDate(Time.MAX_DATE);
			var iSeason:int = TimeService.GetSeasonForMonth(new Time(0, 0, iMonth, 0, 0, 0, false));
			var oTime:Time = new Time(0, Time.MAX_DATE, iMonth, 0, iDay, iSeason, false);
			
			TimeService.AdvanceDate(oTime);
			
			oResult.expected = "1";
			oResult.actual = String(oTime.year);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function AdvanceDateUpdatesYearForUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "AdvanceDateUpdatesYearForUseMonthTrue");
			
			var iMonth:int = Time.MAX_MONTH;
			var iDay:int = TimeService.GetDayForDate(Time.MAX_DATE);
			var iSeason:int = TimeService.GetSeasonForMonth(new Time(0, 0, iMonth, 0, 0, 0, true));
			var oTime:Time = new Time(0, Time.MAX_DATE, iMonth, 0, iDay, iSeason, true);
			
			TimeService.AdvanceDate(oTime);
			
			oResult.expected = "1";
			oResult.actual = String(oTime.year);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function AdvanceDateUpdatesSeasonForUseMonthFalse():Array
		{
			var lResults:Array = new Array();
			var lExpected:Array = [ 1, 2, 0 ];
			
			for (var month:int = 0; month <= Time.MAX_SEASON; month++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "AdvanceDateUpdatesSeasonForUseMonthFalse - Season " + Time.SEASONS[month]);
				
				oResult.expected = String(lExpected[month]);
				
				var iDay:int = TimeService.GetDayForDate(Time.MAX_DATE);
				var iSeason:int = TimeService.GetSeasonForMonth(new Time(0, 0, month, 0, 0, 0, false));
				var oTime:Time = new Time(0, Time.MAX_DATE, month, 0, iDay, iSeason, false);
				TimeService.AdvanceDate(oTime);
				
				oResult.actual = String(oTime.season);
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function AdvanceDateUpdatesSeasonForUseMonthTrue():Array
		{
			var lResults:Array = new Array();
			var lExpected:Array = [ 1, 2, 0 ];
			var lMonths:Array = [ Time.MONTH_MAY, Time.MONTH_AUG, Time.MONTH_NOV ];
			
			for (var month:int = 0; month <= Time.MAX_SEASON; month++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "AdvanceDateUpdatesSeasonForUseMonthTrue - Season " + Time.SEASONS[month]);
				
				oResult.expected = String(lExpected[month]);
				
				var iDay:int = TimeService.GetDayForDate(Time.MAX_DATE);
				var iMonth:int = lMonths[month];
				var iSeason:int = TimeService.GetSeasonForMonth(new Time(0, 0, iMonth, 0, 0, 0, true));
				var oTime:Time = new Time(0, Time.MAX_DATE, iMonth, 0, iDay, iSeason, true);
				TimeService.AdvanceDate(oTime);
				
				oResult.actual = String(oTime.season);
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function BackUpDateZeroDateReturnsZeroDate():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "BackUpDateZeroDateReturnsZeroDate");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oExpected:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			TimeService.BackUpDate(oTime);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oTime.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function BackUpDateReturnsPreviousDate():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "BackUpDateReturnsPreviousDate");
			var oTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			var oExpected:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			TimeService.BackUpDate(oTime);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oTime.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function BackUpDateReturnsPreviousDateForWeekEdge():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "BackUpDateReturnsPreviousDateForWeekEdge");
			var oTime:Time = new Time(0, 7, 0, 0, 0, 0, false);
			var oExpected:Time = new Time(0, 6, 0, 0, 6, 0, false);
			
			TimeService.BackUpDate(oTime);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oTime.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function BackUpDateReturnsPreviousDateForMonthEdgeWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "BackUpDateReturnsPreviousDateForMonthEdgeWithUseMonthTrue");
			var oTime:Time = new Time(0, 0, 1, 0, 0, 0, true);
			var oExpected:Time = new Time(0, 27, 0, 0, 6, 0, true);
			
			TimeService.BackUpDate(oTime);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oTime.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function BackUpDateReturnsPreviousDateForYearEdgeWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "BackUpDateReturnsPreviousDateForYearEdgeWithUseMonthTrue");
			var oTime:Time = new Time(0, 0, 0, 1, 0, 0, true);
			var oExpected:Time = new Time(0, 27, Time.MAX_MONTH, 0, 6, Time.MAX_SEASON, true);
			
			TimeService.BackUpDate(oTime);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oTime.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function BackUpDateReturnsPreviousDateForMonthEdgeWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "BackUpDateReturnsPreviousDateForMonthEdgeWithUseMonthFalse");
			var oTime:Time = new Time(0, 0, 1, 0, 0, 0, false);
			var oExpected:Time = new Time(0, 27, 0, 0, 6, 0, false);
			
			TimeService.BackUpDate(oTime);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oTime.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function BackUpDateReturnsPreviousDateForYearEdgeWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "BackUpDateReturnsPreviousDateForYearEdgeWithUseMonthFalse");
			var oTime:Time = new Time(0, 0, 0, 1, 0, 0, false);
			var oExpected:Time = new Time(0, 27, Time.MAX_SEASON, 0, 6, Time.MAX_SEASON, false);
			
			TimeService.BackUpDate(oTime);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oTime.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetDayForDateReturnsMondayForTooSmallDate():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetDayForDateReturnsMondayForTooSmallDate");
			
			oResult.expected = String(Time.DAY_MONDAY);
			oResult.actual = String(TimeService.GetDayForDate(-1));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetDayForDateReturnsMondayForTooLargeDate():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetDayForDateReturnsMondayForTooLargeDate");
			
			oResult.expected = String(Time.DAY_MONDAY);
			oResult.actual = String(TimeService.GetDayForDate(1000));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetDayForDateReturnsCorrectDayForValidDate():Array
		{
			var lResults:Array = new Array();
			
			var lExpected:Array = [ 0, 1, 2, 3, 4, 5, 6, 0, 1, 2, 3, 4, 5, 6, 0, 1, 2, 3, 4, 5, 6, 0, 1, 2, 3, 4, 5, 6 ];
			
			for (var i:int = 0; i <= Time.MAX_DATE; i++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetDayForDateReturnsCorrectDayForValidDate - date " + i);
				
				oResult.expected = String(lExpected[i]);
				oResult.actual = String(TimeService.GetDayForDate(i));
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function GetFutureDateNullForNullTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetFutureDateNullForNullTime");
			var oTime:Time = null;
			var iDays:int = 29;
			
			oResult.TestNull(TimeService.GetFutureDate(oTime, iDays));
			
			return oResult;
		}
		
		private static function GetFutureDateSameTimeForNegDays():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetFutureDateSameTimeForNegDays");
			var oTime:Time = new Time(0, 0, 0, 1, 0, 0, false);
			var iDays:int = -1;
			
			var oNewTime:Time = TimeService.GetFutureDate(oTime, iDays)
			
			oResult.TestTrue(oTime.IsSameDay(oNewTime));
			
			return oResult;
		}
		
		private static function GetFutureDateAdvancesDate():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetFutureDateAdvancesDate");
			var oTime:Time = new Time(0, 0, 0, 1, 0, 0, false);
			var iDays:int = 29;
			var oExpected:Time = new Time(0, 1, 1, 1, 1, 1, false);
			
			var oNewTime:Time = TimeService.GetFutureDate(oTime, iDays)
			
			oResult.TestTrue(oNewTime.IsSameDay(oExpected));
			
			return oResult;
		}
		
		private static function GetMaxMonth0ForNullTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetMaxMonth0ForNullTime");
			var oTime:Time = null;
			
			oResult.expected = "0";
			oResult.actual = String(TimeService.GetMaxMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetMaxMonthForUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetMaxMonthForUseMonthFalse");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.expected = String(Time.MAX_SEASON);
			oResult.actual = String(TimeService.GetMaxMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetMaxMonthForUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetMaxMonthForUseMonthTrue");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, true);
			
			oResult.expected = String(Time.MAX_MONTH);
			oResult.actual = String(TimeService.GetMaxMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNextMonth0ForNullTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNextMonth0ForNullTime");
			var oTime:Time = null;
			
			oResult.expected = "0";
			oResult.actual = String(TimeService.GetNextMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNextMonth0ForTooSmallMonth():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNextMonth0ForTooSmallMonth");
			var oTime:Time = new Time(0, 0, -1);
			
			oResult.expected = "0";
			oResult.actual = String(TimeService.GetNextMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNextMonth0ForTooLargeMonthWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNextMonth0ForTooLargeMonthWithUseMonthFalse");
			var oTime:Time = new Time(0, 0, Time.MAX_SEASON + 1, 0, 0, 0, false);
			
			oResult.expected = "0";
			oResult.actual = String(TimeService.GetNextMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNextMonth0ForTooLargeMonthWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNextMonth0ForTooLargeMonthWithUseMonthTrue");
			var oTime:Time = new Time(0, 0, Time.MAX_MONTH + 1, 0, 0, 0, true);
			
			oResult.expected = "0";
			oResult.actual = String(TimeService.GetNextMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNextMonthReturnsNextMonthWithUseMonthFalse():Array
		{
			var lResults:Array = new Array();
			
			var lExpected:Array = [ 1, 2, 0 ];
			
			for (var i:int = 0; i <= Time.MAX_SEASON; i++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNextMonthReturnsNextMonthWithUseMonthFalse - Month " + Time.SEASONS[i]);
				var oTime:Time = new Time(0, 0, i, 0, 0, 0, false);
				
				oResult.expected = String(lExpected[i]);
				oResult.actual = String(TimeService.GetNextMonth(oTime));
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function GetNextMonthReturnsNextMonthWithUseMonthTrue():Array
		{
			var lResults:Array = new Array();
			
			var lExpected:Array = [ 1, 2, 3, 4, 5, 6, 7, 8, 0 ];
			
			for (var i:int = 0; i <= Time.MAX_MONTH; i++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNextMonthReturnsNextMonthWithUseMonthTrue - Month " + Time.MONTHS_LONG[i]);
				var oTime:Time = new Time(0, 0, i, 0, 0, 0, true);
				
				oResult.expected = String(lExpected[i]);
				oResult.actual = String(TimeService.GetNextMonth(oTime));
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function GetNumDaysBetweenThrowsExceptionIfBaseTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenThrowsExceptionIfBaseTimeNull");
			var oBaseTime:Time = null;
			var oCheckTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.expected = "null parameter: base";
			oResult.actual = "No exception";
			
			try
			{
				TimeService.GetNumDaysBetween(oBaseTime, oCheckTime);
			}
			catch (e:Error)
			{
				oResult.actual = e.message;
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenThrowsExceptionIfCheckTimeNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenThrowsExceptionIfCheckTimeNull");
			var oBaseTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			var oCheckTime:Time = null;
			
			oResult.expected = "null parameter: check";
			oResult.actual = "No exception";
			
			try
			{
				TimeService.GetNumDaysBetween(oBaseTime, oCheckTime);
			}
			catch (e:Error)
			{
				oResult.actual = e.message;
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenThrowsExceptionForIncompatibleTimes():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenThrowsExceptionForIncompatibleTimes");
			var oBaseTime:Time = new Time(0, 0, 0, 0, 0, 0, true);
			var oCheckTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.expected = "can only compare times with the same useMonth value";
			oResult.actual = "No exception";
			
			try
			{
				TimeService.GetNumDaysBetween(oBaseTime, oCheckTime);
			}
			catch (e:Error)
			{
				oResult.actual = e.message;
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenNegativeForPastDay():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenNegativeForPastDay");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 1, false);
			var oCheckTime:Time = new Time(0, 7, 1, 1, 0, 1, false);
			
			oResult.expected = "-2";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenNegativeForPastWeek():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenNegativeForPastWeek");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 1, false);
			var oCheckTime:Time = new Time(0, 6, 1, 1, 6, 1, false);
			
			oResult.expected = "-3";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenNegativeForPastMonthIfUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenNegativeForPastMonthIfUseMonthTrue");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 0, true);
			var oCheckTime:Time = new Time(0, 7, 0, 1, 0, 0, true);
			
			oResult.expected = "-30";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenNegativeForPastMonthIfUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenNegativeForPastMonthIfUseMonthFalse");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 1, false);
			var oCheckTime:Time = new Time(0, 7, 0, 1, 0, 0, false);
			
			oResult.expected = "-30";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenNegativeForPastYearIfUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenNegativeForPastYearIfUseMonthTrue");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 0, true);
			var oCheckTime:Time = new Time(0, 7, 1, 0, 0, 0, true);
			
			oResult.expected = "-254";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenNegativeForPastYearIfUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenNegativeForPastYearIfUseMonthFalse");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 1, false);
			var oCheckTime:Time = new Time(0, 7, 1, 0, 0, 1, false);
			
			oResult.expected = "-86";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenEqual():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenEqual");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 1, false);
			var oCheckTime:Time = new Time(0, 9, 1, 1, 2, 1, false);
			
			oResult.expected = "0";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenPositiveForFutureDay():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenPositiveForFutureDay");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 1, false);
			var oCheckTime:Time = new Time(0, 11, 1, 1, 4, 1, false);
			
			oResult.expected = "2";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenPositiveForFutureWeek():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenPositiveForFutureWeek");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 1, false);
			var oCheckTime:Time = new Time(0, 16, 1, 1, 2, 1, false);
			
			oResult.expected = "7";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenPositiveForFutureMonthIfUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenPositiveForFutureMonthIfUseMonthTrue");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 0, true);
			var oCheckTime:Time = new Time(0, 11, 2, 1, 4, 0, true);
			
			oResult.expected = "30";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenPositiveForFutureMonthIfUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenPositiveForFutureMonthIfUseMonthFalse");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 1, false);
			var oCheckTime:Time = new Time(0, 11, 2, 1, 4, 2, false);
			
			oResult.expected = "30";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenPositiveForFutureYearIfUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenPositiveForFutureYearIfUseMonthTrue");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 0, true);
			var oCheckTime:Time = new Time(0, 11, 1, 2, 4, 0, true);
			
			oResult.expected = "254";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumDaysBetweenPositiveForFutureYearIfUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetNumDaysBetweenPositiveForFutureYearIfUseMonthFalse");
			var oBaseTime:Time = new Time(0, 9, 1, 1, 2, 1, false);
			var oCheckTime:Time = new Time(0, 11, 1, 2, 4, 1, false);
			
			oResult.expected = "86";
			oResult.actual = String(TimeService.GetNumDaysBetween(oBaseTime, oCheckTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetPreviousMonth0ForNullTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetPreviousMonth0ForNullTime");
			var oTime:Time = null;
			
			oResult.expected = "0";
			oResult.actual = String(TimeService.GetPreviousMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetPreviousMonth0ForTooSmallMonth():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetPreviousMonth0ForTooSmallMonth");
			var oTime:Time = new Time(0, 0, -1);
			
			oResult.expected = "0";
			oResult.actual = String(TimeService.GetPreviousMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetPreviousMonth0ForTooLargeMonthWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetPreviousMonth0ForTooLargeMonthWithUseMonthFalse");
			var oTime:Time = new Time(0, 0, Time.MAX_SEASON + 1, 0, 0, 0, false);
			
			oResult.expected = "0";
			oResult.actual = String(TimeService.GetPreviousMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetPreviousMonth0ForTooLargeMonthWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetPreviousMonth0ForTooLargeMonthWithUseMonthTrue");
			var oTime:Time = new Time(0, 0, Time.MAX_MONTH + 1, 0, 0, 0, true);
			
			oResult.expected = "0";
			oResult.actual = String(TimeService.GetPreviousMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetPreviousMonthReturnsNextMonthWithUseMonthFalse():Array
		{
			var lResults:Array = new Array();
			var lExpected:Array = [ 2, 0, 1 ];
			
			for (var i:int = 0; i <= Time.MAX_SEASON; i++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetPreviousMonthReturnsNextMonthWithUseMonthFalse - Month " + Time.SEASONS[i]);
				oResult.expected = String(lExpected[i]);
				
				var oTime:Time = new Time(0, 0, i, 0, 0, 0, false);
				oResult.actual = String(TimeService.GetPreviousMonth(oTime));
				
				oResult.TestEquals();
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function GetPreviousMonthReturnsNextMonthWithUseMonthTrue():Array
		{
			var lResults:Array = new Array();
			var lExpected:Array = [ 8, 0, 1, 2, 3, 4, 5, 6, 7 ];
			
			for (var i:int = 0; i <= Time.MAX_MONTH; i++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetPreviousMonthReturnsNextMonthWithUseMonthTrue - Month " + Time.MONTHS_LONG[i]);
				oResult.expected = String(lExpected[i]);
				
				var oTime:Time = new Time(0, 0, i, 0, 0, 0, true);
				oResult.actual = String(TimeService.GetPreviousMonth(oTime));
				
				oResult.TestEquals();
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function GetSeasonForMonth0ForNullTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetSeasonForMonth0ForNullTime");
			var oTime:Time = null;
			
			oResult.expected = "0";
			oResult.actual = String(TimeService.GetSeasonForMonth(oTime));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetSeasonForMonthWithUseMonthFalse():Array
		{
			var lResults:Array = new Array();
			
			for (var i:int = 0; i <= Time.MAX_SEASON; i++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetSeasonForMonthWithUseMonthFalse - Month " + Time.SEASONS[i]);
				oResult.expected = String(i);
				
				var oTime:Time = new Time(0, 0, i, 0, 0, 0, false);
				oResult.actual = String(TimeService.GetSeasonForMonth(oTime));
				
				oResult.TestEquals();
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function GetSeasonForMonthWithUseMonthTrue():Array
		{
			var lResults:Array = new Array();
			var lExpected:Array = [ Time.SEASON_SPRING, Time.SEASON_SPRING, Time.SEASON_SPRING, Time.SEASON_SUMMER, Time.SEASON_SUMMER, Time.SEASON_SUMMER,
								    Time.SEASON_FALL, Time.SEASON_FALL, Time.SEASON_FALL ];
			
			for (var i:int = 0; i <= Time.MAX_SEASON; i++)
			{
				var oResult:UnitTestResult = new UnitTestResult("TimeService", "GetSeasonForMonthWithUseMonthTrue - Month " + Time.MONTHS_LONG[i]);
				oResult.expected = String(lExpected[i]);
				
				var oTime:Time = new Time(0, 0, i, 0, 0, 0, true);
				oResult.actual = String(TimeService.GetSeasonForMonth(oTime));
				
				oResult.TestEquals();
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function HasNextMonthThisYearFalseForNullTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasNextMonthThisYearFalseForNullTime");
			var oTime:Time = null;
			
			oResult.TestFalse(TimeService.HasNextMonthThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasNextMonthThisYearFalseWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasNextMonthThisYearFalseWithUseMonthFalse");
			var oTime:Time = new Time(0, Time.MAX_DATE, Time.MAX_SEASON, 0, 0, Time.MAX_SEASON, false);
			
			oResult.TestFalse(TimeService.HasNextMonthThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasNextMonthThisYearFalseWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasNextMonthThisYearFalseWithUseMonthTrue");
			var oTime:Time = new Time(0, Time.MAX_DATE, Time.MAX_MONTH, 0, 0, Time.MAX_SEASON, true);
			
			oResult.TestFalse(TimeService.HasNextMonthThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasNextMonthThisYearTrueWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasNextMonthThisYearTrueWithUseMonthFalse");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.TestTrue(TimeService.HasNextMonthThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasNextMonthThisYearTrueWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasNextMonthThisYearTrueWithUseMonthTrue");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, true);
			
			oResult.TestTrue(TimeService.HasNextMonthThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasPreviousMonthThisYearFalseForNullTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasPreviousMonthThisYearFalseForNullTime");
			var oTime:Time = null;
			
			oResult.TestFalse(TimeService.HasPreviousMonthThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasPreviousMonthThisYearFalseWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasPreviousMonthThisYearFalseWithUseMonthFalse");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.TestFalse(TimeService.HasPreviousMonthThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasPreviousMonthThisYearFalseWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasPreviousMonthThisYearFalseWithUseMonthTrue");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, true);
			
			oResult.TestFalse(TimeService.HasPreviousMonthThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasPreviousMonthThisYearTrueWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasPreviousMonthThisYearTrueWithUseMonthFalse");
			var oTime:Time = new Time(0, 0, 2, 0, 0, 2, false);
			
			oResult.TestTrue(TimeService.HasPreviousMonthThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasPreviousMonthThisYearTrueWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasPreviousMonthThisYearTrueWithUseMonthTrue");
			var oTime:Time = new Time(0, 0, 2, 0, 0, 0, true);
			
			oResult.TestTrue(TimeService.HasPreviousMonthThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasNextDayThisYearFalseForNullTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasNextDayThisYearFalseForNullTime");
			var oTime:Time = null;
			
			oResult.TestFalse(TimeService.HasNextDayThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasNextDayThisYearFalseWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasNextDayThisYearFalseWithUseMonthFalse");
			var oTime:Time = new Time(0, 27, 2, 0, 6, 2, false);
			
			oResult.TestFalse(TimeService.HasNextDayThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasNextDayThisYearFalseWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasNextDayThisYearFalseWithUseMonthTrue");
			var oTime:Time = new Time(0, 27, 8, 0, 6, 2, true);
			
			oResult.TestFalse(TimeService.HasNextDayThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasNextDayThisYearTrueWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasNextDayThisYearTrueWithUseMonthFalse");
			var oTime:Time = new Time(0, 27, 1, 0, 6, 1, false);
			
			oResult.TestTrue(TimeService.HasNextDayThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasNextDayThisYearTrueWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasNextDayThisYearTrueWithUseMonthTrue");
			var oTime:Time = new Time(0, 27, 7, 0, 6, 2, true);
			
			oResult.TestTrue(TimeService.HasNextDayThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasPreviousDayThisYearFalseForNullTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasPreviousDayThisYearFalseForNullTime");
			var oTime:Time = null;
			
			oResult.TestFalse(TimeService.HasPreviousDayThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasPreviousDayThisYearFalseWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasPreviousDayThisYearFalseWithUseMonthFalse");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, false);
			
			oResult.TestFalse(TimeService.HasPreviousDayThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasPreviousDayThisYearFalseWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasPreviousDayThisYearFalseWithUseMonthTrue");
			var oTime:Time = new Time(0, 0, 0, 0, 0, 0, true);
			
			oResult.TestFalse(TimeService.HasPreviousDayThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasPreviousDayThisYearTrueWithUseMonthFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasPreviousDayThisYearTrueWithUseMonthFalse");
			var oTime:Time = new Time(0, 1, 0, 0, 1, 0, false);
			
			oResult.TestTrue(TimeService.HasPreviousDayThisYear(oTime));
			
			return oResult;
		}
		
		private static function HasPreviousDayThisYearTrueWithUseMonthTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("TimeService", "HasPreviousDayThisYearTrueWithUseMonthTrue");
			var oTime:Time = new Time(0, 1, 0, 0, 1, 0, true);
			
			oResult.TestTrue(TimeService.HasPreviousDayThisYear(oTime));
			
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