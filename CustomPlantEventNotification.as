package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Notify the player that the current day has a custom plant event
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CustomPlantEventNotification extends Notification
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
		
		private var _plantType:int;
		private var _quantity:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CustomPlantEventNotification(uiManager:UIManager, displaySeconds:int, plantType:int, quantity:int)
		{
			super(uiManager, displaySeconds);
			
			_plantType = plantType;
			_quantity = quantity;
			
			Paint();
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Paint():MovieClip
		{
			var mcNotification:Notification_CustomPlantEvent_MC = new Notification_CustomPlantEvent_MC();
			var sMessage:String = "Plant " + _quantity + "\n" + Plant.NAME[_plantType];
			
			mcNotification.Message.text = sMessage;
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