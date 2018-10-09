package
{
	import flash.display.MovieClip;
	
//package
//{
//	//-----------------------
//	//Purpose:				
//	//Properties:
//	//	
//	//Methods:
//	//	
//	//-----------------------
//	public class UIManager
//	{
//		// Constants //
//		
//		//- Constants -//
//		
//		
//		// Public Properties //
//		
//		//- Public Properties -//
//		
//		
//		// Private Properties //
//		
//		//- Private Properties -//
//		
//	
//		// Initialization //
//		
//		public function UIManager()
//		{
//			
//		}
//	
//		//- Initialization -//
//		
//		
//		// Public Methods //
//		
//		//- Public Methods -//
//		
//		
//		// Private Methods //
//		
//		//- Private Methods -//
//		
//		
//		// Testing Methods //
//		
//		//- Testing Methods -//
//	}
//}
	
	
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	
		//---------------
		//Purpose:		
		//Parameters:
		//	
		//Returns:		
		//---------------
	
	//-----------------------
	//Purpose:				The document class for the swf movie, called on startup
	//
	//Public Properties:
	//	none
	//
	//Public Methods:
	//	StartGame():void
	//-----------------------
	public class Main extends MovieClip
	{
		// Constants //
		
		//- Constants -//
		
		
		// Private Properties //
		
		private var _credits:CreditsScreen;
		private var _game:GameRoot;
		private var _title:TitleScreen;
		
		//- Private Properties -//
	
	
		// Initialization //
		
		//---------------
		//Purpose:		Construct a new Main object
		//
		//Parameters:
		//	none
		//
		//Returns:		reference to the new object
		//---------------
		public function Main()
		{
			var iUnitTestOutputType:int = UnitTest.OUTPUT_NONE;
			
			if (iUnitTestOutputType != UnitTest.OUTPUT_NONE)
			{
				UnitTest.RunTests(iUnitTestOutputType);
			}
			
			ClearStage();
			PutUpTitle();
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function ModeSwapCreditsToTitle():void
		{
			TakeDownCredits();
			PutUpTitle();
		}
		
		public function ModeSwapGameToTitle():void
		{
			TakeDownGame();
			PutUpTitle();
		}
		
		public function ModeSwapTitleToCredits():void
		{
			TakeDownTitle();
			PutUpCredits();
		}
		
		public function ModeSwapTitleToGame(newGame:Boolean):void
		{
			TakeDownTitle();
			PutUpGame(newGame);
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//---------------
		//Purpose:		clear all objects from the stage
		//
		//Parameters:
		//	none
		//
		//Returns:		void
		//---------------
		private function ClearStage():void
		{
			for (var m:int = 0; m < this.numChildren; m++)
			{
				this.removeChildAt(0);
			}
		}
		
		private function PutUpCredits():void
		{
			_credits = new CreditsScreen(this);
			
			stage.addChild(_credits);
		}
		
		//---------------
		//Purpose:		Load the interface for a game session
		//
		//Parameters:
		//	newGame:Boolean = true if we should start a new game; false if we should load an existing game file
		//
		//Returns:		void
		//---------------
		private function PutUpGame(newGame:Boolean):void
		{
			_game = new GameRoot(this, newGame);
			
			stage.addChild(_game);
		}
		
		//---------------
		//Purpose:		Load the interface for the title screen
		//
		//Parameters:
		//	none
		//
		//Returns:		void
		//---------------
		private function PutUpTitle():void
		{
			_title = new TitleScreen(this);
			stage.addChild(_title);
		}
		
		private function TakeDownCredits():void
		{
			stage.removeChild(_credits);
		}
		
		//---------------
		//Purpose:		Remove the interface for the current game session
		//
		//Parameters:
		//	none
		//
		//Returns:		void
		//---------------
		private function TakeDownGame():void
		{
			stage.removeChild(_game);
		}

		//---------------
		//Purpose:		Remove the interface for the title
		//
		//Parameters:
		//	none
		//
		//Returns:		void
		//---------------
		private function TakeDownTitle():void
		{
			stage.removeChild(_title);
		}
		
		//- Private Methods -//
	}
}