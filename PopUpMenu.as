package
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class PopUpMenu
	{
		// Constants //
		
		public static const TYPE_GAME_SAVED:int = 1;
		public static const TYPE_CONFIRM_SAVE_GAME:int = 2;
		public static const TYPE_CONFIRM_LOAD_GAME:int = 3;
		public static const TYPE_CONFIRM_SAVE_FOR_TUTORIAL_REPLAY:int = 4;
		public static const TYPE_GAME_LOADED:int = 5;
		public static const TYPE_CONFIRM_SAVE_ON_EXIT:int = 6;
		
		public static const BUTTON_OK:int = 0;
		public static const BUTTON_YES:int = 1;
		public static const BUTTON_NO:int = 2;
		public static const BUTTON_MAIN_MENU:int = 3;
		
		public static const BUTTON_NAME:Array = [ "OK", "Yes", "No" ];
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get dataObject():Object
		{
			return _dataObject;
		}
		
		public function set dataObject(value:Object):void
		{
			_dataObject = value;
		}
		
		public function get gameSession():GameSession
		{
			return _gameSession;
		}
		
		public function set gameSession(value:GameSession):void
		{
			_gameSession = value;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _dataObject:Object;
		private var _gameSession:GameSession;
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		Default constructor
		//
		//Parameters:
		//	
		//---------------
		public function PopUpMenu(gameSession:GameSession = null, type:int = 0, object:Object = null)
		{
			_gameSession = gameSession;
			_type = type;
			_dataObject = object;
		}
		
		//- Initializiation -//
		
		
		// Public Methods //
		
		public function Paint():MovieClip
		{
			var mcPopUpMenu:MovieClip = new MovieClip();
			var mcMenu:MovieClip = null;
			var btnOK:SimpleButton = null;
			var btnYes:SimpleButton = null;
			var btnNo:SimpleButton = null;
			
			switch (_type)
			{
				case PopUpMenu.TYPE_GAME_SAVED:
					mcMenu = new PopUpMenu_GameSaved_MC();
					mcPopUpMenu.addChild(mcMenu);
					
					btnOK = new PopUpMenu_Green_Btn();
					UIManager.AssignButtonText(btnOK, "OK");
					btnOK.x = 0;
					btnOK.y = 25;
					btnOK.addEventListener(MouseEvent.CLICK, OnClickSaveGameOKButton, false, 0, true);
					mcPopUpMenu.addChild(btnOK);
					break;
				case PopUpMenu.TYPE_CONFIRM_SAVE_GAME:
					mcMenu = new PopUpMenu_ConfirmSaveGame_MC();
					mcPopUpMenu.addChild(mcMenu);
					
					btnYes = new PopUpMenu_Green_Btn();
					UIManager.AssignButtonText(btnYes, "Yep");
					btnYes.x = -85;
					btnYes.y = 50;
					btnYes.addEventListener(MouseEvent.CLICK, OnClickConfirmSaveGameYesButton, false, 0, true);
					mcPopUpMenu.addChild(btnYes);
					
					btnNo = new PopUpMenu_Red_Btn();
					UIManager.AssignButtonText(btnNo, "Nope");
					btnNo.x = 85;
					btnNo.y = 50;
					btnNo.addEventListener(MouseEvent.CLICK, OnClickConfirmSaveGameNoButton, false, 0, true);
					mcPopUpMenu.addChild(btnNo);
					break;
				case PopUpMenu.TYPE_CONFIRM_LOAD_GAME:
					mcMenu = new PopUpMenu_ConfirmLoadGame_MC();
					mcPopUpMenu.addChild(mcMenu);
					
					btnYes = new PopUpMenu_Green_Btn();
					UIManager.AssignButtonText(btnYes, "Yep");
					btnYes.x = -85;
					btnYes.y = 50;
					btnYes.addEventListener(MouseEvent.CLICK, OnClickConfirmLoadGameYesButton, false, 0, true);
					mcPopUpMenu.addChild(btnYes);
					
					btnNo = new PopUpMenu_Red_Btn();
					UIManager.AssignButtonText(btnNo, "Nope");
					btnNo.x = 85;
					btnNo.y = 50;
					btnNo.addEventListener(MouseEvent.CLICK, OnClickConfirmLoadGameNoButton, false, 0, true);
					mcPopUpMenu.addChild(btnNo);
					break;
				case PopUpMenu.TYPE_CONFIRM_SAVE_FOR_TUTORIAL_REPLAY:
					mcMenu = new PopUpMenu_ConfirmSaveForTutorialReplay_MC();
					mcPopUpMenu.addChild(mcMenu);
					
					btnYes = new PopUpMenu_Green_Btn();
					UIManager.AssignButtonText(btnYes, "Yep");
					btnYes.x = -85
					btnYes.y = 50;
					btnYes.addEventListener(MouseEvent.CLICK, OnClickConfirmSaveForTutorialReplayYesButton, false, 0, true);
					mcPopUpMenu.addChild(btnYes);
					
					btnNo = new PopUpMenu_Red_Btn();
					UIManager.AssignButtonText(btnNo, "Nope");
					btnNo.x = 85;
					btnNo.y = 50;
					btnNo.addEventListener(MouseEvent.CLICK, OnClickConfirmSaveForTutorialReplayNoButton, false, 0, true);
					mcPopUpMenu.addChild(btnNo);
					break;
				case PopUpMenu.TYPE_GAME_LOADED:
					mcMenu = new PopUpMenu_GameLoaded_MC();
					mcPopUpMenu.addChild(mcMenu);
					
					btnOK = new PopUpMenu_Green_Btn();
					UIManager.AssignButtonText(btnOK, "OK");
					btnOK.x = 0;
					btnOK.y = 25;
					btnOK.addEventListener(MouseEvent.CLICK, OnClickLoadGameOKButton, false, 0, true);
					mcPopUpMenu.addChild(btnOK);
					break;
				case PopUpMenu.TYPE_CONFIRM_SAVE_ON_EXIT:
					mcMenu = new PopUpMenu_ConfirmSaveOnExit_MC();
					mcPopUpMenu.addChild(mcMenu);
					
					btnYes = new PopUpMenu_Green_Btn();
					UIManager.AssignButtonText(btnYes, "Yep");
					btnYes.x = -85
					btnYes.y = 50;
					btnYes.addEventListener(MouseEvent.CLICK, OnClickConfirmSaveOnExitYesButton, false, 0, true);
					mcPopUpMenu.addChild(btnYes);
					
					btnNo = new PopUpMenu_Red_Btn();
					UIManager.AssignButtonText(btnNo, "Nope");
					btnNo.x = 85;
					btnNo.y = 50;
					btnNo.addEventListener(MouseEvent.CLICK, OnClickConfirmSaveOnExitNoButton, false, 0, true);
					mcPopUpMenu.addChild(btnNo);
					break;
				default:
					break;
			}
			
			return mcPopUpMenu;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function OnClickEndDemoOKButton(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameSession.gameRoot.controller.ClosePopUpMenu();
			_gameSession.gameRoot.ModeSwapGameToTitle();
		}
		
		private function OnClickSaveGameOKButton(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameSession.gameRoot.controller.ClosePopUpMenu();
		}
		
		private function OnClickConfirmSaveGameYesButton(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameSession.gameRoot.controller.ClosePopUpMenu();
			_gameSession.SaveGame();
		}
		
		private function OnClickConfirmSaveGameNoButton(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameSession.gameRoot.controller.ClosePopUpMenu();
		}
		
		private function OnClickConfirmLoadGameYesButton(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameSession.gameRoot.controller.ClosePopUpMenu();
			_gameSession.LoadGame();
		}
		
		private function OnClickConfirmLoadGameNoButton(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameSession.gameRoot.controller.ClosePopUpMenu();
		}
		
		private function OnClickConfirmSaveForTutorialReplayYesButton(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameSession.gameRoot.controller.ClosePopUpMenu();
			_gameSession.ReplayTutorial();
		}
		
		private function OnClickConfirmSaveForTutorialReplayNoButton(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameSession.gameRoot.controller.ClosePopUpMenu();
		}
		
		private function OnClickLoadGameOKButton(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameSession.gameRoot.controller.ClosePopUpMenu();
		}
		
		private function OnClickConfirmSaveOnExitYesButton(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameSession.gameRoot.controller.ClosePopUpMenu();
			_gameSession.SaveGame();
			_gameSession.gameRoot.ModeSwapGameToTitle();
		}
		
		private function OnClickConfirmSaveOnExitNoButton(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameSession.gameRoot.controller.ClosePopUpMenu();
			_gameSession.gameRoot.ModeSwapGameToTitle();
		}
		
		//- Private Methods -//
	}
}