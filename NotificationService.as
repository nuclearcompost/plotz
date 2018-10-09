package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Service logic for Notifications
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class NotificationService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _uiManager:UIManager;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function NotificationService(uiManager:UIManager)
		{
			_uiManager = uiManager;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function AddNotificationsForToday(time:Time, calendarStatTracker:CalendarStatTracker, csaState:CsaState):void
		{
			var iDisplaySeconds:int = 5;
			var iDisplaySecondsIncrement:int = 3;
			
			// first day of season //
			if (time.date == 0)
			{
				var oPreviousMonthTime:Time = time.GetClone();
				oPreviousMonthTime.month = TimeService.GetPreviousMonth(oPreviousMonthTime);
				var oPreviousMonthSeason:int = TimeService.GetSeasonForMonth(oPreviousMonthTime);
				
				if (oPreviousMonthSeason != time.season)
				{
					var oNotification:Notification = new FirstDayOfSeasonNotification(_uiManager, iDisplaySeconds, Time.SEASONS[time.season]);
					_uiManager.AddNotificationGraphics(oNotification.graphics, oNotification.type);
					iDisplaySeconds += iDisplaySecondsIncrement;
				}
			}
			
			// csa day //
			var iCsaDayType:int = CsaService.GetCsaDayType(time);
			var iNumCustomersSignedUp:int = CsaService.GetNumCustomersSignedUp(csaState);
			
			if (iCsaDayType == CsaState.DAY_TYPE_SIGNUP || (iCsaDayType == CsaState.DAY_TYPE_DELIVERY && iNumCustomersSignedUp > 0))
			{
				oNotification = new CsaDayNotification(_uiManager, iDisplaySeconds, iCsaDayType);
				_uiManager.AddNotificationGraphics(oNotification.graphics, oNotification.type);
				iDisplaySeconds += iDisplaySecondsIncrement;
			}
			
			// custom planting events //
			var lCustomPlantEvents:Array = calendarStatTracker.GetEventsOfTypeForDay(DayEvent.TYPE_CUSTOM_PLANT, time);
			
			if (lCustomPlantEvents.length > 0)
			{
				for (var i:int = 0; i < lCustomPlantEvents.length; i++)
				{
					var oCustomPlantEvent:CustomPlantEvent = CustomPlantEvent(lCustomPlantEvents[i]);
					
					oNotification = new CustomPlantEventNotification(_uiManager, iDisplaySeconds, oCustomPlantEvent.plantType, oCustomPlantEvent.occurrences);
					_uiManager.AddNotificationGraphics(oNotification.graphics, oNotification.type);
					iDisplaySeconds += iDisplaySecondsIncrement;
				}
			}
			
			// sale cart sales //
			if (time.date != 0 || time.month != 0 || time.year != 0)
			{
				var oYesterday:Time = time.GetClone();
				TimeService.BackUpDate(oYesterday);
				
				var lSaleCartEvents:Array = calendarStatTracker.GetEventsOfTypeForDay(DayEvent.TYPE_SALE_CART_SALE, oYesterday);
				var iAmount:int = 0;
				
				for (i = 0; i < lSaleCartEvents.length; i++)
				{
					var oEvent:SaleCartSaleEvent = SaleCartSaleEvent(lSaleCartEvents[i]);
					iAmount += (oEvent.occurrences * oEvent.price);
				}
				
				if (iAmount > 0)
				{
					oNotification = new SaleCartSaleNotification(_uiManager, 5, iAmount);
					_uiManager.AddNotificationGraphics(oNotification.graphics, oNotification.type);
				}
			}
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			return lResults;
		}
		
		//- Testing Methods -//
	}
}