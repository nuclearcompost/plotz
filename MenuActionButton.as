package
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class MenuActionButton extends MovieClip
	{
		// Constants //
		
		private static const LABEL:Array = [ "End Day", "Save Game", "Load Game", "Exit to Title", "Export Stats", "Replay Tutorial" ];
		
		public static const BTN_END_DAY:int = 0;
		public static const BTN_SAVE_GAME:int = 1;
		public static const BTN_LOAD_GAME:int = 2;
		public static const BTN_EXIT_TO_TITLE:int = 3;
		public static const BTN_EXPORT_STATS:int = 4;
		public static const BTN_REPLAY_TUTORIAL:int = 5;
		
		//* Constants *//
		
		// Public Properties //
		public function get type():int
		{
			return _type;
		}
		
		//* Public Properties *//
		
		
		// Private Properties //
		
		private var _gameController:GameController;
		private var _type:int;
		
		//* Private Properties *//
		
	
		// Initialization //
		public function MenuActionButton(type:int, gameController:GameController)
		{
			_type = type;
			_gameController = gameController;
		}
		//* Initialization *//
		
		
		// Public Methods //
		
		public function Paint():SimpleButton
		{
			var oButton:SimpleButton = new Menu_Action_Btn();
			
			UIManager.AssignButtonText(oButton, String(MenuActionButton.LABEL[_type]));
			
			oButton.addEventListener(MouseEvent.CLICK, OnMenuActionButtonClick);
			
			return oButton;
		}
		
		//* Public Methods *//
		
		
		// Protected Methods //
		
		protected function OnMenuActionButtonClick(event:MouseEvent):void
		{
			event.stopPropagation();
			_gameController.OnMenuActionButtonClick(_type);
		}
		
		//* Protected Methods *//
	}
	
}