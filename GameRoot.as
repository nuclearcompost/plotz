package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				The application root for a GameSession
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class GameRoot extends MovieClip
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get controller():GameController
		{
			return _gameController;
		}
		
		// REFACTOR:  right now this is needed b/c some of gameRoot's children like UIManager need to reach through the game root to main to access the stage and stage
		//   is weird so I don't know if you can make a function in gameRoot like GetStage():stage???  Since I'm in the middle of a huge ball of refactoring and can't
		//   test anything at the moment and I don't want to deal with this shit at the moment I'm going to play it safe and just make main accessible through this property.
		//   HOWEVER, I really don't know if any of gameRoot's children should or should need to access this in the future - I hope not.
		public function get main():Main
		{
			return _main;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _gameController:GameController;
		private var _gameSession:GameSession;
		private var _main:Main;
		private var _uiManager:UIManager;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function GameRoot(main:Main, newGame:Boolean)
		{
			_main = main;
			
			_gameSession = new GameSession(this, newGame);
			_uiManager = _gameSession.uiManager;
			_gameController = new GameController(this, _gameSession, _uiManager);
			
			this.addChild(_uiManager);
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function ModeSwapGameToTitle():void
		{
			_main.ModeSwapGameToTitle();
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}