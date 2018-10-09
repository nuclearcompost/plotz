package
{
	//-----------------------
	//Purpose:				A grid location in the footer UI
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class FooterLocation
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get x():int
		{
			return _x;
		}
		
		public function set x(value:int):void
		{
			_x = value;
		}
		
		public function get y():int
		{
			return _y;
		}
		
		public function set y(value:int):void
		{
			_y = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _x;
		private var _y;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		
		//Parameters:
		//	
		//Returns:		
		//---------------
		public function FooterLocation(x:int = 0, y:int = 0)
		{
			_x = x;
			_y = y;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function GetPixelLocation():PixelLocation
		{
			var nX:Number = (_x * UIManager.FOOTER_PIXEL_WIDTH) + (UIManager.FOOTER_PIXEL_WIDTH / 2) + UIManager.FOOTER_X_PIXEL_OFFSET;
			var nY:Number = (_y * UIManager.FOOTER_PIXEL_HEIGHT) + (UIManager.FOOTER_PIXEL_HEIGHT / 2) + UIManager.FOOTER_Y_PIXEL_OFFSET;
			
			var oPixelLocation:PixelLocation = new PixelLocation(nX, nY);
			
			return oPixelLocation;
		}
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		//- Protected Methods -//
	}
}