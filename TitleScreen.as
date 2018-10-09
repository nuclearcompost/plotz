package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class TitleScreen extends MovieClip
	{
		// Private Properties //
		private var _backGround:TitleBG_MC;
		private var _cloud:Title_RevisionNumberCloud_MC;
		private var _creditsBtn:Title_Btn;
		private var _loadGameBtn:Title_Btn;
		private var _main:Main;
		private var _newGameBtn:Title_Btn;
		
		//* Private Properties *//
		
		
		// Initialization //
		
		//---------------
		//Purpose:		Construct a new TitleScreen object
		//
		//Parameters:
		//	maint:Main = the Main object for the game that this title screen will be associated with
		//
		//Returns:		reference to the new object
		//---------------
		public function TitleScreen(main:Main)
		{
			_main = main;
			
			_backGround = new TitleBG_MC();
			_backGround.x = 600;
			_backGround.y = 450;
			this.addChild(_backGround);
			
			_cloud = new Title_RevisionNumberCloud_MC();
			_cloud.x = 600;
			_cloud.y = 450;
			_cloud.addEventListener(MouseEvent.ROLL_OVER, OnCloudRollOver, false, 0, true);
			_cloud.addEventListener(MouseEvent.ROLL_OUT, OnCloudRollOut, false, 0, true);
			this.addChild(_cloud);
			
			if (SaveGameService.HasSaveGameData() == true)
			{
				_loadGameBtn = new Title_Btn();
				UIManager.AssignButtonText(_loadGameBtn, "Load Game");
				_loadGameBtn.x = 150;
				_loadGameBtn.y = 650;
				_loadGameBtn.addEventListener(MouseEvent.CLICK, OnClickLoadGameBtn, false, 0, true);
				this.addChild(_loadGameBtn);
			}
			
			_newGameBtn = new Title_Btn();
			UIManager.AssignButtonText(_newGameBtn, "New Game");
			_newGameBtn.x = 150;
			_newGameBtn.y = 575;
			_newGameBtn.addEventListener(MouseEvent.CLICK, OnClickNewGameBtn, false, 0, true);
			this.addChild(_newGameBtn);
			
			_creditsBtn = new Title_Btn();
			UIManager.AssignButtonText(_creditsBtn, "Credits");
			_creditsBtn.x = 150;
			_creditsBtn.y = 725;
			_creditsBtn.addEventListener(MouseEvent.CLICK, OnClickCreditsBtn, false, 0, true);
			this.addChild(_creditsBtn);
		}
	
		//* Initialization *//
		
		
		// Protected Methods //
		
		/// Event Handlers ///
		
		protected function OnClickCreditsBtn(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_main.ModeSwapTitleToCredits();
		}
		
		protected function OnClickLoadGameBtn(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_main.ModeSwapTitleToGame(false);
		}
		
		protected function OnClickNewGameBtn(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_main.ModeSwapTitleToGame(true);
		}
		
		private function OnCloudRollOut(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_cloud.RevisionNumber.text = "";
		}
		
		private function OnCloudRollOver(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_cloud.RevisionNumber.text = GameSession.CURRENT_REVISION_NUMBER;
		}
		
		///* Event Handlers *///
		
		//* Protected Methods *//
	}
}