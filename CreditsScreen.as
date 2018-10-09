package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class CreditsScreen extends MovieClip
	{
		// Private Properties //
		
		private var _backBtn:Title_Btn;
		private var _background:MovieClip;
		private var _main:Main;
		
		//- Private Properties -//
		
		
		// Initialization //
		
		public function CreditsScreen(main:Main)
		{
			_main = main;
			
			_background = new Credits_Background_MC();
			_background.x = 360;
			_background.y = 400;
			this.addChild(_background);
			
			_backBtn = new Title_Btn();
			UIManager.AssignButtonText(_backBtn, "Back");
			_backBtn.x = 150;
			_backBtn.y = 750;
			_backBtn.addEventListener(MouseEvent.CLICK, OnClickBackBtn, false, 0, true);
			this.addChild(_backBtn);
		}
	
		//- Initialization -//
		
		
		// Private Methods //
		
		private function OnClickBackBtn(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_main.ModeSwapCreditsToTitle();
		}
		
		//- Private Methods -//
	}
}