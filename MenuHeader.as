package
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class MenuHeader extends MovieClip
	{
		// Constants //
		
		public static const HEADER_BUTTON_CANCEL:int = 0;
		public static const HEADER_BUTTON_COLLAPSE_CHILD:int = 1;
		public static const HEADER_BUTTON_ADD:int = 2;
		
		private static const HEADER_BUTTON_START_PIXEL_X:int = 675;
		private static const HEADER_BUTTON_GAP_PIXEL_X:int = 45;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get gridHeight():int
		{
			// at the moment, the MenuHeader will always just be 1 Grid square high.
			return 1;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _buttons:Array;
		private var _gameController:GameController;
		private var _label:String;
		private var _labelSlotWidth:int;
		private var _menu:MenuFrame;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function MenuHeader(menu:MenuFrame, gameController:GameController, label:String, labelSlotWidth:int, buttons:Array)
		{
			_menu = menu;
			_gameController = gameController;
			_label = label;
			_labelSlotWidth = labelSlotWidth;
			_buttons = buttons.slice();
		}
		
		//- Initialization -//
		
		
		// Public Methods //
		
		public function Paint():MovieClip
		{
			var mcMenuHeader:MovieClip = new MovieClip();
			
			// label graphics
			var oLabelGraphics:MenuLabel_MC = new MenuLabel_MC();
			oLabelGraphics.x = 0;
			oLabelGraphics.y = 0;
			oLabelGraphics.gotoAndStop(_labelSlotWidth);
			mcMenuHeader.addChild(oLabelGraphics);
			
			// label
			oLabelGraphics.Label.text = _label;
			
			// button graphics			
			for (var b:int = 0; b < _buttons.length; b++)
			{
				var iBtnType:int = _buttons[b];
				
				var oBtnGraphics:SimpleButton = null;
				
				switch (iBtnType)
				{
					case MenuHeader.HEADER_BUTTON_CANCEL:
						oBtnGraphics = new MenuHeader_Close_Btn();
						oBtnGraphics.addEventListener(MouseEvent.CLICK, _gameController.OnClickCloseMenuHeaderButton);
						break;
					case MenuHeader.HEADER_BUTTON_COLLAPSE_CHILD:
						oBtnGraphics = new MenuHeader_Minimize_Btn();
						oBtnGraphics.addEventListener(MouseEvent.CLICK, _gameController.OnClickCollapseChildMenuHeaderButton);
						break;
					default:
						break;
				}
				
				oBtnGraphics.x = (MenuHeader.HEADER_BUTTON_START_PIXEL_X - (b * MenuHeader.HEADER_BUTTON_GAP_PIXEL_X)) + 22;
				oBtnGraphics.y = 22;
				
				mcMenuHeader.addChild(oBtnGraphics);
			}
			
			return mcMenuHeader;
		}
		
		public function AddCollapseChildButton():void
		{
			if (_buttons == null)
			{
				_buttons = [ MenuHeader.HEADER_BUTTON_COLLAPSE_CHILD ];
				return;
			}
			
			var bHasCollapseChildButton:Boolean = false;
			for (var i:int = 0; i < _buttons.length; i++)
			{
				var iBtn:int = int(_buttons[i]);
				
				if (iBtn == MenuHeader.HEADER_BUTTON_COLLAPSE_CHILD)
				{
					bHasCollapseChildButton = true;
					break;
				}
			}
			
			if (bHasCollapseChildButton == false)
			{
				_buttons.push(MenuHeader.HEADER_BUTTON_COLLAPSE_CHILD);
			}
		}
		
		public function RemoveCollapseChildButton():void
		{
			if (_buttons == null)
			{
				return;
			}
			
			for (var i:int = 0; i < _buttons.length; i++)
			{
				var iBtn:int = int(_buttons[i]);
				
				if (iBtn == MenuHeader.HEADER_BUTTON_COLLAPSE_CHILD)
				{
					_buttons.splice(iBtn, 1);
					i--;
				}
			}
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methodes -//
	}
}