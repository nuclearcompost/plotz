package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Notify the player that the current day is the first day of a new season
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class FirstDayOfSeasonNotification extends Notification
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get type():int
		{
			return Notification.TYPE_CALENDAR;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _season:String;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function FirstDayOfSeasonNotification(uiManager:UIManager, displaySeconds:int, season:String = "")
		{
			super(uiManager, displaySeconds);
			
			_season = season;
			
			Paint();
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Paint():MovieClip
		{
			var mcNotification:Notification_FirstDayOfSeason_MC = new Notification_FirstDayOfSeason_MC();
			mcNotification.Season.text = _season;
			
			_graphics = mcNotification;
			return mcNotification;
		}
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		//- Protected Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}