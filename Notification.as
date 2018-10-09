package
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	//-----------------------
	//Purpose:				Base class for UI notifications to the player
	//
	//Properties:
	//	
	//Methods:
	//	
	//Extended By:
	//	CsaDayNotification
	//	CustomPlantEventNotification
	//	FirstDayOfSeasonNotification
	//	SaleCartSaleNotification
	//
	//-----------------------
	public class Notification
	{
		// Constants //
		
		public static const TYPE_CALENDAR:int = 0;
		public static const TYPE_WALLET:int = 1;
		
		private static const ALPHA_DELTA:Number = 0.0333;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get graphics():MovieClip
		{
			return _graphics;
		}
		
		// override in each child class
		public function get type():int
		{
			trace("Notification type getter called");
			return -1;
		}
		
		//- Public Properties -//
		
		
		// Protected Properties //
		
		protected var _currentAlpha:Number;
		protected var _displayTicks:int;
		protected var _graphics:MovieClip;
		protected var _tickCount:int;
		protected var _timer:Timer;
		protected var _uiManager:UIManager;
		
		//- Protected Properties -//
		
	
		// Initialization //
		
		public function Notification(uiManager:UIManager, displaySeconds:int)
		{
			_uiManager = uiManager;
			
			_currentAlpha = 1.0;
			_displayTicks = displaySeconds * 30;
			_tickCount = 0;
			
			_timer = new Timer(33);
			_timer.addEventListener(TimerEvent.TIMER, OnTimer);
			_timer.start();
		}
		
		//- Initialization -//
		
		
		// Public Methods //
		
		// Override in each child class
		public function Paint():MovieClip
		{
			trace("Notification Paint method called");
			return new MovieClip();
		}
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		//- Protected Methods -//
		
		
		// Private Methods //
		
		private function OnTimer(event:TimerEvent):void
		{
			_tickCount++;
			
			if (_tickCount >= _displayTicks)
			{
				_currentAlpha -= Notification.ALPHA_DELTA;
				
				if (_graphics != null)
				{
					_graphics.alpha = _currentAlpha;
				}
				
				if (_currentAlpha < Notification.ALPHA_DELTA)
				{
					_timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER, OnTimer);
					_timer = null;
					
					_uiManager.RemoveNotificationGraphics(_graphics);
				}
			}
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}