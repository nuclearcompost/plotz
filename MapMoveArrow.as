package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MapMoveArrow extends MovieClip
	{
		// Constants //
		
		public static const DIR_UP:int = 1;
		public static const DIR_DOWN:int = 2;
		public static const DIR_LEFT:int = 3;
		public static const DIR_RIGHT:int = 4;
		
		public static const PIXEL_SIZE:int = 45;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get type():int
		{
			return _type;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _type:int;
		private var _uiManager:UIManager;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function MapMoveArrow(uiManager:UIManager, type:int)
		{
			_uiManager = uiManager;
			_type = type;
		}
		
		//- Initialization -//
		
	
		// Public Methods //
		
		public function Paint():MovieClip
		{
			var oGraphics:MovieClip = new MapMoveArrow_MC();
			oGraphics.gotoAndStop(_type);
			oGraphics.addEventListener(MouseEvent.CLICK, OnMouseClick, false, 0, true);
			
			switch (_type)
			{
				case 1:
					oGraphics.x = UIManager.SCREEN_PIXEL_WIDTH / 2;
					oGraphics.y = UIManager.HORIZON_PIXEL_HEIGHT;
					break;
				case 2:
					oGraphics.x = UIManager.SCREEN_PIXEL_WIDTH / 2;
					oGraphics.y = UIManager.FOOTER_Y_PIXEL_OFFSET;
					break;
				case 3:
					oGraphics.x = 0;
					oGraphics.y = UIManager.HORIZON_PIXEL_HEIGHT;
					break;
				case 4:
					oGraphics.x = UIManager.SCREEN_PIXEL_WIDTH;
					oGraphics.y = UIManager.HORIZON_PIXEL_HEIGHT;
					break;
				default:
					break;
			}
			
			return oGraphics;
		}
		
		//- Public Methods -//
		
		
		// Private Methods /
		
		private function OnMouseClick(event:MouseEvent):void
		{
			_uiManager.MoveMap(_type);
		}
		
		//- Private Methods -//
	}
	
}