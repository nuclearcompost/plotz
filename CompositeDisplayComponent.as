package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A component in composite menus that has a graphical representation
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//Extended By:
	//
	//-----------------------
	public class CompositeDisplayComponent
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
		
		private var _x:int;
		private var _y:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CompositeDisplayComponent(x:int = 0, y:int = 0)
		{
			_x = x;
			_y = y;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function Paint():MovieClip
		{
			trace("error, DisplayComponent base class Paint method called!");
			
			return null;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}