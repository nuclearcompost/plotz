package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Notify the player that the current day is a CSA signup or delivery day
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CsaDayNotification extends Notification
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
		
		private var _csaDayType:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CsaDayNotification(uiManager:UIManager, displaySeconds:int, csaDayType:int)
		{
			super(uiManager, displaySeconds);
			
			_csaDayType = csaDayType;
			
			Paint();
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Paint():MovieClip
		{
			var mcNotification:Notification_CsaDay_MC = new Notification_CsaDay_MC();
			
			if (_csaDayType == CsaState.DAY_TYPE_SIGNUP)
			{
				mcNotification.Message.text = "It's your CSA\nSign-up day!";
			}
			else if (_csaDayType == CsaState.DAY_TYPE_DELIVERY)
			{
				mcNotification.Message.text = "It's your CSA\nDelivery day!";
			}
			
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