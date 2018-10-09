package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class PrecipitationService
	{
		// Constants //
		
		public static const SPEED_RAIN:int = 10;
		public static const SPEED_STORM:int = 15;
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		var _gameSession:GameSession;
		var _intensityCount:int;
		var _precipitationGraphics:MovieClip;
		var _precipitationSpeed:int;
		var _precipitationStepCount:int;
		var _precipitationTimer:Timer;
		var _uiManager:UIManager;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		
		//Parameters:
		//	
		//Returns:		
		//---------------
		public function PrecipitationService(gameSession:GameSession, uiManager:UIManager)
		{
			_gameSession = gameSession;
			_uiManager = uiManager;
			
			_intensityCount = 10;
			_precipitationGraphics = new MovieClip();
			_precipitationSpeed = 0;
			_precipitationStepCount = 0;
			
			// precipitation timer - fire every 1/30 of a second
			_precipitationTimer = new Timer(33);
			_precipitationTimer.addEventListener(TimerEvent.TIMER, OnPrecipitationTimer, false, 0, true);
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function StartPrecipitation(speed:int):void
		{
			_precipitationSpeed = speed;
			_precipitationStepCount = 0;
			AddRain();
			_precipitationTimer.start();
		}
		
		public function StopPrecipitation():void
		{
			_precipitationTimer.stop();
			_precipitationSpeed = 0;
			_precipitationGraphics = new MovieClip();
			_uiManager.RepaintPrecipitation(_precipitationGraphics);
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function AddRain():void
		{
			var mcRain:MovieClip = new Weather_Rain2_MC();
			mcRain.x = Math.floor(Math.random() * 720);
			mcRain.y = -800;
			_precipitationGraphics.addChild(mcRain);
		}
		
		private function OnPrecipitationTimer(event:TimerEvent):void
		{
			UpdatePrecipitationGraphics();
			_uiManager.RepaintPrecipitation(_precipitationGraphics);
		}
		
		private function UpdatePrecipitationGraphics():void
		{
			var iNumChildren:int = _precipitationGraphics.numChildren;
			
			for (var i:int = iNumChildren - 1; i >= 0; i--)
			{
				var oChild:DisplayObject = _precipitationGraphics.getChildAt(i);
					
				if (!(oChild is MovieClip))
				{
					continue;
				}
				
				oChild.y += _precipitationSpeed;
				
				if (oChild.y >= 0)
				{
					_precipitationGraphics.removeChild(oChild);
				}
			}
			
			_precipitationStepCount++;
			
			if (_precipitationStepCount >= _intensityCount)
			{
				AddRain();
				_precipitationStepCount = 0;
			}
		}
		
		//- Private Methods -//
	}
}